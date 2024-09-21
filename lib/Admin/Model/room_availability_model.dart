class RoomAvailabilityModel {
  final String roomNumber;
  final String block;
  final int capacity;

  RoomAvailabilityModel({
    required this.roomNumber,
    required this.block,
    required this.capacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'room': roomNumber,
      'block': block,
      'availableSeats': capacity,
    };
  }
}