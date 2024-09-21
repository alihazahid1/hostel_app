import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Admin/Controller/admin_login_controller.dart';
import 'package:hostel_app/Admin/View/admin_signup_screen.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/CustomTextformField.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';
import 'package:hostel_app/User/View/welcome_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen>
    with SingleTickerProviderStateMixin {
  AdminLoginController controller = Get.put(AdminLoginController());

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green.shade100, // Light green background
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.to(() => const WelcomeScreen());
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor:
              Colors.green.shade100, // Light green app bar background
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: controller.adminformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/logo.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Admin Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AppText(
                      text: 'Email',
                      textColor: AppColors.green,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your Email',
                      controller: controller.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const AppText(
                      text: 'Password',
                      textColor: AppColors.green,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your Password',
                      obscureText: true,
                      controller: controller.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    Obx(() {
                      return Hero(
                        tag: 'adminLoginButton',
                        child: CustomBotton(
                          onTap: controller.isLoading.value
                              ? null
                              : () {
                                  controller.adminLogin();
                                },
                          label: controller.isLoading.value
                              ? 'Loading...'
                              : 'Login',
                          backgroundColor: controller.isLoading.value
                              ? Colors.grey
                              : Colors.green.shade900,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black),
                          children: [
                            const TextSpan(
                              text: "Don't have an account?",
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const AdminSignUpScreen());
                                },
                              text: ' Register',
                              style: TextStyle(color: Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
