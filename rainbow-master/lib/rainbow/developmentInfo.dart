import 'package:flutter/material.dart';
import 'package:rainbow/rainbow/fonts.dart';

class DevelopmentInfo extends StatelessWidget {
  const DevelopmentInfo({super.key});

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
          height: 300,
          padding: EdgeInsets.all(16),
          child: Text(
              '팀 레인보우\n\n상명대학교 휴먼지능정보공학전공\n\n201715060 강임구\n201710771 박건호\n202010773 박민희\n202010774 박성현\n202015041 이세연',
              style: kTs.copyWith(
                  // fontFamily: 'Roboto',
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
