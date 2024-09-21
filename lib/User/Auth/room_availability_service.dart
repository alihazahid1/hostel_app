import 'package:cloud_firestore/cloud_firestore.dart';

class RoomAvailabilityService {
  final CollectionReference roomsRef =
      FirebaseFirestore.instance.collection('roomavailability');

  Future<void> initializeRoomAvailability() async {
    final blocks = ['A', 'B', 'C'];
    const roomsPerBlock = 4;
    const seatsPerRoom = 4;

    for (String block in blocks) {
      for (int roomNumber = 1; roomNumber <= roomsPerBlock; roomNumber++) {
        final docId = '${block}_Room$roomNumber';
        await roomsRef.doc(docId).set({
          'block': block,
          'roomNumber': roomNumber,
          'availableSeats': seatsPerRoom,
        });
      }
    }
  }
}
