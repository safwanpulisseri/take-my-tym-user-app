import 'package:flutter/material.dart';

class CircleProfilePicture extends StatelessWidget {
  final double width;
  final double height;
  final String image;
  const CircleProfilePicture({
    super.key,
    required this.width,
    required this.height,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
         image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
