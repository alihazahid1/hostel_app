import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/InternetConnectivityError.dart';
import 'package:intl/intl.dart';
import '../../Res/Widgets/app_text.dart';
import '../../User/Model/create_challan.dart';
import 'create_hostel_challan.dart';

class AdminHostelFeeScreen extends StatefulWidget {
  const AdminHostelFeeScreen({super.key});

  @override
  State<AdminHostelFeeScreen> createState() => _AdminHostelFeeScreenState();
}

class _AdminHostelFeeScreenState extends State<AdminHostelFeeScreen> {
  final CollectionReference _challanCollection =
      FirebaseFirestore.instance.collection('challan');
  List<Challan> challansList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllChallansData();
  }

  void fetchAllChallansData() async {
    QuerySnapshot challansSnapshot = await _challanCollection.get();
    setState(() {
      isLoading = false;
      challansList = challansSnapshot.docs
          .map((doc) =>
              Challan.fromMap(doc.data() as Map<String, dynamic>)..id = doc.id)
          .toList();
    });
  }

  Future<void> changeStatus(
    String challanId,
  ) async {
    await FirebaseFirestore.instance
        .collection('challan')
        .doc(challanId)
        .update({'status': 'Paid'});
    setState(() {
      fetchAllChallansData();
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
          text: 'Hostel Fees',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CreateHostelChallan());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : challansList.isNotEmpty
              ? StreamBuilder<QuerySnapshot>(
                  stream: _challanCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const InternetConnectivityError();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      final List<Challan> challansList = snapshot.data!.docs
                          .map((doc) => Challan.fromMap(
                              doc.data() as Map<String, dynamic>)
                            ..id = doc.id)
                          .toList();

                      return challansList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ListView.builder(
                                itemCount: challansList.length,
                                itemBuilder: (context, index) {
                                  final challan = challansList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      _showChallanDetailsDialog(
                                          context, challan);
                                    },
                                    child: _buildHistoryCard(
                                      context,
                                      (index + 1).toString(),
                                      challan.challanNumber,
                                      challan.beforeDueDate.toString(),
                                      challan.status,
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(child: Text('No Challans Found'));
                    }
                    return const Center(child: Text('No data available'));
                  },
                )
              : const Center(child: Text('No data available')),
    );
  }

  void _showChallanDetailsDialog(BuildContext context, Challan challan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Challan Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Challan Number', challan.challanNumber),
                _buildDetailItem('Student Name', challan.studentName),
                _buildDetailItem('Status', challan.status),
                _buildDetailItem('Block No', challan.blockNo),
                _buildDetailItem('Room No', challan.roomNo),
                _buildDetailItem('Mess Fee', challan.messFee.toString()),
                _buildDetailItem(
                    'Parking Charges', challan.parkingCharges.toString()),
                _buildDetailItem(
                    'Electricity Fee', challan.electricityFee.toString()),
                _buildDetailItem(
                    'Water Charges', challan.waterCharges.toString()),
                _buildDetailItem(
                    'Room Charges', challan.roomCharges.toString()),
                _buildDetailItem(
                    'Total Amount', challan.beforeDueDate.toString()),
                _buildDetailItem(
                    'Issue Date',
                    DateFormat('dd-MM-yyyy')
                        .format(challan.issueDate.toDate().toLocal())),
                _buildDetailItem(
                    'Due Date',
                    DateFormat('dd-MM-yyyy')
                        .format(challan.dueDate.toDate().toLocal())),
              ],
            ),
          ),
          actions: <Widget>[
            if (challan.status == 'Pending')
              TextButton(
                onPressed: () {
                  changeStatus(challan.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Mark as Paid'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, String sr, String challan,
      String amount, String status) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistoryHeader(),
            Divider(color: Colors.green.shade200, thickness: 1),
            const SizedBox(height: 10),
            _buildHistoryRow(sr, challan, amount, status),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderItem('SR'),
        _buildHeaderItem('Challan'),
        _buildHeaderItem('Amount'),
        _buildHeaderItem('Status'),
      ],
    );
  }

  Widget _buildHeaderItem(String text) {
    return Expanded(
      child: Center(
        child: AppText(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHistoryRow(
      String sr, String challan, String amount, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRowItem(sr),
        _buildRowItem(challan),
        _buildRowItem(amount),
        _buildStatusItem(status),
      ],
    );
  }

  Widget _buildRowItem(String text) {
    return Expanded(
      child: Center(
        child: AppText(
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusItem(String status) {
    Color statusColor;
    if (status == 'Paid') {
      statusColor = Colors.green;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'Paid' ? Icons.check_circle : Icons.pending,
              color: statusColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            AppText(
              text: status,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              textColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }
}
