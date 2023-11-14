// @dart=2.17
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffd9d9d9),
      body: Center(
        child: Image.asset(
          'assets/splash2.png',
          width: size.width * 0.5,
        ),
      ),
    );
  }
}
