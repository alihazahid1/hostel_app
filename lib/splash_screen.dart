import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hostel_app/Res/Images/images.dart';
import 'package:get/get.dart';
import 'package:hostel_app/User/View/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late Animation<double> _imageAnimation;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Get.to(WelcomeScreen());
    });
    // Initialize animation controllers and animations
    _imageController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _imageAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _imageController,
        curve: Curves.easeInOut,
      ),
    );

    _buttonController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _buttonController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _imageController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _imageAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _imageAnimation.value),
                  child: Image.asset(
                    AppAssets.splasImg,
                    fit: BoxFit
                        .cover, // Ensures the image covers the whole background
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 200, // Adjust this value to position the button
            left: 0,
            right: 0,
            child: Center(
              child: Transform.scale(
                scale: _buttonAnimation.value,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade900,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    "Book a room",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
