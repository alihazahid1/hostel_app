import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Admin/View/admin_room_availablty.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_card.dart';
import 'package:hostel_app/Admin/View/admin_all_staff_screen.dart';
import 'package:hostel_app/Admin/View/admin_hostel_fee_screen.dart';
import 'package:hostel_app/Admin/View/admin_profile_screen.dart';
import 'package:hostel_app/Admin/View/admin_all_issues_screen.dart';
import 'package:hostel_app/Admin/View/admin_all_users.dart';
import 'package:hostel_app/Admin/View/admin_change_request.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
          text: 'Dashboard',
          textColor: Colors.white,
          fontSize: 23,
        ),
        backgroundColor: AppColors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const AdminProfileScreen());
                },
                child: SvgPicture.asset('assets/profile.svg')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('staff').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> staffSnapshot) {
                  if (staffSnapshot.hasError) {
                    return Center(
                      child: AppText(
                        text: 'Error: ${staffSnapshot.error}',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    );
                  }

                  if (staffSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final staffList = staffSnapshot.data!.docs;
                  int totalStaff = staffList.length;

                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                      if (userSnapshot.hasError) {
                        return Center(
                          child: AppText(
                            text: 'Error: ${userSnapshot.error}',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        );
                      }

                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final userList = userSnapshot.data!.docs;
                      int bookedSeats = userList.length;
                      int availableSeats = 48 - bookedSeats;

                      return Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green, width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppText(
                                    text: 'Admin Panel',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const Spacer(),
                                  const AppText(
                                    text: 'Total Rooms: 12',
                                    fontSize: 14,
                                  ),
                                  AppText(
                                    text:
                                        'Total Available Seats: $availableSeats',
                                    fontSize: 14,
                                  ),
                                  AppText(
                                    text: 'Total Booked Seats: $bookedSeats',
                                    fontSize: 14,
                                  ),
                                  AppText(
                                    text: 'Total Staff: $totalStaff',
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const AppText(
                text: 'Categories',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              const SizedBox(height: 20),
              buildAnimatedContainer(
                'Room Availability',
                'assets/roomavail.jpeg',
                const AdminRoomAvailability(),
              ),
              const SizedBox(height: 20),
              buildAnimatedContainer(
                'All Issues',
                'assets/issue.jpeg',
                const AdminAllIssuesScreen(),
              ),
              const SizedBox(height: 20),
              buildAnimatedContainer(
                'Staff Members',
                'assets/staff_members.jpeg',
                const AdminAllStaff(),
              ),
              const SizedBox(height: 20),
              buildAnimatedContainer(
                'All Users',
                'assets/allusers.jpeg',
                const AdminAllUsers(),
              ),
              const SizedBox(height: 20),
              buildAnimatedContainer(
                'Hostel Fee',
                'assets/hostelfee.jpeg',
                const AdminHostelFeeScreen(),
              ),
              const SizedBox(height: 20),
              buildAnimatedContainer(
                'Change Request',
                'assets/change_room.jpeg',
                const AdminChangeRequest(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
