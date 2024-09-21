import 'package:flutter/material.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';

class StaffMembersScreen extends StatefulWidget {
  const StaffMembersScreen({super.key});

  @override
  State<StaffMembersScreen> createState() => _StaffMembersScreenState();
}

class _StaffMembersScreenState extends State<StaffMembersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppText(
          text: 'All Staff',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: AppText(text: "You don't have permission to view this page"),
      ),
    );
  }
}
