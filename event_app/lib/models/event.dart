class Event {
  final int id;
  final String name;
  final DateTime dateTime;
  final String location;
  final int attendanceCount;
  final String imageUrl;

  Event({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.location,
    required this.attendanceCount,
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      dateTime: DateTime.parse(json['date_time'] ?? ''),
      location: json['location'] ?? '',
      attendanceCount: json['attendance_count'] ?? 0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_time': dateTime.toIso8601String(),
      'location': location,
      'attendance_count': attendanceCount,
      'image_url': imageUrl,
    };
  }
}
