class Waypoint {
  final double latitude;
  final double longitude;
  final String name;
  final String? description;

  Waypoint(
      {required this.latitude,
        required this.longitude,
        required this.name,
        required this.description});

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'description': description,
    };
  }
}
