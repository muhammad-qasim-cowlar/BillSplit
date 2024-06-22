import 'package:flutter/material.dart';

class BillListItem extends StatefulWidget {
  final String itemName; // Added a property to accept the item name

  const BillListItem(this.itemName, {super.key});

  @override
  State<BillListItem> createState() => _BillListItemState();
}

class _BillListItemState extends State<BillListItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        color: Colors.white54,
        child: Padding(
          padding: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.lens,
                color: Colors.black,
                size: 15,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                  child: Text(
                    widget.itemName, // Use the passed item name
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                  child: Text(
                    "Item Price",
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
              ),
              Icon(
                Icons.contacts_rounded,
                color: Color.fromRGBO(0, 0, 0, 1),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
