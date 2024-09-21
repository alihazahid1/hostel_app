import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../View/home_screen.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs; // Add this line

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading(true);
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            Get.offAll(() => const HomeScreen());
          } else {
            await FirebaseAuth.instance.signOut();
            Get.snackbar(
              'Email Not Verified',
              'Please verify your email before logging in.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        errorMessage.value = e.message ?? 'An error occurred';
      } finally {
        isLoading(false);
      }
    }
  }
}
