import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/Res/Widgets/custom_botton.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, dynamic>? userData;
  List<DocumentSnapshot> challansList = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchChallansData();
  }

  String formatDate(Timestamp timestamp) {
    return DateFormat('dd-MM-yyyy').format(timestamp.toDate());
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

  void fetchChallansData() async {
    final QuerySnapshot challansSnapshot =
        await FirebaseFirestore.instance.collection('challan').get();
    setState(() {
      challansList = challansSnapshot.docs;
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
          text: 'History Screen',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
      ),
      body: challansList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: challansList.length,
                      itemBuilder: (context, index) {
                        final challan = challansList[index];
                        if (challan['blockNo'] == userData?['block'] &&
                            challan['roomNo'] == userData?['room'] &&
                            challan['studentName'] == userData?['firstName']) {
                          return Column(
                            children: [
                              AppText(
                                text: DateFormat('dd-MM-yyyy').format(
                                    challan['issueDate'].toDate().toLocal()),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              _buildHistoryCard(
                                context,
                                sr: (index + 1).toString(),
                                challan: challan,
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox(); // Skip rendering if the user's data doesn't match
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: Text('Histrory Not Found')),
    );
  }

  Widget _buildHistoryCard(BuildContext context,
      {required String sr, required DocumentSnapshot challan}) {
    bool isPaid = challan['status'] == 'Paid';

    return GestureDetector(
      onTap: () {
        _showChallanDetails(context, challan);
      },
      child: Card(
        elevation: 10,
        surfaceTintColor: Colors.green.shade200,
        shadowColor: Colors.green.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildHeaderItem('SR'),
                  _buildHeaderItem('Challan'),
                  _buildHeaderItem('Amount'),
                  _buildHeaderItem('Status'),
                  _buildHeaderItem('Print'),
                ],
              ),
              Divider(color: Colors.green.shade200, thickness: 1),
              Row(
                children: [
                  _buildRowItem(sr),
                  _buildRowItem(challan['challanNumber']),
                  _buildRowItem(challan['beforeDueDate'].toString()),
                  _buildStatusItem(challan['status']),
                  IconButton(
                    onPressed: () {
                      _printForm(challan);
                    },
                    icon: const Icon(Icons.print),
                    tooltip: 'Print Challan',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _printForm(DocumentSnapshot challanData) async {
    bool isPaid = challanData['status'] == 'Paid'; // Check if status is paid

    // Load image asynchronously
    ByteData imageData = await rootBundle.load('assets/paid.png');
    Uint8List bytes = imageData.buffer.asUint8List();

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Mahar Hostel',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text('User Details',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Container(
                  decoration: const pw.BoxDecoration(),
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                              'Name: ${userData?["firstName"]}'.toUpperCase()),
                          pw.Text(
                              'Issue Date: ${formatDate(challanData["issueDate"] as Timestamp)}'),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('RollNo: ${userData?["rollNo"]}'),
                          pw.Text(
                              'Due Date: ${formatDate(challanData["dueDate"] as Timestamp)}'),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Block No: ${userData?["block"]}'),
                          pw.Text('Room No: ${userData?["room"]}'),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Payment Details',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: const PdfColor.fromInt(0xff487557), width: 1),
                  ),
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Mess Fee:'),
                          pw.Text('${challanData["messFee"]}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Parking charges:'),
                          pw.Text('${challanData["parkingCharges"]}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Electricity Fee:'),
                          pw.Text('${challanData["electricityFee"]}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Water charges:'),
                          pw.Text('${challanData["waterCharges"]}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Room charges:'),
                          pw.Text('${challanData["roomCharges"]}/- PKR'),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Before DueDate:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${challanData["beforeDueDate"]}/- PKR',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('After DueDate:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${challanData["afterDueDate"]}/- PKR',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Note:',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                  '1. Only Cash & Cheque/Payorder will be accepted.\n'
                  '2. After Due Date student will pay PKR 300/, after 5 days of due date challan\n'
                  '   will not be accepted.\n'
                  '3. The additional amount collected after the due date will be used for need\n'
                  '   based scholarship purposes.\n'
                  '4. Semester fee includes tuition fee and other charges.',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 40),
                if (isPaid)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(bytes),
                      height: 150,
                      width: 150,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );

    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  void _showChallanDetails(BuildContext context, DocumentSnapshot challan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Challan Details',
            style: TextStyle(color: Colors.blue),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Challan Number',
                  _buildStyledContainer(challan['challanNumber'], Colors.cyan)),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow('Student Name', Text(challan['studentName'])),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow(
                'Status',
                _buildStatusColor(challan['status']),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow('Block No', Text(challan['blockNo'])),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow('Room No', Text(challan['roomNo'])),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow('Mess Fee', Text(challan['messFee'].toString())),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow('Parking Charges',
                  Text(challan['parkingCharges'].toString())),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow('Electricity Fee',
                  Text(challan['electricityFee'].toString())),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow(
                  'Water Charges', Text(challan['waterCharges'].toString())),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow(
                  'Room Charges', Text(challan['roomCharges'].toString())),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow(
                  'Before DueDate', Text(challan['beforeDueDate'].toString())),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow(
                  'After DueDate', Text(challan['afterDueDate'].toString())),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow(
                  'Issue Date',
                  Text(DateFormat('dd-MM-yyyy')
                      .format(challan['issueDate'].toDate().toLocal()))),
              const SizedBox(
                height: 10,
              ),
              _buildDetailRow(
                  'Due Date',
                  Text(DateFormat('dd-MM-yyyy')
                      .format(challan['dueDate'].toDate().toLocal()))),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          actions: [
            CustomBotton(
              borderRadius: 5,
              height: 25,
              width: 50,
              fontSize: 12,
              onTap: () {
                Navigator.of(context).pop();
              },
              label: 'Close',
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String title, Widget valueWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        valueWidget,
      ],
    );
  }

  Widget _buildStyledContainer(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildHeaderItem(String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusColor(
    String status,
  ) {
    Color statusColor;
    if (status == 'Paid') {
      statusColor = Colors.green;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildRowItem(String text) {
    return Expanded(
      child: Center(child: Text(text)),
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
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
