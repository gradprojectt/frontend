// @dart=2.17
import 'package:flutter/material.dart';
import 'package:rainbow/rainbow/data.dart';
import 'package:rainbow/rainbow/fonts.dart';

class WhatIsPC extends StatelessWidget {
  const WhatIsPC({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                width: 350,
                // height: size.height - 300,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '퍼스널 컬러란?',
                      style: kTs.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\n\n타고난 개인의 신체 컬러를 말하며, 봄웜톤, 여름쿨톤, 가을웜톤, 겨울쿨톤 4가지로 분류할 수 있습니다.\n\n퍼스털 컬러를 통해 자신과 조화롭게 어울려 생기가 있어 보이게 할 수 있습니다.',
                      style: kTs.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            _buildRow('assets/spr.png', springInfo, springInfoTitle),
            const SizedBox(
              height: 30,
            ),
            _buildRow('assets/sum.png', summerInfo, summerInfoTitle),
            const SizedBox(
              height: 30,
            ),
            _buildRow('assets/aut.png', autumnInfo, autumnInfoTitle),
            const SizedBox(
              height: 30,
            ),
            _buildRow('assets/win.png', winterInfo, winterInfoTitle),
          ],
        ),
      ),
    );
  }

  Row _buildRow(String imagePath, String info, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          width: 100,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: kTs.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xF9357529),
                ),
              ),
              Text(
                info,
                style: kTs.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
