// import 'dart:html';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:native_screenshot_ext/native_screenshot_ext.dart';
import 'package:rainbow/main.dart';
import 'package:rainbow/rainbow/makeup_color_model.dart';
import 'package:rainbow/rainbow/widget_util.dart';
import 'package:screenshot/screenshot.dart';

import 'detector_painters.dart';
import 'scanner_utils.dart';

class CameraPreviewScanner extends StatefulWidget {
  const CameraPreviewScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  late CameraController _camera;
  bool _isDetecting = false;
  bool shouldShow = true;
  final CameraLensDirection _direction = CameraLensDirection.front;
  List<MakeupColorModel> springMakupList = [
    MakeupColorModel(
      name: 'No Makeup',
      color: Color(0x4DA2A1A1),
    ),
    MakeupColorModel(
      name: 'Soft Apricot',
      color: Color(0x66bb877a),
    ),
    MakeupColorModel(
      name: 'Coral Pink',
      color: Color(0x4db04345),
    ),
    MakeupColorModel(
      name: 'Rosy Moave',
      color: Color(0x4D9A7474),
    ),
  ];
  List<MakeupColorModel> summerMakupList = [
    MakeupColorModel(
      name: 'No Makeup',
      color: Color(0x4DA2A1A1),
    ),
    MakeupColorModel(
      name: 'Dusty Rose',
      color: Color(0x4d9f5e64),
    ),
    MakeupColorModel(
      name: 'Lilac',
      color: Color(0x4D8F718F),
    ),
    MakeupColorModel(
      name: 'Berry Red',
      color: Color(0x66862930),
    ),
  ];
  List<MakeupColorModel> fallMakupList = [
    MakeupColorModel(
      name: 'No Makeup',
      color: Color(0x4DA2A1A1),
    ),
    MakeupColorModel(
      name: 'Terracotta',
      color: Color(0x4da45334),
    ),
    MakeupColorModel(
      name: 'Burnt Orange',
      color: Color(0x4d8f3d02),
    ),
    MakeupColorModel(
      name: 'Dark Plum',
      color: Color(0x59460231),
    ),
  ];
  List<MakeupColorModel> winterMakupList = [
    MakeupColorModel(
      name: 'No Makeup',
      color: Color(0x4DA2A1A1),
    ),
    MakeupColorModel(
      name: 'True Red',
      color: Color(0x59701619),
    ),
    MakeupColorModel(
      name: 'Berry',
      color: Color(0x4d790d3b),
    ),
    MakeupColorModel(
      name: 'Dark Burgundy',
      color: Color(0x33440903),
    ),
  ];



  Color? colorData;
  ScreenshotController screenshotController = ScreenshotController();

  final FaceDetector _faceDetector = GoogleVision.instance
      .faceDetector(FaceDetectorOptions(enableContours: true));

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.high
          : ResolutionPreset.high,
      enableAudio: false,
    );
    await _camera.initialize();

    await _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          if (_faceDetector == null) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => Future.delayed(
          Duration(
            microseconds: 10,
          ),
          () => _isDetecting = false));
    });
  }

  void _takeSnapShot() async {
    try {
      String? path = await NativeScreenshot.takeScreenshot();
      debugPrint('Screenshot : $path');

      screenshotController.capture().then((Uint8List? img) async {
        debugPrint('Screenshot img : $img');

        final result = await ImageGallerySaver.saveImage(
          img!,
        );
        debugPrint('result : $result');
        if (!mounted) return;
        showSnackBar(context: context, text: '저장완료');
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        return null;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null || !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize!.height,
      _camera.value.previewSize!.width,
    );

    if (_scanResults is! List<Face>) return noResultsText;
    painter = FaceDetectorPainter(
      imageSize,
      _scanResults,
      colorData,
    );

    return CustomPaint(
      painter: painter,
    );
  }

  List<MakeupColorModel> getMakeupList() {
    List<MakeupColorModel> makeupList = [];
    if (userInfo['season'] == 'spring') {
      makeupList = springMakupList;
    } else if (userInfo['season'] == 'summer') {
      makeupList = summerMakupList;
    } else if (userInfo['season'] == 'autumn') {
      makeupList = fallMakupList;
    } else if (userInfo['season'] == 'winter') {
      makeupList = winterMakupList;
    }
    return makeupList;
  }

  Widget _buildImage() {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(_camera),
                  _buildResults(),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Row(
                      children: [
                        ...getMakeupList()
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    colorData = e.color;
                                  });
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: e.color.withOpacity(1.7),
                                      ),
                                    ),
                                    Text(
                                      e.name,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     CircleAvatar(
            //       radius: 30,
            //       backgroundColor: Colors.red,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildImage(),
      floatingActionButton: GestureDetector(
        onTap: () async {
          // shouldShow = false;
          // _takeSnapShot();
          // if (isDone) {
          //   shouldShow = true;
          // }
        },
        child: Icon(
          Icons.get_app,
          color: shouldShow ? Colors.white : Colors.transparent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,   );
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _faceDetector.close();
    });

    super.dispose();
  }
}
