class RoomChangeRequestModel {
  String requestId;
  final String currentBlock;
  final String currentRoomNo;
  final String newBlock;
  final String newRoomNo;
  final String reason;
  final String uid;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String status;

  RoomChangeRequestModel({
    required this.requestId,
    required this.currentBlock,
    required this.currentRoomNo,
    required this.newBlock,
    required this.newRoomNo,
    required this.reason,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.status,
  });

  factory RoomChangeRequestModel.fromMap(Map<String, dynamic> map) {
    return RoomChangeRequestModel(
      requestId: map['requestId'] ?? '',
      currentBlock: map['currentBlock'],
      currentRoomNo: map['currentRoomNo'],
      newBlock: map['newBlock'],
      newRoomNo: map['newRoomNo'],
      reason: map['reason'],
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'currentBlock': currentBlock,
      'currentRoomNo': currentRoomNo,
      'newBlock': newBlock,
      'newRoomNo': newRoomNo,
      'reason': reason,
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'status': status,
    };
  }
}
