import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive/hive.dart';
import 'package:text_recognition_app/custom_result.dart';
import 'package:text_recognition_app/data_display.dart';
import 'package:text_recognition_app/ocr_extraction.dart' as ocr;
import 'package:text_recognition_app/processed_screen.dart';

// ignore: must_be_immutable
class RecognizerScreen extends StatefulWidget {
  final File image;
  RecognizerScreen(this.image, {super.key});

  @override
  State<RecognizerScreen> createState() => _RecognizerScreenState();
}

class _RecognizerScreenState extends State<RecognizerScreen> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  late TextRecognizer textRecognizer;
  bool _canProcess = true;
  bool _isBusy = false;
  String results = "";
  late Box box;

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    box = Hive.box('ocrData');
    doTextRecognition();
  }

  Future<void> doTextRecognition() async {
    final InputImage inputImage = InputImage.fromFile(widget.image);
    final recognizedText = await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    final barcodes = await _barcodeScanner.processImage(inputImage);
    for (final barcode in barcodes) {
      text += 'Barcode: ${barcode.rawValue}\n\n';
    }

    final textLines = recognizedText.blocks;

    final prices = ocr.OCRExtraction.extractPrices(textLines);
    final barcode = ocr.OCRExtraction.extractBarcode(textLines);
    final productName = ocr.OCRExtraction.extractProductName(textLines);

    final unitPrice = prices.isNotEmpty ? prices[0] : 0.0;
    final sellingPrice = prices.length > 1 ? prices[1] : 0.0;

    // Format the output string as desired
    results = 'Unit Price: $unitPrice\nSelling Price: $sellingPrice\nBarcode: $barcode\nProduct Name: $productName\n';

    // Create a JSON object
    var jsonObject = {
      'unitPrice': unitPrice,
      'sellingPrice': sellingPrice,
      'barcode': barcode,
      'productName': productName
    };

    // Store the JSON object in Hive
    await box.add(jsonObject);

    setState(() {results;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Recognizer"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.file(widget.image),
            ),
            const SizedBox(
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
                          builder: (context) => ProcessedScreen(results),
                        ),
                      ),
                    },
                  ),
                   InkWell(
        child: const Column(
          children: [
            Icon(
              Icons.list,
              size: 35,
              color: Colors.white,
            ),
            Text(
              "View Data",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataDisplayScreen(),
            ),
          );
        },
      ),
                ],
              ),
            ),
            Text(results),
          ],
        ),
      ),
    );
  }
}
