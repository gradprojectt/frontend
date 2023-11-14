import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:rainbow/main.dart';
import 'package:rainbow/rainbow/dio_util.dart';
import 'package:rainbow/rainbow/rainbow.dart';
import 'package:rainbow/rainbow/widget_util.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;
  File? imageFile;
  List<Face> faces = [];
  Map<String, String>? result;
  bool isLoading = false;
  final FaceDetector _faceDetector = GoogleVision.instance.faceDetector();

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('cameraException: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    onNewCameraSelected(cameras[1]);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('error occured while taking picture: $e');
      return null;
    }
  }

  flutterDialog() async {
    // classifier 호출
    setState(() {
      isLoading = true;
    });
    try {
      if (imageFile == null) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(faces.isEmpty ? "얼굴이 나오게 촬영해 주세요" : "사진을 촬영해 주세요"),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("확인"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }

      // TODO DEV
      if (kDebugMode) {
        // File file = File(
        //     '/data/user/0/com.example.rainbow/cache/KakaoTalk_20210128_233910032.jpg');
        File file = File('/sdcard/Pictures/test-image.jpg');
        if (file.existsSync()) {
          debugPrint('exist!!!');
          imageFile = file;
        }

        debugPrint(imageFile!.path);
      }

      final res = await dio.post(
        'http://3.35.249.235:5000/classifier',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
        data: FormData.fromMap({
          'file': [
            await MultipartFile.fromFile(
              imageFile!.path,
              filename: imageFile!.path.split('/').last,
            ),
          ],
          'userId': userId,
        }),
      );
      setState(() {
        isLoading = false;
      });
      if (res.statusCode == 200) {
        result = Map.from(res.data);
        debugPrint('결과값 : ${result.toString()}');
        if (!mounted) return;
        Navigator.pop(context, {
          'result': result,
          'file': imageFile,
        });
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           ColorResultScreen(result: result!, file: imageFile!),
        //     ));
      }
    } catch (e) {
      showSnackBar(context: context, text: 'error:${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffd9d9d9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _isCameraInitialized
                        ? AspectRatio(
                            aspectRatio: 1 / controller!.value.aspectRatio,
                            child: imageFile == null
                                ? controller!.buildPreview()
                                : Image.file(imageFile!),
                          )
                        : Container(),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () async {
                            XFile? rawImage = await takePicture();
                            imageFile = File(rawImage!.path);
                            if (kDebugMode) {
                              imageFile =
                                  File('/sdcard/Pictures/test-image.jpg');
                            }
                            GoogleVisionImage visionImage =
                                GoogleVisionImage.fromFile(imageFile!);
                            faces =
                                await _faceDetector.processImage(visionImage);
                            print(faces[0]);
                            faces[0].getLandmark(FaceLandmarkType.bottomMouth);
                            if (faces.isEmpty) {
                              // imageFile = null;
                              print("No face!");
                              setState(() {});
                            }
                            GallerySaver.saveImage(imageFile!.path);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle,
                                  color: Colors.white38, size: 80),
                              Icon(Icons.circle, color: Colors.white, size: 65),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isLoading)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // print('다시 촬영 클릭 됨');
                    imageFile = null;
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff646464),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(48),
                      ),
                    ),
                  ),
                  child: Text(
                    "다시 촬영",
                    style: TextStyle(fontSize: 25, color: Color(0xFFd9d9d9), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // print('측정하기 클릭 됨');
                    if (imageFile == null && faces.isEmpty) {
                      showSnackBar(context: context, text: '사진을 다시 촬영해주세요.');
                    } else {
                      await flutterDialog();
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff646464),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(48),
                      ),
                    ),
                  ),
                  child: Text(
                    "측정하기",
                    style: TextStyle(fontSize: 25, color: Color(0xFFd9d9d9), fontWeight: FontWeight.bold),

                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
