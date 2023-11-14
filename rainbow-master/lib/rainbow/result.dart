import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rainbow/rainbow/virtualMakeUp.dart';
import 'package:photo_manager/photo_manager.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  List<AssetEntity>? latestPhotos; // 최신 사진을 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadLatestPhoto();
  }

  // 가장 최신의 사진을 불러오는 함수
  Future<void> _loadLatestPhoto() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      final albums = await PhotoManager.getAssetPathList(onlyAll: true);
      if (albums.isNotEmpty) {
        final latestAlbum = albums.first;
        final assets = await latestAlbum.getAssetListRange(start: 0, end: 1);
        setState(() {
          latestPhotos = assets;
        });
      }
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // fetchLatestPhoto();
  // }

  Future<Map<String, String>> fetchData() async {
    final response =
        await http.post("http://3.35.249.235:5000/classifier" as Uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String pccs = data["pccs"];
      String season = data["season"];
      String tone = data["tone"];

      return {
        "pccs": pccs,
        "season": season,
        "tone": tone,
      };
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('에러: ${snapshot.error}');
          } else {
            final data = snapshot.data;

            String result =
                "당신의 컬러는 ${data!['season']} ${data['tone']} ${data['pccs']} ";

            return Column(
              children: [
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: latestPhotos == null
                          ? CircularProgressIndicator()
                          : Container()

                      //     Image.memory(
                      //   await latestPhoto!.originBytes,
                      //   fit: BoxFit.cover,
                      // ),
                      ),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(result),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      // '가상필터 체험하기' 버튼 클릭 시 'VirtualMakeUp'으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VirtualMakeUp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey, // 텍스트 색상을 흰색으로 설정
                    ),
                    child: Text('가상 메이크업 체험하기'), // 버튼 텍스트
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}




// Container(
    //   height: 40,
    //   width: MediaQuery.of(context).size.width,
    //   child: Center(child: Text('이미지 :  화사함, 사랑스러움')),
    // ),
    // Container(
    //   height: 150,
    //   width: MediaQuery.of(context).size.width,
    //   child: Center(child: Text('명도와 채도가 높은 노란빛이 도는 화사하고 밝은 느낌의 컬러가 잘 어울리며 어두운 색과는 맞지 않습니다. 특히  오렌지컬러와 코랄컬러를 추천드립니다. ')),
    // ),
    // Container(
    //   height: 60,
    //   width: MediaQuery.of(context).size.width,
    //   child: Center(child: Text('컬러 : Soft Apricot(E0B392), Coral Pink(F88379), Rosy Moave(A17188)')),
    // ),
    // Container(
    //   height: 30,
    //   width: MediaQuery.of(context).size.width,
    //   child: Center(child: Text('제형 : 매트보다는 쉬머, 글로시한 텍스쳐')),
    // ),
    // Container(
    //   height: 30,
    //   width: MediaQuery.of(context).size.width,
    //   child: Center(child: Text('대표 연예인 : 수지님, 로제님, 박민영님')),
    // ),
    // Container(
    //   height: 30,
    //   width: MediaQuery.of(context).size.width,
    //   child: Center(child: Text('헤어컬러 : 베이비브라운, 매트브라운, 애쉬브라운, 밀크브라운')),
    // ),


