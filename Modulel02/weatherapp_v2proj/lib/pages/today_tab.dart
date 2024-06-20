import 'package:flutter/material.dart';

class TodayTab extends StatelessWidget {
  final String location;

  TodayTab({required this.location});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Today"),
          Text(location),
        ],
      ),
    );
  }
}
