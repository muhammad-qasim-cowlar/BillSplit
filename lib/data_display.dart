import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DataDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stored Data'),
      ),
      body: FutureBuilder(
        future: _retrieveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<dynamic> data = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return ListTile(
                title: Text('Product Name: ${item['productName']}'),
                subtitle: Text('Unit Price: ${item['unitPrice']}, Selling Price: ${item['sellingPrice']}, Barcode: ${item['barcode']}'),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _retrieveData() async {
    var box = Hive.box('ocrData');
    return box.values.toList();  // Retrieve all stored data
  }
}
