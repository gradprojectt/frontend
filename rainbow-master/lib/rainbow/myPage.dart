import 'package:flutter/material.dart';
import 'package:rainbow/rainbow/developmentInfo.dart';
import 'package:rainbow/rainbow/dio_util.dart';
import 'package:rainbow/rainbow/fonts.dart';
import 'package:rainbow/rainbow/license_screen.dart';
import 'package:rainbow/rainbow/widget_util.dart';
import '../main.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? error;

  @override
  void initState() {
    debugPrint('MyPage init');
    // fetchMyInfo();
    super.initState();
  }

  // fetchMyInfo() async {
  //   final resUserInfo = await fetchUserInfo();
  //   debugPrint(resUserInfo);
  // }

  onTapChangeNickname() async {
    FocusScope.of(context).unfocus();
    final res = await fetchNickName(textControllerNickName.text.trim());
    if (res != null) {
      setState(() {
        textControllerNickName.text = res['nickName'];
        userInfo['nickName'] = res['nickName'];
      });
      if (!mounted) return;
      showSnackBar(context: context, text: '변경 완료');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Color(0xffd9d9d9),
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xffd9d9d9),
                    child: Image.network(
                      "https://i.ibb.co/CwzHq4z/trans-logo-512.png",
                      width: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: textControllerNickName,
                          autovalidateMode: AutovalidateMode.always,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: '닉네임',
                            labelStyle: kTs.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            // 유저의 기존 아이디로 변경해야함.
                            hintText: userInfo['nickName'] ?? '',
                          ),
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return '닉네임을 입력해주세요.';
                            }
                            if (2 > input.length) {
                              return '닉네임이 너무 짧습니다.';
                            }
                            if (input.length > 16) {
                              return '닉네임이 너무 깁니다.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (input) {
                            setState(() {
                              if (input.length >= 2 && input.length <= 16) {
                                userInfo['nickName'] =
                                    textControllerNickName.text;
                                // print(nickName);
                              } else {
                                textControllerNickName.text =
                                    userInfo['nickName'] ?? '';
                              }
                              // print(nickName);
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onTapChangeNickname();
                        },
                        child: Text(
                          '변경',
                          style: kTs,

                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        "내 퍼스널컬러 : ",
                        style: kTs.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        userInfo == null
                            ? ''
                            : '${userInfo['season'] ?? ''}, ${userInfo['tone'] ?? ''}',
                        style: kTs.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // DropdownButton(
                      //   alignment: Alignment.topLeft,
                      //   borderRadius: BorderRadius.all(Radius.circular(30)),
                      //   value: cur_pc_type,
                      //   items: pc_type
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(
                      //         value,
                      //         style: TextStyle(
                      //             fontSize: 18, fontWeight: FontWeight.bold),
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? value) {
                      //     setState(() {
                      //       cur_pc_type = value!;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DevelopmentInfo()),
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Developers >",
                  style: kTs.copyWith(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LicenseScreen()),
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Reference >",
                  style: kTs.copyWith(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
