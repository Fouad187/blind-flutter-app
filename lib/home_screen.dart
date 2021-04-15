import 'package:audioplayers/audio_cache.dart';
import 'package:blind/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tflite/tflite.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class HomeScreen extends StatefulWidget {
  final Callback makeRecognitions;
  HomeScreen({this.makeRecognitions});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWorking = false;
  CameraController cameraController;
  CameraImage cameraImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cameraController= new CameraController(
      cameras[0],
      ResolutionPreset.high,
    );

    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      cameraController.startImageStream((CameraImage img) {
        if (!isWorking) {
          isWorking = true;
          Tflite.detectObjectOnFrame(
            bytesList: img.planes.map((plane) {return plane.bytes;}).toList(),
            model: "SSDMobileNet",
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: 127.5,
            imageStd: 127.5,
            numResultsPerClass: 1,
            threshold: 0.6,
          ).then((recognitions) {

            widget.makeRecognitions(recognitions, img.height, img.width);
            isWorking = false;
          });
        }
      });
    });
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(cameraController == null || !cameraController.value.isInitialized)
      {
        return Container();
      }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);

    tmp = cameraController.value.previewSize;

    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);

    var screenRatio = screenH / screenW;

    var previewRatio = previewH / previewW;

    return OverflowBox(
            maxHeight: screenRatio > previewRatio ? screenH : screenW/previewW*previewH,
            maxWidth: screenRatio > previewRatio  ? screenH/previewW*previewH : screenW,
            child: CameraPreview(cameraController),
          );
  }
}
