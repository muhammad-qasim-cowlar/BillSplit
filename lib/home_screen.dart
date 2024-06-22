import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:text_recognition_app/recognizer_screen.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({super.key, required this.camera});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;
    if (mounted) {
      setState(() {}); // Rebuild the widget after the controller is initialized
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 50),
            Card(
              color: Colors.black,
              child: SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.home,
                          size: 35,
                          color: Colors.white,
                        ),
                        onTap: () => {},
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.camera,
                          size: 50,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          try {
                            await _initializeControllerFuture;
                            final image = await _controller.takePicture();
                            if (!context.mounted) return;

                            File fImage = File(image.path);
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RecognizerScreen(fImage),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.image_outlined,
                          size: 35,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          final xfile = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (xfile != null) {
                            File image = File(xfile.path);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return RecognizerScreen(image);
                            }));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
