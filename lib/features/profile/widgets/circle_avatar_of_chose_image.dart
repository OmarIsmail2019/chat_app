import 'package:flutter/material.dart';

class CircleAvaterOfChoseImage extends StatelessWidget {
  const CircleAvaterOfChoseImage({
    super.key,
    required this.imagePath,
    required this.onTap,
  });
  final String imagePath;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }
}
