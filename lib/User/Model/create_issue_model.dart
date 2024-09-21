class IssueModel {
  final String? id; // Add id field
  final String? roomNumber;
  final String? blockNumber;
  final String? email;
  final String? phoneNumber;
  final String? issue;
  final String? reason;
  final String? firstName;
  final String? lastName;
  final String? uid;
  final String? status; // Add status field

  IssueModel({
    this.id, // Initialize id field
    this.firstName,
    this.lastName,
    this.roomNumber,
    this.blockNumber,
    this.email,
    this.phoneNumber,
    this.issue,
    this.reason,
    this.uid,
    this.status, // Initialize status field
  });

  Map<String, dynamic> toMap() {
    return {
      'roomNumber': roomNumber,
      'firstName': firstName,
      'lastName': lastName,
      'blockNumber': blockNumber,
      'email': email,
      'phoneNumber': phoneNumber,
      'issue': issue,
      'reason': reason,
      'uid': uid,
      'status': status, // Include status in the map
    };
  }

  static IssueModel fromMap(Map<String, dynamic> map, String id) { // Add id parameter
    return IssueModel(
      id: id, // Assign id field
      firstName: map['firstName'],
      lastName: map['lastName'],
      roomNumber: map['roomNumber'],
      blockNumber: map['blockNumber'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      issue: map['issue'],
      reason: map['reason'],
      uid: map['uid'],
      status: map['status'], // Assign status field
    );
  }
}
