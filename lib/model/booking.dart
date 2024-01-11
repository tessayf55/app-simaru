import 'dart:convert';

class Booking {
  int id;
  int userId;
  int ruanganId;
  DateTime startBook;
  DateTime endBook;

  Booking({
    this.id = 0,
    required this.userId,
    required this.ruanganId,
    required this.startBook,
    required this.endBook,
  });

  factory Booking.fromJson(Map<String, dynamic> map) {
    return Booking(
      id: map["id"],
      userId: int.parse(map["user_id"].toString()),
      ruanganId: int.parse(map["ruangan_id"].toString()),
      startBook: DateTime.parse(map["start_book"]),
      endBook: DateTime.parse(map["end_book"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "ruangan_id": ruanganId,
      "start_book": startBook.toUtc().toIso8601String(),
      "end_book": endBook.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Booking{id: $id, user_id: $userId, ruangan_id: $ruanganId, start_book: $startBook, end_book: $endBook}';
  }
}

List<Booking> bookingFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Booking>.from(data.map((item) => Booking.fromJson(item)));
}

String bookingToJson(Booking data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
