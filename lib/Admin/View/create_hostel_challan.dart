import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import '../../Res/Widgets/InternetConnectivityError.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart'; // Assuming this is imported correctly
import '../../User/Model/create_challan.dart';

class CreateHostelChallan extends StatefulWidget {
  const CreateHostelChallan({super.key});

  @override
  State<CreateHostelChallan> createState() => _CreateHostelChallanState();
}

class _CreateHostelChallanState extends State<CreateHostelChallan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _challanNumberController =
      TextEditingController();
  final TextEditingController _messFeeController =
      TextEditingController(text: '5000');
  final TextEditingController _parkingChargesController =
      TextEditingController(text: '100');
  final TextEditingController _electricityFeeController =
      TextEditingController(text: '100');
  final TextEditingController _waterChargesController =
      TextEditingController(text: '100');
  final TextEditingController _roomChargesController =
      TextEditingController(text: '5000');
  String? selectedBlock;
  String? selectedRoom;
  String? currentUserId;
  bool isLoading = false;

  List<String> studentNames = [];
  String? selectedStudentName;

  @override
  void initState() {
    _getCurrentUserId();
    _generateChallanNumber(); // Generate challan number on screen load
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppText(
          text: 'Create Challan',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
      ),
      body: isLoading
          ? const InternetConnectivityError()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(_challanNumberController, 'Challan Number',
                        isNumeric: true, isEditable: false),
                    _buildBlockDropdown(
                        'Block No', selectedBlock, _onBlockSelected),
                    _buildRoomDropdown(
                        'Room No', selectedRoom, _onRoomSelected),
                    _buildDropdownField('Student Name', studentNames,
                        selectedStudentName, _onStudentNameSelected),
                    _buildTextField(_messFeeController, 'Mess Fee',
                        isNumeric: true, isEditable: true),
                    _buildTextField(
                        _parkingChargesController, 'Parking Charges',
                        isNumeric: true, isEditable: true),
                    _buildTextField(
                        _electricityFeeController, 'Electricity Fee',
                        isNumeric: true, isEditable: true),
                    _buildTextField(_waterChargesController, 'Water Charges',
                        isNumeric: true, isEditable: true),
                    _buildTextField(_roomChargesController, 'Room Charges',
                        isNumeric: true, isEditable: true),
                    const SizedBox(height: 20),
                    CustomBotton(
                      onTap: _createChallan,
                      label: 'Create Challan',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isNumeric = false, bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: AppColors.green),
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.green)),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
        readOnly: !isEditable, // Make the field non-editable if required
      ),
    );
  }

  Widget _buildDropdownField(String labelText, List<String> items,
      String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        value: value,
        onChanged: onChanged,
        items: items.map((String studentName) {
          return DropdownMenuItem<String>(
            value: studentName,
            child: Text(studentName),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBlockDropdown(
      String labelText, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        value: value,
        onChanged: onChanged,
        items: _getBlockDropdownItems(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRoomDropdown(
      String labelText, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        value: value,
        onChanged: onChanged,
        items: _getRoomDropdownItems(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $labelText';
          }
          return null;
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _getBlockDropdownItems() {
    List<String> blockNumbers = ['A', 'B', 'C'];
    return blockNumbers.map((block) {
      return DropdownMenuItem<String>(
        value: block,
        child: Text(block),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _getRoomDropdownItems() {
    List<String> roomNumbers = ['1', '2', '3', '4'];
    return roomNumbers.map((room) {
      return DropdownMenuItem<String>(
        value: room,
        child: Text(room),
      );
    }).toList();
  }

  void _onBlockSelected(String? value) {
    setState(() {
      selectedBlock = value;
    });
    _fetchStudentNames();
  }

  void _onRoomSelected(String? value) {
    setState(() {
      selectedRoom = value;
    });
    _fetchStudentNames();
  }

  void _fetchStudentNames() {
    if (selectedBlock != null && selectedRoom != null) {
      FirebaseFirestore.instance
          .collection('users')
          .where('block', isEqualTo: selectedBlock)
          .where('room', isEqualTo: selectedRoom)
          .get()
          .then((querySnapshot) {
        List<String> names = [];
        for (var doc in querySnapshot.docs) {
          names.add(doc['firstName']);
        }
        setState(() {
          studentNames = names;
          selectedStudentName = null; // Reset selected student name
        });
      }).catchError((error) {
        print('Error fetching student names: $error');
      });
    }
  }

  void _getCurrentUserId() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          currentUserId = user.uid;
        });
      }
    });
  }

  void _generateChallanNumber() {
    // Generate a random 6-digit number
    var random = Random();
    int randomNumber = random.nextInt(900000) +
        100000; // Generates number between 100000 and 999999
    _challanNumberController.text = randomNumber.toString();
  }

  double _calculateTotalAmount() {
    double messFee = double.tryParse(_messFeeController.text) ?? 0.0;
    double parkingCharges =
        double.tryParse(_parkingChargesController.text) ?? 0.0;
    double electricityFee =
        double.tryParse(_electricityFeeController.text) ?? 0.0;
    double waterCharges = double.tryParse(_waterChargesController.text) ?? 0.0;
    double roomCharges = double.tryParse(_roomChargesController.text) ?? 0.0;
    return messFee +
        parkingCharges +
        electricityFee +
        waterCharges +
        roomCharges;
  }

  void _onStudentNameSelected(String? value) {
    setState(() {
      selectedStudentName = value;
    });
  }

  void _createChallan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      double totalAmount = _calculateTotalAmount();

      final challan = Challan(
        id: currentUserId!,
        challanNumber: _challanNumberController.text,
        studentName: selectedStudentName!,
        beforeDueDate: totalAmount,
        afterDueDate: totalAmount + 300,
        status: 'Pending',
        blockNo: selectedBlock!,
        roomNo: selectedRoom!,
        messFee: double.parse(_messFeeController.text),
        parkingCharges: double.parse(_parkingChargesController.text),
        electricityFee: double.parse(_electricityFeeController.text),
        waterCharges: double.parse(_waterChargesController.text),
        roomCharges: double.parse(_roomChargesController.text),
        issueDate: Timestamp.now(),
        dueDate:
            Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
      );

      await FirebaseFirestore.instance
          .collection('challan')
          .add(challan.toMap())
          .then((value) {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challan created successfully')),
        );
      }).catchError((error) {
        print("Failed to add challan: $error");
      });

      setState(() {
        isLoading = false;
      });
    }
  }
}
