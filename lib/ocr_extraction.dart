import 'dart:math';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:text_recognition_app/utils/utils.dart';

class OCRExtraction {
  // Assuming Utils class is defined for isProductName function

  static List<double> extractPrices(List<TextBlock> ocrResults) {
    try{
      List<String> textLines = ocrResults.expand((block) => block.lines).map((line) => line.text).toList();
    List<Rect> boundingBoxes = ocrResults.expand((block) => block.lines).map((line) => line.boundingBox).toList();

    List<String> prices = [];
    List<int> priceIndices = [];

    for (int i = 0; i < textLines.length; i++) {
      String line = textLines[i].replaceAll(' ', '');
      RegExpMatch? match = RegExp(r'\b\d+\.\d+\b').firstMatch(line);
      if (match != null) {
        prices.add(match.group(0)!);
        priceIndices.add(i);
      }
    }

    if (prices.length >= 2) {
      String price1 = prices[0];
      String price2 = prices[1];
      Rect box1 = boundingBoxes[priceIndices[0]];
      Rect box2 = boundingBoxes[priceIndices[1]];

      if (box1.left < box2.left) {
        return [double.tryParse(price1) ?? 0, double.tryParse(price2) ?? 0];
      } else {
        return [double.tryParse(price2) ?? 0, double.tryParse(price1) ?? 0];
      }
    }

    return [0,0];
    }
    catch(e){
      return [0,0];
    }
    
  }

  static String? extractBarcode(List<TextBlock> textLines) {
    try{
      String? barcode;
    for (TextBlock block in textLines) {
      for (TextLine line in block.lines) {
        var isInt = int.tryParse(line.text);
        if (line.text.length > 9 && isInt != null) {
          barcode = line.text;
          break;
        }
      }
      if (barcode != null) {
        break;
      }
    }
    return barcode;
    }
    catch(e){
      return "no barcode found";
    }
    
  }

  static String? extractProductName(List<TextBlock> ocrResults) {
    try{
      String? productName;
    for (TextBlock block in ocrResults) {
      for (TextLine line in block.lines) {
        if (Utils.isProductName(line.text)) {
          productName = line.text;
          break;
        }
      }
      if (productName != null) {
        break;
      }
    }
    return productName;
    }
    catch(e){
      return 'no product name found';
    }
    
  }
}
