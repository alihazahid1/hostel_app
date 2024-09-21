class Admin {
  final String uid;
  final String email;
  final String password;


  Admin({
    required this.uid,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,

    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',

    );
  }
}
