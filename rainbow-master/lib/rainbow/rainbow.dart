import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rainbow/rainbow/dio_util.dart';
import 'package:rainbow/rainbow/fonts.dart';
import 'package:rainbow/rainbow/help.dart';
import 'package:rainbow/rainbow/virtualMakeUp.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'home.dart';
import 'myPage.dart';
import 'whatIsPC.dart';
import 'mainPage.dart';
import '../main.dart';

Color rainbowPrimaryColor = Color.fromARGB(255, 38, 103, 240);

class Rainbow extends StatefulWidget {
  const Rainbow({Key? key}) : super(key: key);

  @override
  State<Rainbow> createState() => _Rainbow();
}

class _Rainbow extends State<Rainbow> {
  int currentIndex = 0;

  @override
  void initState() {
    fetchInit();

    super.initState();
  }

  fetchInit() async {
    String? spUserId = prefs.getString('userId');
    if (spUserId != null) {
      // 저장한 아이디가 있으면
      userId = spUserId;
    } else {
      final resUserId = await fetchUserId();
      if (resUserId != null) {
        userId = resUserId;
      }
    }

    if (userId.isNotEmpty) {
      debugPrint('userId:$userId');
      await prefs.setString('userId', userId);

      final resUserInfo = await fetchUserInfo();
      if (resUserInfo != null) {
        setState(() {
          userInfo = resUserInfo;
          textControllerNickName.text = userInfo['nickName'] ?? '';
        });

        if (userInfo['nickName'] == null) {
          // 닉네임 없는 경우 무지개로 초기화
          final resNickname = await fetchNickName('무지개');
          if (resNickname != null) {
            setState(() {
              userInfo['nickName'] = resNickname['nickName'];
              textControllerNickName.text = resNickname['nickName'];
            });
          }
        }
        setState(() {});
      }
    }
  }

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
      body: IndexedStack(
        index: currentIndex, // index 순서에 해당하는 child를 맨 위에 보여줌
        children: [
          Home(),
          isViewMakeup
              ? VirtualMakeUp()
              : MainPage(
                  onTapMakeUp: () {
                    setState(() {
                      isViewMakeup = true;
                    });
                  },
                ),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // 현재 보여주는 탭
        onTap: (newIndex) {
          print("selected newIndex : $newIndex");
          // 다른 페이지로 이동
          setState(() {
            isViewMakeup = false;
            currentIndex = newIndex;
          });
        },
        selectedItemColor: rainbowPrimaryColor, // 선택된 아이콘 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이콘 색상
        type: BottomNavigationBarType.fixed, // 선택시 아이콘 움직이지 않기
        backgroundColor: Color(0xff646464),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xffd9d9d9),
            ),
            label: "홈",
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/splash2.png',
                height: 30,
              ),
              label: "측정하기"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color(0xffd9d9d9),
            ),
            label: "마이페이지",
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  DrawerHeader(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Color(0xFF646464),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.white,
                              child: Image.network(
                                "https://i.ibb.co/CwzHq4z/trans-logo-512.png",
                                width: 40,
                              ),
                            ),
                          ),
                          Text(
                            userInfo['nickName'] ?? '',
                            style: kTs.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${userInfo['season'] ?? ''}, ${userInfo['tone'] ?? ''}',
                            style: kTs.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => WhatIsPC()))),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "퍼스널컬러란?",
                          style: kTs.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: ((context) => Help()))),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "도움말",
                          style: kTs.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "정말로 종료하시겠습니까?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "취소",
                                    style:
                                        TextStyle(color: rainbowPrimaryColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    SystemNavigator.pop();
                                  },
                                  child: Text(
                                    "종료",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
