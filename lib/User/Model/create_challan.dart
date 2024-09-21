import 'package:cloud_firestore/cloud_firestore.dart';

class Challan {
  String id;
  String challanNumber;
  String studentName;
  double beforeDueDate;
  double afterDueDate;
  String status;
  String blockNo;
  String roomNo;
  double messFee;
  double parkingCharges;
  double electricityFee;
  double waterCharges;
  double roomCharges;
  Timestamp issueDate;
  Timestamp dueDate; // Add this line

  Challan({
    required this.id,
    required this.challanNumber,
    required this.studentName,
    required this.beforeDueDate,
    required this.afterDueDate,
    required this.status,
    required this.blockNo,
    required this.roomNo,
    required this.messFee,
    required this.parkingCharges,
    required this.electricityFee,
    required this.waterCharges,
    required this.roomCharges,
    required this.issueDate,
    required this.dueDate, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'challanNumber': challanNumber,
      'studentName': studentName,
      'beforeDueDate': beforeDueDate,
      'afterDueDate': afterDueDate,
      'status': status,
      'blockNo': blockNo,
      'roomNo': roomNo,
      'messFee': messFee,
      'parkingCharges': parkingCharges,
      'electricityFee': electricityFee,
      'waterCharges': waterCharges,
      'roomCharges': roomCharges,
      'issueDate': issueDate, // Update this line
      'dueDate': dueDate, // Add this line
    };
  }

  Challan.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        challanNumber = map['challanNumber'],
        studentName = map['studentName'],
        beforeDueDate = map['beforeDueDate'],
        afterDueDate = map['afterDueDate'],
        status = map['status'],
        blockNo = map['blockNo'],
        roomNo = map['roomNo'],
        messFee = map['messFee'],
        parkingCharges = map['parkingCharges'],
        electricityFee = map['electricityFee'],
        waterCharges = map['waterCharges'],
        roomCharges = map['roomCharges'],
        issueDate = map['issueDate'], // Update this line
        dueDate = map['dueDate']; // Add this line
}
