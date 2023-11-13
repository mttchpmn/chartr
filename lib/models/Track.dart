class Track {
  String name;
  List<TrackPoint> trackPoints;

  Track({required this.name, required this.trackPoints});

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
}
