import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Admin/View/admin_login_screen.dart';
import 'package:hostel_app/User/View/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;
  late Animation<double> _logoAnimation;
  late Animation<Color?> _backgroundAnimation;
  late AnimationController _buttonTapController;

  @override
  void initState() {
    super.initState();

    // Logo Animation
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    );

    // Button Animation
    _buttonController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    // Background Gradient Animation
    _backgroundAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.greenAccent.shade100,
    ).animate(_logoController);

    // Initialize Button Tap Animation
    _buttonTapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.0,
    );

    // Start animations
    _logoController.forward();
    _buttonController.forward();
    _buttonTapController.forward(); // Start the button tap animation as well
  }

  @override
  void dispose() {
    _logoController.dispose();
    _buttonController.dispose();
    _buttonTapController.dispose();
    super.dispose();
  }

  void onButtonTap() {
    _buttonTapController.reverse().then((value) {
      _buttonTapController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_backgroundAnimation.value!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Animated Logo
              FadeTransition(
                opacity: _logoAnimation,
                child: ScaleTransition(
                  scale: _logoAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 90.0, top: 50),
                    child: Image.asset(
                      'assets/logo.png', // Your logo asset
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const Text(
                'Login as a',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Admin Login Button with Slide-In Animation and Tap Effect
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(_buttonAnimation),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ScaleTransition(
                    scale: _buttonTapController,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        onButtonTap();
                        Get.to(const AdminLoginScreen());
                      },
                      child: const Center(
                        child: Text(
                          'Admin Login',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // User Login Button with Slide-In Animation and Tap Effect
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(_buttonAnimation),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ScaleTransition(
                    scale: _buttonTapController,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        onButtonTap();
                        Get.to(const LoginScreen());
                      },
                      child: const Center(
                        child: Text(
                          'User Login',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
