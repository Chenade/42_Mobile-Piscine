import 'package:flutter/material.dart';

class WeeklyTab extends StatelessWidget {
  final String location;

  WeeklyTab({required this.location});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Weekly"),
          Text(location),
        ],
      ),
    );
  }
}
