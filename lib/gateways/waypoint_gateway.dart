class WaypointGateway {
  List<Waypoint> _waypoints = [];

  WaypointGateway() {
    _waypoints.add(Waypoint(
        latitude: -36.843357,
        longitude: 174.761334,
        name: "WORK",
        description: "Harmoney office"));
  }

  bool saveWaypoint(Waypoint waypoint) {
    _waypoints.add(waypoint);

    return true;
  }

  bool deleteWaypoint(String waypointName) {
    return true;
  }

  List<Waypoint> loadWaypoints() {
    return _waypoints;
  }
}

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
}
