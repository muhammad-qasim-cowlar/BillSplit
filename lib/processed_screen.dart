import 'package:flutter/material.dart';

class ProcessedScreen extends StatefulWidget {
  final String name;
  const ProcessedScreen(this.name, {super.key});

  @override
  State<ProcessedScreen> createState() => ProcessedScreenState();
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.home),
      color: Colors.white, // Customize icon color
      onPressed: () {
        Scaffold.of(context).openDrawer(); // Open the drawer
      },
    );
  }
}

class ProcessedScreenState extends State<ProcessedScreen> {
  String fname = "";

  @override
  void initState() {
    super.initState();
    fname = widget.name;
    // Add your tab content widgets to the list here

    // Add more tabs as needed
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Length of the list
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Event Name"),
          backgroundColor: Colors.black,
          leading: HomeWidget(),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                // Search functionality here
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                  icon: Text(
                "Bill Details",
                style: TextStyle(color: Colors.white),
              )),
              Tab(
                  icon: Text(
                "Add Contacts",
                style: TextStyle(color: Colors.white),
              )),
              Tab(
                  icon: Text(
                "Event Details",
                style: TextStyle(color: Colors.white),
              )),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
