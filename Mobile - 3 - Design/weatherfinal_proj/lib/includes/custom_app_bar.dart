import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final Function() onLocationPressed;
  final Function(String) onSearchSubmitted;

  CustomAppBar({
    required this.controller,
    required this.onSearchChanged,
    required this.onLocationPressed,
    required this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.9),
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search location...',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: onLocationPressed,
          ),
        ),
        onChanged: onSearchChanged,
        onSubmitted: onSearchSubmitted,
      ),
    );
  }

  @override
  Size get preferredSize => constSize.fromHeight(kToolbarHeight);

  
}
