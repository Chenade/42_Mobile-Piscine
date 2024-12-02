import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isInitialText = true; 

  void toggleText() {
    setState(() {
      isInitialText = !isInitialText;
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayText = isInitialText ? 'A Simple Text' : 'Hello World!';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.blue,
              child: Text(
                displayText,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                toggleText(); // Call function to toggle text
              },
              child: const Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
