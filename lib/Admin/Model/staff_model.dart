class StaffModel {

  final String firstName;
  final String lastName;
  final String email;
  final String jobRole;
  final String phoneNumber;

  StaffModel({

    required this.firstName,
    required this.lastName,
    required this.email,
    required this.jobRole,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {

      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'jobRole': jobRole,
      'phoneNumber': phoneNumber,
    };
  }

  factory StaffModel.fromMap(Map<String, dynamic> map) {
    return StaffModel(

      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      jobRole: map['jobRole'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
