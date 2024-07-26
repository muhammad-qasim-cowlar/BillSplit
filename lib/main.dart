import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:text_recognition_app/home_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('ocrData');  // Open a Hive box named 'ocrData'
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
        theme: ThemeData.dark(),
        home: HomeScreen(
          camera: firstCamera,
        )),
  );
}
