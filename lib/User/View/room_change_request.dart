import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/User/View/room_change_request_history.dart';
import '../../Res/Widgets/InternetConnectivityError.dart';
import '../../Res/Widgets/custom_botton.dart';
import '../../Res/Widgets/CustomTextformField.dart';
import '../../Res/Widgets/app_text.dart';

class RoomChangeRequest extends StatefulWidget {
  const RoomChangeRequest({super.key});

  @override
  State<RoomChangeRequest> createState() => _RoomChangeRequestState();
}

class _RoomChangeRequestState extends State<RoomChangeRequest> {
  final TextEditingController roomController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController blockController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController currentBlockController = TextEditingController();
  final TextEditingController currentRoomNoController = TextEditingController();
  String? newBlock;
  String? newRoomNo;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isSubmitting = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userData.exists) {
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        setState(() {
          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          roomController.text = data['room'] ?? '';
          blockController.text = data['block'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phoneNumber'] ?? '';
          currentBlockController.text = data['block'] ?? '';
          currentRoomNoController.text = data['room'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submitRequest() async {
    setState(() {
      isSubmitting = true;
    });

    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;

      if (newBlock != null &&
          newRoomNo != null &&
          reasonController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          currentBlockController.text.isNotEmpty &&
          currentRoomNoController.text.isNotEmpty &&
          firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty) {
        // Validate that the new block and room are not the same as the current ones
        if (newBlock == currentBlockController.text &&
            newRoomNo == currentRoomNoController.text) {
          setState(() {
            isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'New block and room cannot be the same as the current block and room')),
          );
          return; // Exit the function if the validation fails
        }

        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('roomchangerequest')
            .add({
          'currentBlock': currentBlockController.text,
          'currentRoomNo': currentRoomNoController.text,
          'newBlock': newBlock!,
          'newRoomNo': newRoomNo!,
          'reason': reasonController.text,
          'uid': uid,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'phoneNumber': phoneController.text,
          'status': 'Pending',
        });

        await docRef.update({'requestId': docRef.id});

        setState(() {
          isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully')),
        );

        clearForm();
      } else {
        setState(() {
          isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
      }
    } else {
      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
    }
  }

  void clearForm() {
    setState(() {
      newBlock = null;
      newRoomNo = null;
      reasonController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppText(
          text: 'Room Change Request',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const RoomChangeRequestHistory());
              },
              icon: const Icon(Icons.history)),
        ],
      ),
      body: isSubmitting
          ? const InternetConnectivityError()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const AppText(
                      text: 'First Name',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: firstNameController,
                    hintText: 'Enter your First Name',
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                      text: 'Last Name',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: lastNameController,
                    hintText: 'Enter your Last Name',
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                      text: 'Phone Number',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    inputFormatters: [PhoneTextInputFormatter()],
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    hintText: 'Enter your Phone Number',
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                      text: 'Current Block and Room No:',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CustomTextFormField(
                        readOnly: true,
                        width: 150,
                        keyboardType: TextInputType.text,
                        controller: currentBlockController,
                        hintText: 'Enter your Block ',
                      ),
                      const SizedBox(width: 20),
                      CustomTextFormField(
                        readOnly: true,
                        width: 150,
                        keyboardType: TextInputType.text,
                        controller: currentRoomNoController,
                        hintText: 'Enter your Room Number',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const AppText(
                      text: 'Shift to Block and Room No:',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          iconEnabledColor: Colors.green,
                          value: newBlock,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          hint: const Text('Select Block'),
                          onChanged: (value) {
                            setState(() {
                              newBlock = value;
                            });
                          },
                          items: ['A', 'B', 'C']
                              .map((block) => DropdownMenuItem(
                                    value: block,
                                    child: Text(block),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          iconEnabledColor: Colors.green,
                          value: newRoomNo,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          hint: const Text('Select Room'),
                          onChanged: (value) {
                            setState(() {
                              newRoomNo = value;
                            });
                          },
                          items: ['1', '2', '3']
                              .map((roomNo) => DropdownMenuItem(
                                    value: roomNo,
                                    child: Text(roomNo),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const AppText(
                      text: 'Reason for change',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    height: 200,
                    maxLines: 5,
                    hintText: 'Reason',
                    controller: reasonController,
                  ),
                  const SizedBox(height: 20),
                  CustomBotton(
                    label: isSubmitting ? 'Submitting...' : 'Submit',
                    onTap: submitRequest,
                  ),
                ],
              ),
            ),
    );
  }
}

class PhoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    // Append "03" to the beginning if it's not already there
    if (!newText.startsWith("03")) {
      newText = "03$newText";
    }

    if (newText.length == 4) {
      newText += '-';
    }

    // Check if the length of the phone number is already 11, if yes, do not allow further input
    if (newText.length > 12) {
      return oldValue; // Return the old value to prevent further input
    }

    // Check if the user has cleared the entire field
    if (newValue.text.isEmpty) {
      return TextEditingValue.empty; // Return an empty value to clear the field
    }

    // Check if the user has deleted the entire phone number
    if (oldValue.text.length > newValue.text.length) {
      return TextEditingValue.empty; // Return an empty value to clear the field
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
