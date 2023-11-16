import 'dart:convert';
import 'dart:io';

import 'package:chartr/models/waypoint.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class WaypointGateway {
  List<Waypoint> _waypoints = [];

  WaypointGateway() {
    loadWaypointsFromDisk();
  }

  Future<void> saveWaypoint(Waypoint waypoint) async {
    _waypoints.add(waypoint);

    await _writeWaypointsToDisk();
  }

  Future<void> deleteWaypoint(String waypointName) async {
    _waypoints.removeWhere((element) => element.name == waypointName);

    await _writeWaypointsToDisk();
  }

  List<Waypoint> getWaypoints() {
    return _waypoints;
  }

  String _buildWaypointString() {
    var wpts = _waypoints.map((e) => e.toJson()).toList();
    return json.encode(wpts);
  }

  Future<File> get _waypointsFile async {
    var folder = await getApplicationDocumentsDirectory();
    var filePath = "${folder.path}/waypoints.json";

    return File(filePath);
  }

  Future<List<Waypoint>> loadWaypointsFromDisk() async {
    var localFile = await _waypointsFile;
    var json = await localFile.readAsString();
    List<dynamic> waypointList = jsonDecode(json);

    var waypoints = waypointList.map((e) => Waypoint.fromJson(e)).toList();

    _waypoints = waypoints;

    return waypoints;
  }

  Future<void> _writeWaypointsToDisk() async {
    var localFile = await _waypointsFile;
    var data = _buildWaypointString();
    await localFile.writeAsString(data);

    debugPrint("Saved waypoints to disk");
    debugPrint(data);
  }
}
