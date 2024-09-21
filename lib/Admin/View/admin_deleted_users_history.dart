import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import '../../Res/Widgets/app_text.dart';
import 'dart:io';

import '../../Res/Widgets/custom_botton.dart';
import 'challans_screen.dart';

class AdminDeletedUsers extends StatefulWidget {
  const AdminDeletedUsers({super.key});

  @override
  State<AdminDeletedUsers> createState() => _AdminDeletedUsersState();
}

class _AdminDeletedUsersState extends State<AdminDeletedUsers> {
  final CollectionReference deletedUsersCollection =
      FirebaseFirestore.instance.collection('deletedUsers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppText(
          text: 'Deleted Users',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
      ),
      body: StreamBuilder(
        stream: deletedUsersCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final deletedUserList = snapshot.data!.docs;

          return deletedUserList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: deletedUserList.length,
                    itemBuilder: (context, index) {
                      final userData =
                          deletedUserList[index].data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          showUserDetailsDialog(context, userData);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red.shade50,
                          ),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/person.png',
                                    width: 70,
                                    height: 70,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AppText(
                                    text: '${userData['firstName']}'
                                        .toLowerCase(),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: 'Email: ${userData['email']}',
                                    fontSize: 12,
                                  ),
                                  AppText(
                                    text:
                                        'Phone No: ${userData['phoneNumber']}',
                                    fontSize: 12,
                                  ),
                                  AppText(
                                    text: 'Block: ${userData['block']}',
                                    fontSize: 12,
                                  ),
                                  AppText(
                                    text: 'Room No: ${userData['room']}',
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: AppText(
                    text: 'No Deleted Users Found',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
        },
      ),
    );
  }

  void showUserDetailsDialog(
      BuildContext context, Map<String, dynamic> userData) async {
    // Fetch the user's block and room number
    String userBlock = userData['block'];
    String userRoomNo = userData['room'];
    String username = userData['firstName'];

    // Initialize counts
    int paidCount = 0;
    int unpaidCount = 0;

    // Fetch challans where block and roomNo match
    final challansSnapshot = await FirebaseFirestore.instance
        .collection('challan')
        .where('blockNo', isEqualTo: userBlock)
        .where('roomNo', isEqualTo: userRoomNo)
        .where('studentName', isEqualTo: username)
        .get();

    final challansList = challansSnapshot.docs;
    List<DocumentSnapshot> paidChallans = [];
    List<DocumentSnapshot> unpaidChallans = [];

    for (var challan in challansList) {
      if (challan['status'] == 'Paid') {
        paidChallans.add(challan);
        paidCount++;
      } else {
        unpaidChallans.add(challan);
        unpaidCount++;
      }
    }

    // Show AlertDialog with user details and counts
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${userData['firstName']} ${userData['lastName']}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email: ${userData['email']}'),
                Text('Phone Number: ${userData['phoneNumber']}'),
                Text('Block: ${userData['block']}'),
                Text('Room: ${userData['room']}'),
                Text('Roll No: ${userData['rollNo']}'),
                Text('CNIC: ${userData['cnic']}'),
                const SizedBox(height: 10),
                userData['cnicImageUrl'] != null
                    ? _buildImageWidget(userData['cnicImageUrl'])
                    : Container(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Paid Challans: $paidCount'),
                    CustomBotton(
                      borderRadius: 5,
                      height: 20,
                      width: 70,
                      fontSize: 8,
                      label: 'Show Challans',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChallansScreen(
                              challan: paidChallans,
                              isPaid: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Unpaid Challans: $unpaidCount'),
                    CustomBotton(
                      backgroundColor: Colors.teal,
                      borderRadius: 5,
                      height: 20,
                      width: 100,
                      fontSize: 8,
                      label: 'Show Unpaid Challans',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChallansScreen(
                              challan: unpaidChallans,
                              isPaid: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isImage = false;
  Widget _buildImageWidget(String imageUrl) {
    try {
      return SizedBox(
        width: 100,
        height: 200,
        child: isImage
            ? Image.file(
                File(imageUrl),
                fit: BoxFit.cover,
              )
            : PDFView(
                filePath: imageUrl,
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
      );
    } catch (e) {
      print('Error loading image: $e');
      return Container(); // Return an empty container or placeholder image
    }
  }
}
