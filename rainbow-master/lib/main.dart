// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rainbow/rainbow/rainbow.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> pc_type = <String>['봄 웜톤', '여름 쿨톤', '가을 웜톤', '겨울 쿨톤'];
// List<CameraDescription>? cameras;
//유저의 설정된 퍼스널컬러로 변경해야 함.
String cur_pc_type = '여름 쿨톤';
String userId = '';
Map<String, dynamic> userInfo = {};
// String nickName = '';
String image_url = "https://i.ibb.co/CwzHq4z/trans-logo-512.png";
List<CameraDescription> cameras = [];
TextEditingController textControllerNickName = TextEditingController();
late final SharedPreferences prefs;
bool isViewMakeup = false;

Map<String, String>? personalColorResult;
File? imageFile;

void main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('cameraException $e');
  }
  prefs = await SharedPreferences.getInstance();
  // cameras = await availableCameras();
  // FlutterNativeSplash.

  // Storage 권한
  // if (!await Permission.storage.isGranted) {
  //   Map<Permission, PermissionStatus> status =
  //       await [Permission.storage].request();
  //   if (!status[Permission.storage]!.isGranted) {
  //     openAppSettings();
  //   }
  // }

  if (await Permission.manageExternalStorage.isDenied) {
    debugPrint('no access storage');
    await Permission.manageExternalStorage.request();
    debugPrint('access storage granted');
  }

  runApp(
    MaterialApp(
      home: Rainbow(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Heebo",
      ),
    ),
  );
  // FlutterNativeSplash.remove();
}
