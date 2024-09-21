import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference roomsRef =
      FirebaseFirestore.instance.collection('roomavailability');

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      String? userId = getCurrentUserId();

      if (userId == null) {
        throw Exception('No user is currently signed in.');
      }

      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('User data not found.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }

  Future<void> addUserToFirestore(
    String firstName,
    String lastName,
    String email,
    String password,
    String phoneNumber,
    String block,
    String room,
    String rollNo,
    String cnic,
    String cnicImageUrl,
  ) async {
    try {
      String? userId = getCurrentUserId(); // Get the current user ID

      if (userId == null) {
        throw Exception('No user is currently signed in.');
      }

      await usersCollection.doc(userId).set({
        'imageUrl': '',
        'firstName': firstName.toLowerCase(),
        'lastName': lastName,
        'email': email,
        'uid': userId,
        'password': password,
        'phoneNumber': phoneNumber,
        'block': block,
        'room': room,
        'rollNo': rollNo,
        'cnic': cnic,
        'cnicImageUrl': cnicImageUrl,
      });
    } catch (e) {
      print('Error adding user to Firestore: $e');
      rethrow; // Rethrow the error to handle it elsewhere if needed
    }
  }

  Future<bool> checkRoomAvailability(String block, String roomNumber) async {
    try {
      final docId = '${block}_Room$roomNumber';
      DocumentSnapshot roomSnapshot = await roomsRef.doc(docId).get();
      if (roomSnapshot.exists) {
        final data = roomSnapshot.data() as Map<String, dynamic>?;
        final availableSeats = data?['availableSeats'];
        if (availableSeats != null && availableSeats > 0) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking room availability: $e');
      rethrow;
    }
  }

  Future<void> decrementRoomSeats(String block, String roomNumber) async {
    try {
      final docId = '${block}_Room$roomNumber';
      DocumentSnapshot roomSnapshot = await roomsRef.doc(docId).get();
      if (roomSnapshot.exists) {
        final data = roomSnapshot.data() as Map<String, dynamic>?;
        final availableSeats = data?['availableSeats'];
        if (availableSeats != null && availableSeats > 0) {
          await roomsRef.doc(docId).update({
            'availableSeats': availableSeats - 1,
          });
        } else {
          throw Exception('No available seats in this room');
        }
      } else {
        throw Exception('Room not found');
      }
    } catch (e) {
      print('Error decrementing room seats: $e');
      rethrow;
    }
  }
}
