import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';

import '../../../Res/Widgets/custom_botton.dart';
import 'login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  Future PasswordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Alert Dialog"),
            content: Text("password reset link send check your email"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert Dialog"),
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.to(const LoginScreen());
            },
            child: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(" Reset Password"),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("Enter your Email to reset your password"),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
                  errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: ' Your email',
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomBotton(
              width: 280,
              backgroundColor: Colors.green,
              label: "Reset Password",
              onTap: () {
                PasswordReset();
              },
            ),
          ],
        ),
      ),
    );
  }
}
