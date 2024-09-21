class UserModel {
  final String uid;
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String block;
  final String room;
  final String rollNo;
  final String cnic;
  final String cnicImageUrl; // Add this field

  UserModel({
    required this.uid,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.block,
    required this.room,
    required this.rollNo,
    required this.cnic,
    required this.cnicImageUrl, // Initialize in constructor and map functions
  });

  // Update your toMap function to include cnicImageUrl
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'block': block,
      'room': room,
      'rollNo': rollNo,
      'cnic': cnic,
      'cnicImageUrl': cnicImageUrl,
    };
  }

  // Update your factory method fromMap to include cnicImageUrl
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      block: map['block'] ?? '',
      room: map['room'] ?? '',
      rollNo: map['rollNo'] ?? '',
      cnic: map['cnic'] ?? '',
      cnicImageUrl: map['cnicImageUrl'] ?? '', // Add this line
    );
  }
}
