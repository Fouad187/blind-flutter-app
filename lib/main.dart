import 'package:blind/camera_screen.dart';
import 'package:blind/home_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}


