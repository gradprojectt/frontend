// @dart=2.17
import 'package:flutter/material.dart';
import 'package:rainbow/rainbow/fonts.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd9d9d9),
      appBar: AppBar(
        backgroundColor: Color(0xffd9d9d9),
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset(
          'assets/splash2.png',
          height: 40,
        ),
        centerTitle: true,
        elevation: 20,
      ),
      body: Center(
        child: Container(
          width: 350,
          height: 250,
          padding: EdgeInsets.all(16),
          child: Text(
              '우리 앱은 한국인 맞춤 퍼스널 컬러 진단기입니다.\n기존의 퍼스널 컬러 진단기는 외국인의 피부 톤을 \n기준으로 한국인에게 정밀한 결과 값을 제공하기 \n어려운 반면 우리 앱은 한국인 만을 분석하여 \n그에 맞는 보다 정확한 퍼스널 컬러를 찾아드립니다.\n또한 퍼스널 컬러를 통해 자신에게 맞는 \n립 메이크업의 색을 제안합니다.',
              style: kTs.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height:
                      1.14, // line-height is the ratio of font-size so we set it as line-height/font-size.
                  letterSpacing:
                      1 // letter-spacing in Flutter is expressed in logical pixels.
                  ),
              textAlign:
                  TextAlign.center // Align the text to center within its box.
              ),
        ),
      ),
    );
  }
}
