import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/CustomTextformField.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';
import 'package:hostel_app/User/View/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Res/Widgets/app_text.dart';
import '../Auth/firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var profileFormKey = GlobalKey<FormState>();
  bool isEnabled = false;
  bool isSaving = false;
  String imageUrl = "";
  bool isLoading = false;
  File? _selectedImage;
  final FirestoreService _firestoreService = FirestoreService();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _rollNoController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? userData; // Variable to store fetched user data

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the screen initializes
  }

  Future<void> fetchUserData() async {
    try {
      userData = await _firestoreService.getUserData();
      if (userData != null) {
        _firstNameController.text = userData?['firstName'] ?? '';
        _emailController.text = userData?['email'] ?? '';
        _phoneNumberController.text = userData?['phoneNumber'] ?? '';
        _rollNoController.text = userData?['rollNo'] ?? '';
      }
      setState(() {}); // Update the UI after fetching data
    } catch (e) {
      // Handle error fetching user data
      print('Error fetching user data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch user data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
        isEnabled = true;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
        isEnabled = true;
      });
    }
  }

  _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
            padding: const EdgeInsets.all(9),
            height: 140,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Wrap(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  onTap: () {
                    _pickImageFromCamera();
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                  ),
                  title: const Text("Camera"),
                ),
                ListTile(
                  onTap: () {
                    _pickImageFromGallery();
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(
                    Icons.image,
                    color: Colors.green,
                  ),
                  title: const Text("Gallery"),
                ),
              ],
            ),
          ));
        });
  }

  Future<void> _saveInfo() async {
    if (!profileFormKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      String? imageUrl;

      if (_selectedImage != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("HostelApp")
            .child("/images")
            .child(DateTime.now().toIso8601String());

        firebase_storage.UploadTask uploadTask = ref.putFile(_selectedImage!);
        await uploadTask.whenComplete(() => null);
        imageUrl = await ref.getDownloadURL();
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser!.uid;

      await db.collection("users").doc(uid).update({
        "imageUrl": imageUrl ?? userData?['imageUrl'],
        'firstName': _firstNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'rollNo': _rollNoController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );

      setState(() {
        isSaving = false;
        isEnabled = false;
      });
    } catch (e) {
      log('Error while updating: $e');
      Fluttertoast.showToast(
        msg: 'Failed to save data',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        fontSize: 16,
        timeInSecForIosWeb: 2,
      );
      setState(() {
        isSaving = false;
      });
    }
  }

  void _checkForChanges() {
    if (_firstNameController.text.trim() != userData?['firstName'] ||
        _emailController.text.trim() != userData?['email'] ||
        _phoneNumberController.text.trim() != userData?['phoneNumber'] ||
        _rollNoController.text.trim() != userData?['rollNo'] ||
        _selectedImage != null) {
      setState(() {
        isEnabled = true;
      });
    } else {
      setState(() {
        isEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstNameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _phoneNumberController.addListener(_checkForChanges);
    _rollNoController.addListener(_checkForChanges);

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppText(
          text: 'Profile Screen',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.to(() => const WelcomeScreen());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: profileFormKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                userData != null
                    ? Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  border:
                                      Border.all(width: 2, color: Colors.green),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: (_selectedImage != null)
                                        ? Image.file(
                                            _selectedImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : (userData?["imageUrl"] != '')
                                            ? CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: progress
                                                                .progress,
                                                          ),
                                                        ),
                                                imageUrl: userData?["imageUrl"])
                                            : const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.green,
                                              )),
                              ),
                              Positioned(
                                right: 0,
                                top: 100,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _showPicker();
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            controller: _firstNameController,
                            prefixIcon: Icons.person,
                            hintText: 'First Name',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: _emailController,
                            prefixIcon: Icons.email,
                            hintText: 'Email',
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: _phoneNumberController,
                            inputFormatters: [PhoneTextInputFormatter()],
                            prefixIcon: Icons.phone,
                            hintText: 'Phone Number',
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length != 12) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: _rollNoController,
                            prefixIcon: Icons.book_rounded,
                            hintText: 'Roll Number',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid Roll number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 145,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.door_back_door_outlined,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      AppText(
                                        text: 'Room No: ${userData?['room']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 145,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(Icons.roofing_sharp),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      AppText(
                                        text: 'Block ${userData?['block']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          CustomBotton(
                            onTap: isEnabled ? _saveInfo : null,
                            label: isSaving ? 'Saving...' : 'Save',
                            backgroundColor:
                                isEnabled ? Colors.green : Colors.grey,
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 40,
                        width: 30,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        )),
              ],
            ),
          ),
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
