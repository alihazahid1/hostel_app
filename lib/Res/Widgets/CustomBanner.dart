import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final String imagePath;
  const CustomBanner({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 100,
      width: 310,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagePath,
            fit: BoxFit.fill,
            height: 150,
            width: 315,
          ),
        ),
      ),
    );
  }
}
