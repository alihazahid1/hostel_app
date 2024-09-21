import 'package:flutter/material.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';

class CreateStaffScreen extends StatefulWidget {
  const CreateStaffScreen({super.key});

  @override
  State<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends State<CreateStaffScreen> {
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
      body: const Center(
        child: AppText(text: "You don't have permission to view this page"),
      ),
    );
  }
}
