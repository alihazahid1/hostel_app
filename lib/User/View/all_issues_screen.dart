import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import '../../Res/Widgets/app_text.dart';
import '../Model/create_issue_model.dart';

class AllIssuesScreen extends StatefulWidget {
  const AllIssuesScreen({super.key});

  @override
  State<AllIssuesScreen> createState() => _AllIssuesScreenState();
}

class _AllIssuesScreenState extends State<AllIssuesScreen> {
  List<IssueModel> issuesList = [];
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
        userId = uid;
        fetchIssuesData(); // Fetch issues after getting user data
      });
    }
  }

  void fetchIssuesData() async {
    if (userId == null) return;

    QuerySnapshot issuesSnapshot = await FirebaseFirestore.instance
        .collection('studentissues')
        .where('uid', isEqualTo: userId) // Filter issues by userId
        .get();

    setState(() {
      isLoading = false;
      issuesList = issuesSnapshot.docs
          .map((doc) =>
              IssueModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
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
          text: 'All Issues',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : issuesList.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView.builder(
                    itemCount: issuesList.length,
                    itemBuilder: (context, index) {
                      IssueModel issue = issuesList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green.shade50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    userData?['imageUrl'] != null
                                        ? Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: Colors.green),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: Image.network(
                                                  userData!['imageUrl'],
                                                  width: 50,
                                                  height: 50,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                        'assets/person.png',
                                                        width: 50,
                                                        height: 50);
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        : Image.asset('assets/person.png',
                                            width: 50, height: 50),
                                    const SizedBox(height: 15),
                                    AppText(
                                        text: userData != null &&
                                                userData!['firstName'] != null
                                            ? userData!['firstName']
                                                .toUpperCase()
                                                .substring(
                                                    0,
                                                    userData!['firstName']
                                                                .length >
                                                            15
                                                        ? 15
                                                        : userData!['firstName']
                                                            .length)
                                            : '',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 8),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const AppText(
                                            text: 'Username: ',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                        AppText(
                                            text: userData != null &&
                                                    userData!['firstName'] !=
                                                        null
                                                ? userData!['firstName']
                                                    .toUpperCase()
                                                    .substring(
                                                        0,
                                                        userData!['firstName']
                                                                    .length >
                                                                15
                                                            ? 15
                                                            : userData![
                                                                    'firstName']
                                                                .length)
                                                : '',
                                            fontSize: 8),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: issue.status == 'Resolved'
                                                ? Colors.green
                                                : issue.status == 'Rejected'
                                                    ? Colors.red
                                                    : Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: AppText(
                                            text: issue.status ?? '',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const AppText(
                                            text: 'Room Number:',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                        AppText(
                                            text: ' ${issue.roomNumber}',
                                            fontSize: 10),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const AppText(
                                            text: 'Email Id:',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                        AppText(
                                            text: ' ${issue.email}',
                                            fontSize: 10),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const AppText(
                                            text: 'Phone No:',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                        AppText(
                                            text: ' ${issue.phoneNumber}',
                                            fontSize: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                                children: [
                                  const TextSpan(
                                    text: 'Issue: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                      text: issue.issue ?? '',
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                                children: [
                                  const TextSpan(
                                    text: 'Student Comment: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: issue.reason ?? '',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: AppText(
                    text: 'No data found',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
    );
  }
}
