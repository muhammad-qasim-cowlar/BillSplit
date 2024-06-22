import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:text_recognition_app/processed_screen.dart';

// ignore: must_be_immutable
class RecognizerScreen extends StatefulWidget {
  File image;
  RecognizerScreen(this.image, {super.key});

  @override
  State<RecognizerScreen> createState() => _RecognizerScreenState();
}

class _RecognizerScreenState extends State<RecognizerScreen> {
  late TextRecognizer textRecognizer;
  String results = "";
  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    doTextRecognition();
  }

  doTextRecognition() async {
    final InputImage inputImage = InputImage.fromFile(widget.image);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    results = text;
    setState(() {
      results;
    });
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text("Recognizer"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.file(widget.image),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.rotate_left_outlined,
                              size: 35,
                              color: Colors.white,
                            ),
                            Text(
                              "Retake",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        onTap: () => {},
                      ),
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.scanner,
                              size: 35,
                              color: Colors.white,
                            ),
                            Text(
                              "Process Bill",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProcessedScreen(results)))
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
