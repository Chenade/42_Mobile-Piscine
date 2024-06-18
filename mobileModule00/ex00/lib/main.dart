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

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.green,
              child: const Text(
                'A Simple Text',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Button Pressed');
              },
              child: const Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
