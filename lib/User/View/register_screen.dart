import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/CustomTextformField.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';
import 'package:hostel_app/User/Controller/register_controller.dart';
import 'login_screen.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? _cnicFileName;
  String? _cnicFilePath;
  String? _errorUploadCNIC;
  bool isImage = false;
  Future<void> _pickFile(Function(String?, String?) setFile) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        setState(() {
          setFile(file.name, file.path);
          isImage = file.extension != 'pdf';
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  // Setter method for CNIC file
  void _setCnicFile(String? name, String? path) {
    _cnicFileName = name;
    _cnicFilePath = path;
    controller.cnicSelectedPath = path;
  }

  RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: SingleChildScrollView(
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: AppText(
                        text: 'Register your account',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AppText(text: 'First Name', fontSize: 16),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your First Name',
                      controller: controller.firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const AppText(text: 'Last Name', fontSize: 16),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your Last Name',
                      controller: controller.lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const AppText(text: 'Email', fontSize: 16),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your Email',
                      controller: controller.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        if (!value.endsWith('@gmail.com') &&
                            !value.endsWith('@yahoo.com')) {
                          return 'Email must end with @gmail.com or @yahoo.com';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const AppText(text: 'Password', fontSize: 16),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your Password',
                      controller: controller.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const AppText(text: 'Phone Number', fontSize: 16),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        PhoneTextInputFormatter()
                      ], // Define the formatter
                      hintText: 'Enter Your Cell No',
                      validator: (value) =>
                          value == null || value.isEmpty || value.length != 12
                              ? 'Please enter your cell number'
                              : null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const AppText(text: 'CNIC No', fontSize: 16),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: controller.cnicController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CNICTextInputFormatter()
                      ], // Define the formatter
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your CNIC No';
                        } else if (value.length != 15) {
                          return 'CNIC No should be exactly 13 digits';
                        }
                        return null;
                      },
                      hintText: 'Enter Your CNIC N0',
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Original CNIC (both sides) ',
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_cnicFilePath != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              width: 315,
                              height: 200,
                              child: isImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(_cnicFilePath!),
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : PDFView(
                                      filePath: _cnicFilePath!,
                                      enableSwipe: true,
                                      swipeHorizontal: false,
                                      autoSpacing: false,
                                      pageFling: false,
                                      onRender: (pages) {
                                        print("Rendered $pages pages");
                                      },
                                      onError: (error) {
                                        print(error.toString());
                                      },
                                      onPageError: (page, error) {
                                        print('$page: ${error.toString()}');
                                      },
                                      onViewCreated: (PDFViewController vc) {
                                        setState(() {});
                                      },
                                      onPageChanged: (int? page, int? total) {
                                        setState(() {});
                                        print('page change: $page/$total');
                                      },
                                    ),
                            ),
                          ),
                        CustomBotton(
                          onTap: () {
                            setState(() {
                              _pickFile(_setCnicFile);
                            });
                          },
                          label: 'Upload CNIC',
                        ),
                        if (_cnicFileName != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$_cnicFileName'),
                          ),
                        if (_errorUploadCNIC != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorUploadCNIC!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const AppText(text: 'Roll No', fontSize: 16),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      hintText: 'Enter your Roll Number',
                      controller: controller.rollNoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Roll number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(text: 'Block', fontSize: 16),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField<String>(
                                iconEnabledColor: Colors.green,
                                value: controller.selectedBlock,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                hint: const Text('Select Block'),
                                onChanged: (value) {
                                  setState(() {
                                    controller.selectedBlock = value;
                                  });
                                },
                                items: ['A', 'B', 'C']
                                    .map((block) => DropdownMenuItem(
                                          value: block,
                                          child: Text(block),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a block';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(text: 'Room', fontSize: 16),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField<String>(
                                iconEnabledColor: Colors.green,
                                value: controller.selectedRoomNo,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                hint: const Text('Select Room'),
                                onChanged: (value) {
                                  setState(() {
                                    controller.selectedRoomNo = value;
                                  });
                                },
                                items: ['1', '2', '3', '4']
                                    .map((roomNo) => DropdownMenuItem(
                                          value: roomNo,
                                          child: Text(roomNo),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a room';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return CustomBotton(
                        onTap: controller.isLoading.value
                            ? null
                            : controller.register,
                        label: controller.isLoading.value
                            ? 'Loading...'
                            : 'Register',
                        backgroundColor: controller.isLoading.value
                            ? Colors.grey
                            : AppColors.green,
                      );
                    }),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (controller.errorMessage.isNotEmpty) {
                        return Center(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return const SizedBox
                            .shrink(); // Hide the error message if it's empty
                      }
                    }),
                    const SizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: "Already have an account?",
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(const LoginScreen());
                                },
                              text: ' Login',
                              style: const TextStyle(color: AppColors.green),
                            ),
                          ],
                        ),
                      ),
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

class CNICTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText.length == 5 || newText.length == 13) {
      newText += '-';
    }

    // Check if the length of the CNIC is already 15, if yes, do not allow further input
    if (newText.length > 15) {
      return oldValue; // Return the old value to prevent further input
    }
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
