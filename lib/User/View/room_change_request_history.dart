import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Res/Widgets/app_text.dart';

class RoomChangeRequestHistory extends StatefulWidget {
  const RoomChangeRequestHistory({super.key});

  @override
  State<RoomChangeRequestHistory> createState() =>
      _RoomChangeRequestHistoryState();
}

class _RoomChangeRequestHistoryState extends State<RoomChangeRequestHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppText(
          text: 'Room Change Request ',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('roomchangerequest')
              .where('uid', isEqualTo: _auth.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No requests found'));
            }

            var requests = snapshot.data!.docs;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var request = requests[index].data() as Map<String, dynamic>;
                var status = request['status'];

                return Card(
                  elevation: 5,
                  surfaceTintColor: Colors.green,
                  shadowColor: Colors.green,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.green),
                            const SizedBox(width: 10),
                            const AppText(
                              text: 'Name:',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            AppText(
                              text: '${request['firstName']}'.length > 16
                                  ? ' ${request['firstName']}'.substring(0, 16)
                                  : ' ${request['firstName']}',
                              fontSize: 14,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: status == 'Approved'
                                    ? Colors.green
                                    : status == 'Rejected'
                                        ? Colors.red
                                        : Colors.orange,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: AppText(
                                text: status,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 10),
                            const AppText(
                              text: 'Current: ',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            AppText(
                                text:
                                    'Block ${request['currentBlock']}, Room No:${request['currentRoomNo']}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.swap_horiz, color: Colors.green),
                            const SizedBox(width: 10),
                            const AppText(
                              text: 'New: ',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            AppText(
                                text:
                                    '${request['newBlock']}, ${request['newRoomNo']}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 10),
                            const AppText(
                              text: 'Phone:',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            AppText(text: ' ${request['phoneNumber']}')
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.message, color: Colors.green),
                            const SizedBox(width: 10),
                            const AppText(
                              text: 'Reason: ',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            Expanded(
                                child: AppText(text: '${request['reason']}'))
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
      ),
    );
  }
}
