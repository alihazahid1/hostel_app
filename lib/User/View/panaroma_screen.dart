import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: PhotoView(
            imageProvider: AssetImage(imageUrl),
            backgroundDecoration: BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            basePosition: Alignment.center,
            enableRotation: false,
            onTapUp: (context, details, controllerValue) {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
