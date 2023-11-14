// @dart=2.17

import 'package:flutter/material.dart';
import 'package:rainbow/main.dart';

import 'package:rainbow/rainbow/color_result_screen.dart';
import 'package:rainbow/rainbow/fonts.dart';

import 'CameraScreen.dart';

class MainPage extends StatefulWidget {
  final VoidCallback onTapMakeUp;
  const MainPage({
    Key? key,
    required this.onTapMakeUp,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffd9d9d9),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              personalColorResult == null
                  ? Expanded(
                      child: Column(
                        children: [
                          const Spacer(),
                          Image.asset(
                            'assets/splash2.png',
                            width: size.width * 0.5,
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: ColorResultScreen(
                          result: personalColorResult!,
                          file: imageFile!,
                        ),
                      ),
                    ),
              if (personalColorResult == null)
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => CameraScreen()),
                      ),
                    );
                    setState(() {
                      personalColorResult = result['result'];
                      imageFile = result['file'];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff646464),
                    fixedSize: Size(
                      size.width * 0.8,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(48),
                      ),
                    ),
                  ),
                  child: Text(
                    '퍼스널 컬러 측정하기',
                    style: kTs.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onTapMakeUp();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: ((context) => VirtualMakeUp())),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff646464),
                  fixedSize: Size(
                    size.width * 0.8,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(48),
                    ),
                  ),
                ),
                child: Text(
                  '퍼스널 컬러 가상 메이크업',
                  style: kTs.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: personalColorResult == null ? 80 : 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
