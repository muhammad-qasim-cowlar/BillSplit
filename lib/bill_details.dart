import 'package:flutter/material.dart';

import 'package:text_recognition_app/bill_list_item.dart';

class BillDetails extends StatefulWidget {
  final String name;
  const BillDetails(
    this.name, {
    super.key,
  });

  @override
  State<BillDetails> createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  String name = "";

  @override
  void initState() {
    super.initState();
    name = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                color: Colors.black,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                  child: Text(
                    "Item Name",
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                  child: Text(
                    "Price",
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                  child: Text(
                    "Person",
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          BillListItem(name[0]),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
          BillListItem(
            "Lassi",
          ),
        ],
      ),
    );
  }
}
