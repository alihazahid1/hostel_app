import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/User/Controller/login_controller.dart';
import 'package:hostel_app/User/View/register_screen.dart';
import 'package:hostel_app/User/View/welcome_screen.dart';
import 'package:hostel_app/Res/Widgets/CustomTextformField.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final LoginController controller = Get.put(LoginController());
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

  void resendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Get.snackbar(
          'Verification Email Sent',
          'A verification email has been sent to ${user.email}.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification email.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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

          backgroundColor: Colors.green.shade100, // White app bar background
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: controller.loginFormKey,
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
                        'Login your account',
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
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPassword()));
                          },
                          child: const Text(
                            "Forget Password",
                            style:
                                TextStyle(fontSize: 14, color: AppColors.green),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Obx(() {
                      return Hero(
                        tag: 'loginButton',
                        child: CustomBotton(
                          onTap: controller.isLoading.value
                              ? null
                              : () {
                                  controller.login();
                                  // Smooth transition to next page
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const WelcomeScreen(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);
                                      return SlideTransition(
                                          position: offsetAnimation,
                                          child: child);
                                    },
                                  ));
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
                    const SizedBox(height: 10),
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
                                  Get.to(const RegisterScreen());
                                },
                              text: ' Register',
                              style: TextStyle(color: Colors.green.shade900),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: resendVerificationEmail,
                        child: const Text(
                          'Resend Verification Email',
                          style: TextStyle(color: AppColors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
