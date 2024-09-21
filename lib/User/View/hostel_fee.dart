import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/User/View/history_screen.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HostelFee extends StatefulWidget {
  const HostelFee({super.key});

  @override
  State<HostelFee> createState() => _HostelFeeState();
}

class _HostelFeeState extends State<HostelFee> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? challanData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the screen initializes
  }

  void fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final uid = currentUser.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .listen((DocumentSnapshot userDoc) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null) {
            fetchChallanData();
          }
        });
      });
    }
  }

  void fetchChallanData() async {
    if (userData != null) {
      String block = userData?["block"];
      String room = userData?["room"];
      String name = userData?['firstName'];
      FirebaseFirestore.instance
          .collection('challan')
          .where('blockNo', isEqualTo: block)
          .where('roomNo', isEqualTo: room)
          .where('studentName', isEqualTo: name)
          .orderBy('createdAt', descending: true) // Order by createdAt field
          .limit(1) // Get the latest document
          .snapshots()
          .listen((QuerySnapshot challanSnapshot) {
        if (challanSnapshot.docs.isNotEmpty) {
          setState(() {
            challanData =
                challanSnapshot.docs.first.data() as Map<String, dynamic>?;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
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
            text: 'Hostel Fees',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            textColor: Colors.white,
          ),
          backgroundColor: AppColors.green,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const HistoryScreen());
                },
                icon: const Icon(Icons.history)),
            if (challanData != null)
              IconButton(
                  onPressed: () {
                    _printForm();
                  },
                  icon: const Icon(Icons.print)),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/hostel.svg',
                    width: 200.0,
                    height: 200.0,
                    semanticsLabel: 'Hostel Fees',
                  ),
                  const Spacer(),
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green, width: 3),
                      color: Colors.green.shade100,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText(
                              text: 'Hostel Details',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Name: ', fontWeight: FontWeight.w500),
                              AppText(
                                text: userData != null &&
                                        userData!['firstName'] != null
                                    ? userData!['firstName']
                                        .toLowerCase()
                                        .substring(
                                            0,
                                            userData!['firstName'].length > 15
                                                ? 15
                                                : userData!['firstName'].length)
                                    : '',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              const Spacer(),
                              const AppText(
                                  text: 'RollNo: ',
                                  fontWeight: FontWeight.w500),
                              AppText(text: '${userData?["rollNo"]}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Block No: ',
                                  fontWeight: FontWeight.w500),
                              AppText(text: '${userData?["block"]}'),
                              const Spacer(),
                              const AppText(
                                  text: 'Room No: ',
                                  fontWeight: FontWeight.w500),
                              AppText(text: '${userData?["room"]}'),
                            ],
                          ),
                          const AppText(
                              text: 'Payment Details',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Mess Fee:',
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  text:
                                      '${challanData?["messFee"] ?? '5000'}/- PKR'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Parking charges:',
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  text:
                                      '${challanData?["parkingCharges"] ?? '100'}/- PKR'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Electricity Fee:',
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  text:
                                      '${challanData?["electricityFee"] ?? '100'}/- PKR'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Water charges:',
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  text:
                                      '${challanData?["waterCharges"] ?? '200'}/- PKR'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Room charges:',
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  text:
                                      '${challanData?["roomCharges"] ?? '5000'}/- PKR'),
                            ],
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                  text: 'Month Fee:',
                                  fontWeight: FontWeight.w500),
                              AppText(
                                  text:
                                      '${challanData?["amount"] ?? '14000'}/- PKR'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _printForm() async {
    bool isPaid = challanData?['status'] == 'Paid'; // Check if status is paid

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
                    'Hostel Fees',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Text('Hostel Details',
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
                          pw.Text('Name: ${userData?["firstName"] ?? 'John'}'),
                          pw.Text('RollNo: ${userData?["rollNo"] ?? '0000'}'),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Block No: ${userData?["block"] ?? 'A'}'),
                          pw.Text('Room No: ${userData?["room"] ?? '101'}'),
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
                          pw.Text('${challanData?["messFee"] ?? '5000'}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Parking charges:'),
                          pw.Text(
                              '${challanData?["parkingCharges"] ?? '100'}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Electricity Fee:'),
                          pw.Text(
                              '${challanData?["electricityFee"] ?? '100'}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Water charges:'),
                          pw.Text(
                              '${challanData?["waterCharges"] ?? '100'}/- PKR'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Room charges:'),
                          pw.Text(
                              '${challanData?["roomCharges"] ?? '5000'}/- PKR'),
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
                    pw.Text('Month Fee:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${challanData?["amount"] ?? '10300'}/- PKR',
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
}
