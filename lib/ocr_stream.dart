import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRCameraPreview extends StatefulWidget {
  @override
  _OCRCameraPreviewState createState() => _OCRCameraPreviewState();
}

class _OCRCameraPreviewState extends State<OCRCameraPreview> {
  CameraController? _cameraController;
  late TextRecognizer _textRecognizer;
  String _recognizedText = '';
  late StreamController<String> _textStreamController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _textRecognizer = TextRecognizer();
    _textStreamController = StreamController<String>();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await _cameraController!.initialize();
    _cameraController!.startImageStream((CameraImage image) {
      _performOCR(image);
    });
    setState(() {});
  }

  Future<void> _performOCR(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    const InputImageRotation rotation = InputImageRotation.rotation0deg;
    const InputImageFormat format = InputImageFormat.nv21;
    

    final inputImageMetadata = InputImageMetadata(
      size: imageSize, rotation: rotation, format: format, bytesPerRow: 0,
      
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);

    final recognizedText = await _textRecognizer.processImage(inputImage);

    _textStreamController.add(recognizedText.text);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    _textStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(_cameraController!),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: StreamBuilder<String>(
            stream: _textStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Waiting for OCR...', style: TextStyle(fontSize: 18, color: Colors.white));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 18, color: Colors.red));
              } else {
                return Text(snapshot.data ?? '', style: TextStyle(fontSize: 18, color: Colors.white));
              }
            },
          ),
        ),
      ],
    );
  }
}
