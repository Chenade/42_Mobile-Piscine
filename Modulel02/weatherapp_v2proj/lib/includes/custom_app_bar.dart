import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onLocationPressed;

  CustomAppBar({required this.onSearchChanged, required this.onLocationPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        onChanged: (value) {
          onSearchChanged(value);
        },
        decoration: InputDecoration(
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.location_on),
          onPressed: onLocationPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
