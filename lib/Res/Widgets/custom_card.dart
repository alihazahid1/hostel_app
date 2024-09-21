import 'package:flutter/material.dart';

import 'app_text.dart';

class CustomCard extends StatelessWidget {
  final String text, imgPath;
  final void Function()? onTap;
  const CustomCard(
      {super.key, required this.text, required this.imgPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shadowColor: Colors.green,
        surfaceTintColor: Colors.green,
        child: Container(
          height: 150,
          width: 98,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  imgPath,
                  height: 90,
                ),
                const Spacer(),
                AppText(
                  text: text,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
