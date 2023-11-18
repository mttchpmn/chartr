import 'dart:convert';

import 'package:geolocator/geolocator.dart';

class Track {
  String name;
  List<TrackPoint> trackPoints;
  late DateTime dateTime;
  late double totalDistance;
  late double totalAscent;
  late double totalDescent;
  late Duration elapsedTime;

  Track({required this.name, required this.trackPoints}) {
    dateTime = trackPoints.first.datetime;
    totalDistance = _calculateDistance(trackPoints);
    totalAscent = _getTotalAscent(trackPoints);
    totalDescent = _getTotalDescent(trackPoints);
    elapsedTime = _getTrackElapsedTime(trackPoints);
  }

  double _calculateDistance(trackPoints) {
    var totalDistance = 0.0;
    for (var i = 0; i < trackPoints.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        trackPoints[i].latitude,
        trackPoints[i].longitude,
        trackPoints[i + 1].latitude,
        trackPoints[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  double _getTotalAscent(List<TrackPoint> trackPoints) {
    var totalAscent = 0.0;
    for (var i = 0; i < trackPoints.length - 1; i++) {
      var elevationChange =
          trackPoints[i + 1].elevation - trackPoints[i].elevation;
      if (elevationChange > 0) totalAscent += elevationChange;
    }
    return totalAscent;
  }

  double _getTotalDescent(List<TrackPoint> trackPoints) {
    var totalDescent = 0.0;
    for (var i = 0; i < trackPoints.length - 1; i++) {
      var elevationChange =
          trackPoints[i + 1].elevation - trackPoints[i].elevation;
      if (elevationChange < 0) totalDescent += elevationChange;
    }
    return totalDescent;
  }

  Duration _getTrackElapsedTime(List<TrackPoint> trackPoints) {
    if (trackPoints.isEmpty) return Duration.zero;
    return trackPoints.last.datetime.difference(trackPoints.first.datetime);
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    var name = json['name'];
    var trackPoints = (json['trackPoints'] as List)
        .map((item) => TrackPoint.fromJson(item))
        .toList();

    return Track(name: name, trackPoints: trackPoints);
  }

  String toJson() {
    var tp = trackPoints.map((e) {
      return {
        'latitude': e.latitude,
        'longitude': e.longitude,
        'elevation': e.elevation,
        'datetime': e.datetime.toIso8601String()
      };
    }).toList();

    var result = {'name': name, 'trackPoints': tp};

    return jsonEncode(result);
  }

  String toGpxString() {
    var name = "Track-${trackPoints.first.datetime.toIso8601String()}";
    var track = buildTrack(name);

    return '''
    <?xml version="1.0" encoding="UTF-8"?>
      <gpx version="1.1" creator="RANGR"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns="http://www.topografix.com/GPX/1/1"
           xsi:schemaLocation="http://www.topografix.com/GPX/1/1 
           http://www.topografix.com/GPX/1/1/gpx.xsd">
       $track
      </gpx>
    ''';
  }

  String buildTrack(String name) {
    var track = trackPoints.map(buildTrackPoint).toList().join("\n");

    return '''
     <trk>
     <name>$name</name>
       <trkseg>
       $track 
       </trkseg>
     </trk>
   ''';
  }

  String buildTrackPoint(TrackPoint point) {
    return '''
      <trkpt lat="${point.latitude}" lon="${point.longitude}">
        <ele>${point.elevation}</ele> 
        <time>${point.datetime}</time>
      </trkpt>
    ''';
  }
}

class TrackPoint {
  final double latitude;
  final double longitude;
  final double elevation;
  final DateTime datetime;

  TrackPoint(
      {required this.latitude,
      required this.longitude,
      required this.elevation,
      required this.datetime});

  factory TrackPoint.fromJson(Map<String, dynamic> json) {
    return TrackPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
      elevation: json['elevation'],
      datetime: DateTime.parse(json['datetime']),
    );
  }
}
