import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:intl/intl.dart';

class ChallansScreen extends StatelessWidget {
  final List<DocumentSnapshot> challan;
  final bool isPaid;

  const ChallansScreen({
    super.key,
    required this.challan,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.green,
        title: Text(
          isPaid ? 'Paid Challans' : 'Unpaid Challans',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: challan.isNotEmpty
          ? ListView.builder(
              itemCount: challan.length,
              itemBuilder: (context, index) {
                final challans = challan[index].data() as Map<String, dynamic>;
                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isPaid ? Colors.green.shade100 : Colors.red.shade100,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Challan No: '),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.teal),
                              child: Text(
                                '${challans['challanNumber']}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('UserName: '),
                          Text('${challans['studentName']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Issue date:'),
                          Text(DateFormat('dd-MM-yyyy').format(
                              challans['issueDate'].toDate().toLocal())),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Due date: '),
                          Text(DateFormat('dd-MM-yyyy')
                              .format(challans['dueDate'].toDate().toLocal())),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('MessFee: '),
                          Text('${challans['messFee']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ParkingCharges: '),
                          Text('${challans['parkingCharges']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ElectricityFee: '),
                          Text('${challans['electricityFee']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('WaterCharges: '),
                          Text('${challans['waterCharges']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('RoomCharges: '),
                          Text('${challans['roomCharges']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Before DueDate:'),
                          Text('${challans['beforeDueDate']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('After DueDate:'),
                          Text('${challans['afterDueDate']}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status: '),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: isPaid ? Colors.green : Colors.orange),
                              child: Text(
                                '${challans['status']}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              )),
                        ],
                      ),
                    ],
                  ),
                );
              })
          : const Center(child: Text('No record found')),
    );
  }
}
