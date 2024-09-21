import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Auth/firestore.dart';
import '../View/login_screen.dart';

class RegisterController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();

  String? cnicSelectedPath;
  String? selectedBlock;
  String? selectedRoomNo;
  String? _errorUploadCNIC;
  String? _cnicFilePath;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> register() async {
    if (registerFormKey.currentState!.validate()) {
      bool hasError = false;
      if (_cnicFilePath == null) {
        _errorUploadCNIC = 'Please upload the Original CNIC';
        hasError = true; // Set hasError to true if there's an error
      } else {
        _errorUploadCNIC = null; // Clear the error message if there's no error
      }

      isLoading(true);

      try {
        // Check for room availability before proceeding with registration
        bool isRoomAvailable = await FirestoreService().checkRoomAvailability(
          selectedBlock ?? '',
          selectedRoomNo ?? '',
        );

        if (!isRoomAvailable) {
          isLoading(false);
          Get.snackbar(
            'Registration Failed',
            'Room is already full. Please select another room.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          await user.sendEmailVerification();

          // Save user data to Firestore
          await FirestoreService().addUserToFirestore(
            firstNameController.text,
            lastNameController.text,
            emailController.text,
            passwordController.text,
            phoneNumberController.text,
            selectedBlock ?? '',
            selectedRoomNo ?? '',
            rollNoController.text,
            cnicController.text,
            cnicSelectedPath ?? '',
          );

          // Update room availability
          await FirestoreService().decrementRoomSeats(
            selectedBlock ?? '',
            selectedRoomNo ?? '',
          );

          Get.snackbar(
            'Registration Successful',
            'A verification email has been sent to ${user.email}. Please verify your email before logging in.',
            snackPosition: SnackPosition.BOTTOM,
          );

          Get.offAll(() => const LoginScreen());
        }
      } on FirebaseAuthException catch (e) {
        errorMessage.value = e.message ?? 'An error occurred';
        Get.snackbar(
          'Registration Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    }
  }

  void reset() {
    registerFormKey.currentState?.reset();
    usernameController.clear();
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
    rollNoController.clear();
    cnicController.clear();
    selectedBlock = null;
    selectedRoomNo = null;
    cnicSelectedPath = null;
    errorMessage.value = '';
  }
}
