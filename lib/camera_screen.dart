import 'package:blind/box.dart';
import 'package:blind/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  loadmodel() async
  {
    await Tflite.loadModel(
      model: "models/ssd_mobilenet.tflite",
      labels: "models/labels.txt",
    );
  }

  makeRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadmodel();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Blind Application"),
        centerTitle: true,
        backgroundColor: Color(0xFF90DFAA),
      ),
      body: Stack(
        children: <Widget>[
          HomeScreen(makeRecognitions: makeRecognitions,), //Camera widget
          Box(
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ), // box for object
        ],
      ),
    );
  }
}
