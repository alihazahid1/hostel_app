import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/InternetConnectivityError.dart';

import '../../Res/Widgets/CustomTextformField.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';
import '../Model/staff_model.dart';

class AdminCreateStaff extends StatefulWidget {
  const AdminCreateStaff({super.key});

  @override
  State<AdminCreateStaff> createState() => _AdminCreateStaffState();
}

class _AdminCreateStaffState extends State<AdminCreateStaff> {
  final GlobalKey<FormState> _createStaffFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    jobRoleController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppText(
          text: 'Create Staff',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
      ),
      body: isLoading
          ? const InternetConnectivityError()
          : SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _createStaffFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(text: 'First Name', fontSize: 16),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: firstNameController,
                            hintText: 'Enter your First Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                          const SizedBox(height: 10),
                          const AppText(text: 'Last Name', fontSize: 16),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: lastNameController,
                            hintText: 'Enter your Last Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your First Name';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                          const SizedBox(height: 10),
                          const AppText(text: 'Job Role', fontSize: 16),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: jobRoleController,
                            hintText: 'Enter your Job Role',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Job Role';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const AppText(text: 'Email', fontSize: 16),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: emailController,
                            hintText: 'Enter your Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          const AppText(text: 'Phone Number', fontSize: 16),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            keyboardType: TextInputType.number,
                            controller: phoneNumberController,
                            hintText: 'Enter your Phone Number',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          CustomBotton(
                            onTap: () async {
                              if (_createStaffFormKey.currentState!
                                  .validate()) {
                                setState(() {
                                  isLoading =
                                      true; // Set isLoading to true when submitting
                                });
                                // Form is valid, save data to Firestore
                                final staffData = StaffModel(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  jobRole: jobRoleController.text,
                                  email: emailController.text,
                                  phoneNumber: phoneNumberController.text,
                                );

                                try {
                                  await FirebaseFirestore.instance
                                      .collection('staff')
                                      .add(
                                        staffData.toMap(),
                                      );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Staff created successfully')),
                                  );
                                  firstNameController.clear();
                                  lastNameController.clear();
                                  jobRoleController.clear();
                                  emailController.clear();
                                  phoneNumberController.clear();
                                } catch (e) {
                                  // Error saving data to Firestore
                                  print('Error: $e');
                                  // Optionally, you can show an error message
                                } finally {
                                  setState(() {
                                    isLoading =
                                        false; // Set isLoading back to false
                                  });
                                }
                              }
                            },
                            label: 'Create Staff',
                            backgroundColor: AppColors.green,
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
