import 'package:flutter/material.dart';

class CurrentlyTab extends StatelessWidget {
  final String location;

  CurrentlyTab({required this.location});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Currently"),
          Text(location),
        ],
      ),
    );
  }
}
