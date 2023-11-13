import 'dart:async';
import 'dart:io';

import 'package:chartr/models/Track.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

class LocationUpdate {
  final LatLng currentPosition;
  final double speed;
  final double heading;
  final List<LatLng> track;

  LocationUpdate(
      {required this.currentPosition,
      required this.speed,
      required this.heading,
      required this.track});
}

class LocationService {
  StreamSubscription<Position>? _positionStream;

  bool _isRecording = false;
  final List<TrackPoint> _trackRecording = [];

  final List<LatLng> _track = [];
  double _currentSpeed = 0;
  double _currentHeading = 0;

  final int _distanceFilter;

  LocationService(this._distanceFilter);

  Future<Position> getPosition() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position?> getLastPosition() async {
    return Geolocator.getLastKnownPosition();
  }

  void startTrackRecording() {
    _isRecording = true;
  }

  void stopTrackRecording() {
    _isRecording = false;
  }

  List<TrackPoint> getTrackRecording() {
    return _trackRecording;
  }

  void saveTrackRecording() {
    if (_trackRecording.isEmpty) return;

    _saveTrackToDisk().then((value) => _trackRecording.clear());
  }

  void startTracking(Function(LocationUpdate) onLocationUpdate) {
    var locationSettings = AndroidSettings(
        distanceFilter: _distanceFilter,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "RANGR will continue to receive location updates in the background",
          notificationTitle: "Background Location Usage",
          enableWakeLock: true,
        ));

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position == null) {
        return;
      }

      _currentSpeed = position.speed / 1000 * 60 * 60; // ms to kmh
      _currentHeading = position.heading;
      var currentPosition = LatLng(position.latitude, position.longitude);

      if (_isRecording) {
        var trackPoint = TrackPoint(
            latitude: position.latitude,
            longitude: position.longitude,
            elevation: position.altitude,
            datetime: position.timestamp!);

        _trackRecording.add(trackPoint);
      }

      var trackRecordingLatLng =
          _trackRecording.map((e) => LatLng(e.latitude, e.longitude)).toList();

      var update = LocationUpdate(
          currentPosition: currentPosition,
          speed: _currentSpeed,
          heading: _currentHeading,
          track: trackRecordingLatLng);

      onLocationUpdate(update);
    });
  }

  void stopTracking() {
    _positionStream?.cancel();
  }

  Future<void> initializeAsync() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<void> _saveTrackToDisk() async {
    var dir = await getApplicationDocumentsDirectory();
    var name = "Track-${_trackRecording.first.datetime.toIso8601String()}";
    var path = "${dir.path}/$name.gpx";
    var file = await File(path).create();

    var track = Track(name: name, trackPoints: _trackRecording);
    var content = track.toGpxString();

    await file.writeAsString(content);
  }
}
