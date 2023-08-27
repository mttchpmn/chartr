class AisPositionReport {
  final double latitude;
  final double longitude;
  final int mmsi;
  final String shipName;

  AisPositionReport({
    required this.latitude,
    required this.longitude,
    required this.mmsi,
    required this.shipName,
  });

  factory AisPositionReport.fromJson(Map<String, dynamic> json) {
    return AisPositionReport(
      latitude: json['Message']['PositionReport']['Latitude'] ?? 0.0,
      longitude: json['Message']['PositionReport']['Longitude'] ?? 0.0,
      mmsi: json['MetaData']['MMSI'] ?? 0,
      shipName: json['MetaData']['ShipName'] ?? 'Unknown',
    );
  }

  @override
  String toString() {
    return "$mmsi $shipName is at position: $latitude, $longitude";
  }
}
