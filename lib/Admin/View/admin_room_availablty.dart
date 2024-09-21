import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hostel_app/Res/AppColors/appColors.dart';
import 'package:hostel_app/Res/Widgets/app_text.dart';
import 'package:hostel_app/User/View/panaroma_screen.dart';
import 'admin_update_room_availability_screen.dart';

class AdminRoomAvailability extends StatefulWidget {
  const AdminRoomAvailability({super.key});

  @override
  State<AdminRoomAvailability> createState() => _AdminRoomAvailabilityState();
}

class _AdminRoomAvailabilityState extends State<AdminRoomAvailability> {
  final CollectionReference roomsRef =
      FirebaseFirestore.instance.collection('roomavailability');

  final Map<String, String> roomImages = {
    'A_Room1': 'assets/pana1.jpeg',
    'A_Room2': 'assets/pana2.jpeg',
    'A_Room3': 'assets/pana3.jpeg',
    'A_Room4': 'assets/pana4.jpeg',
    'B_Room1': 'assets/splash.jpg',
    'B_Room2': 'assets/pana6.jpeg',
    'B_Room3': 'assets/pana7.jpeg',
    'B_Room4': 'assets/pana1.jpeg',
  };

  @override
  void initState() {
    super.initState();
    initializeRoomsIfNeeded();
    roomsRef.snapshots().listen((_) {
      setState(() {});
    });
  }

  Future<void> initializeRoomsIfNeeded() async {
    QuerySnapshot querySnapshot = await roomsRef.get();
    if (querySnapshot.docs.isEmpty) {
      await initializeRooms();
    }
  }

  Future<void> initializeRooms() async {
    final blocks = ['A', 'B', 'C'];
    const roomsPerBlock = 4;
    const seatsPerRoom = 4;

    for (String block in blocks) {
      for (int roomNumber = 1; roomNumber <= roomsPerBlock; roomNumber++) {
        final docId = '${block}_Room$roomNumber';
        await roomsRef.doc(docId).set({
          'block': block,
          'room': '$roomNumber',
          'availableSeats': seatsPerRoom,
          'imageUrl': 'assets/pana1.jpeg',
        });
      }
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
          text: 'Room Availabilities',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          textColor: Colors.white,
        ),
        backgroundColor: AppColors.green,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const UpdateRoomAvailabilityScreen());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: roomsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No rooms available'));
          } else {
            List<DocumentSnapshot> rooms = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return buildRoomCard(rooms[index], context);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildRoomCard(DocumentSnapshot room, BuildContext context) {
    final data = room.data() as Map<String, dynamic>?;

    if (data == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Card(
          child: ListTile(
            title: Text('Room Data not available'),
          ),
        ),
      );
    }

    final availableSeats = data['availableSeats'] ?? 0;
    final block = data['block'];
    final roomNumber = data['room'];
    final imageUrl = roomImages[room.id] ?? 'assets/pana1.jpeg';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImageView(imageUrl: imageUrl),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: availableSeats > 0 ? Colors.green : Colors.red),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: imageUrl,
                  child: Image.asset(
                    imageUrl,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 50);
                    },
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Block: $block',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Room: $roomNumber',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        availableSeats > 0
                            ? 'Available Seats: $availableSeats'
                            : 'No seats available',
                        style: TextStyle(
                            color: availableSeats > 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
