import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/routes/routes_name.dart';
import 'package:hostel_app/User/View/all_issues_screen.dart';
import 'package:hostel_app/User/View/room_availability.dart';
import 'package:hostel_app/User/View/room_change_request.dart';
import 'package:hostel_app/User/View/hostel_fee.dart';
import 'package:hostel_app/User/View/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? userData;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    fetchUserData();

    // Initialize the controller here
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void fetchUserData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((DocumentSnapshot userDoc) {
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildAnimatedContainer(String title, String imgPath, Widget page) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          Get.to(page)!.then((_) {
            _controller.reverse();
          });
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + _controller.value * 0.1, // Zoom-in effect
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15), // Fix corners
                      child: Image.asset(
                        imgPath,
                        fit: BoxFit.cover, // Full image inside container
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: AppText(
                          text: title,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AppText(
          text: 'Home Screen',
          textColor: Colors.white,
          fontSize: 23,
        ),
        backgroundColor: AppColors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 5),
            child: GestureDetector(
              onTap: () {
                Get.to(const ProfileScreen());
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(width: 2, color: Colors.green),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  clipBehavior: Clip.hardEdge,
                  child: (userData != null &&
                          userData?["imageUrl"] != null &&
                          userData?["imageUrl"].isNotEmpty)
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  value: progress.progress,
                                ),
                              ),
                          imageUrl: userData!["imageUrl"])
                      : const Icon(Icons.person, color: Colors.green, size: 35),
                ),
              ),
            ),
          ),
        ],
      ),
      body: userData != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User details container with Create Issues button
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green, width: 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: userData != null &&
                                          userData!['firstName'] != null
                                      ? userData!['firstName']
                                          .toUpperCase()
                                          .substring(
                                              0,
                                              userData!['firstName'].length > 15
                                                  ? 15
                                                  : userData!['firstName']
                                                      .length)
                                      : '',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                AppText(
                                  text: 'Room No: ${userData?["room"]}',
                                  fontSize: 16,
                                ),
                                const SizedBox(height: 5),
                                AppText(
                                  text: 'Block: ${userData?["block"]}',
                                  fontSize: 16,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteName.createIssueScreen);
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.note_add_outlined,
                                      size: 33,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const AppText(
                                  text: 'Create Issues',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Categories section
                    buildAnimatedContainer(
                      'Room Availability',
                      'assets/roomavail.jpeg',
                      const RoomAvailability(),
                    ),
                    buildAnimatedContainer(
                      'All Issues',
                      'assets/issue.jpeg',
                      const AllIssuesScreen(),
                    ),
                    buildAnimatedContainer(
                      'Hostel Fee',
                      'assets/hostelfee.jpeg',
                      const HostelFee(),
                    ),
                    buildAnimatedContainer(
                      'Change Room Request',
                      'assets/change_room.jpeg',
                      const RoomChangeRequest(),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
    );
  }
}
