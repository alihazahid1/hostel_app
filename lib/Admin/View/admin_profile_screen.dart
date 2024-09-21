import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/User/View/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../../Res/Widgets/CustomTextformField.dart';
import '../../Res/Widgets/app_text.dart';
import '../../Res/Widgets/custom_botton.dart';
import '../Auth/admin_firestore.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  var adminProfileFormKey = GlobalKey<FormState>();
  bool isEnabled = false;
  bool isSaving = false;
  String imageUrl = "";
  bool isLoading = false;
  File? _selectedImage;
  final AdminFirestoreService _firestoreService = AdminFirestoreService();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? adminData; // Variable to store fetched user data

  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  Future<void> fetchAdminData() async {
    try {
      adminData = await _firestoreService.getAdminData();
      if (adminData != null) {
        _firstNameController.text = adminData?['firstName'] ?? '';
        _emailController.text = adminData?['email'] ?? '';
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
    if (!adminProfileFormKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("Admin")
            .child("/image")
            .child(DateTime.now().toIso8601String());

        firebase_storage.UploadTask uploadTask = ref.putFile(_selectedImage!);
        await uploadTask.whenComplete(() => null);
        imageUrl = await ref.getDownloadURL();
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser!.uid;

      await db.collection("admin").doc(uid).update({
        "imageUrl": imageUrl ?? adminData?['imageUrl'],
        'firstName': _firstNameController.text.trim(),
        'email': _emailController.text.trim(),
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
    if (_firstNameController.text.trim() != adminData?['firstName'] ||
        _emailController.text.trim() != adminData?['email'] ||
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
            key: adminProfileFormKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                adminData != null
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
                                        : (adminData?["imageUrl"] != null &&
                                                adminData?["imageUrl"] != '')
                                            ? CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: progress.progress,
                                                  ),
                                                ),
                                                imageUrl:
                                                    adminData?["imageUrl"]!,
                                              )
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
                                    color: Colors.green,
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
                          AppText(
                            textAlign: TextAlign.center,
                            text:
                                '${adminData?['firstName'] ?? ''} ${adminData?['lastName'] ?? ''}'
                                    .toUpperCase(),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
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
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            controller: _phoneNumberController,
                            prefixIcon: Icons.phone,
                            hintText: 'Phone Number',
                          ),
                          const SizedBox(height: 20),
                          CustomBotton(
                            onTap: isEnabled ? _saveInfo : null,
                            label: isSaving ? 'Saving...' : 'Save',
                            backgroundColor:
                                isEnabled ? Colors.green : Colors.grey,
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                        color: Colors.green,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
