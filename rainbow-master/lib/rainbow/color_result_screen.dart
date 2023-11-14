import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rainbow/main.dart';
import 'package:rainbow/rainbow/fonts.dart';

class ColorResultScreen extends StatefulWidget {
  final Map<String, String> result;
  final File file;
  const ColorResultScreen({
    Key? key,
    required this.result,
    required this.file,
  }) : super(key: key);

  @override
  State<ColorResultScreen> createState() => _ColorResultScreenState();
}

class _ColorResultScreenState extends State<ColorResultScreen> {
  String backgroundImage = 'spring';
  String info = '';
  @override
  void initState() {
    super.initState();
    setUserInfo();
    setInfo();
  }

  setUserInfo() {
    setState(() {
      userInfo = widget.result;
    });
  }

  setInfo() {
    String str = '';
    if (widget.result['season']!.toLowerCase() == 'spring') {
      str = '''봄 웜톤
이미지 :  화사함, 사랑스러움
            
명도와 채도가 높은 노란빛이 도는 화사하고 밝은 
느낌의 컬러가 잘 어울리며 어두운 색과는 맞지 
않습니다. 특히  오렌지컬러와 코랄컬러를 
추천드립니다.
            
• 립- Nature Apricot
      Coral Pink
      Rosy Brown

• 제형- 매트보다는 쉬머, 글로시한 텍스쳐

• 헤어- 베이비브라운, 애쉬브라운, 밀크브라운

• 수지님, 로제님, 박민영님''';
    } else if (widget.result['season']!.toLowerCase() == 'summer') {
      str = '''여름 쿨톤
이미지 : 청초, 차가우면서 밝은

흰빛을 띄는 색상이 잘 어울리며, 부드럽고 차가운 
느낌의 핑크나 튀지 않는 파스텔 톤, 그레이가 섞인 
블루 계열이 잘 어울립니다. 반대로 지나치게 
채도가 진한 색은 잘 맞지 않습니다.

• 립- Dusty Rose
      Lilac
      Berry Red

•제형- 촉촉한 피부 표현, 글로시한 제품

•헤어- 애쉬브라운, 애쉬핑크, 다크브라운

• 김연아님, 이영애님, 김태리님''';
    } else if (widget.result['season']!.toLowerCase() == 'autumn') {
      str = '''가을 웜톤
이미지 : 성숙미와 고급진 이미지

가을웜톤의 경우 명도와 채도가 낮은 노란 빛이 
도는 흐리고 어두운 느낌의 컬러가 잘 어울리며 
파란 빛이 도는 색깔은 어울리지 않습니다. MLBB가 
가장 대표적으로 어울리는 컬러입니다.

• 립- Terracott  
      Burnt Orange 
      Dark Plum

• 제형- 매트하고 스머징한 제품

• 헤어- 골드브라운, 카키브라운, 레드와인

• 전지현님, 이효리님, 한예슬님''';
    } else if (widget.result['season']!.toLowerCase() == 'winter') {
      str = '''겨울 쿨톤
이미지 : 도시적인, 모던, 세련

짙은 색의 컬러가 어울리며 따뜻한 색은 피하는 게 
좋습니다. 또한 버건디, 핫핑크가 잘 어울리며 골드
보다는 실버가 잘 어울립니다.

• 립- True Red
      Berry
      Dark Burgundy

• 제형- 매트

• 헤어- 블루블랙, 블랙, 화이트블론드

• 현아님, 임지연님, 김혜수님''';
    }

    setState(() {
      info = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 40,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 297,
              height: 394,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/${widget.result['season']!.toLowerCase()}.jpg',
                    // 'assets/summer.jpg',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Image.file(
              widget.file,
              width: 120,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '당신의 컬러는',
              textAlign: TextAlign.center,
              style: kTs.copyWith(
                fontSize: 16,
              ),
            ),
            Text(
              '${widget.result['season']!.toUpperCase()} ${widget.result['tone']!.toUpperCase()} 톤/ ${widget.result['pccs']!.toUpperCase()} ',
              textAlign: TextAlign.center,
              style: kTs.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xE9E779CD),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // color: Colors.amber,
              width: 300,
              child: Text(
                info,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
