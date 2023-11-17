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
  StreamSubscription<Position>? _activeTrackingStream;
  StreamSubscription<Position>? _passiveTrackingStream;

  StreamController<TrackPoint> _activeUpdateStreamController =
      StreamController<TrackPoint>();

  StreamController<LatLng> _passiveUpdateStreamController =
      StreamController<LatLng>();

  bool _isRecording = false;
  final List<TrackPoint> _trackRecording = [];

  final int _distanceFilter;

  LocationService(this._distanceFilter);

  Future<Position> getPosition() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position?> getLastPosition() async {
    return Geolocator.getLastKnownPosition();
  }

  Stream<TrackPoint> startActiveTracking() {
    _isRecording = true;

    return _startActiveTracking();
  }

  void stopActiveTracking() {
    _isRecording = false;
    _activeTrackingStream?.cancel();
  }

  Stream<LatLng> startPassiveTracking() => _startPassiveTracking();

  void stopPassiveTracking() {
    _passiveTrackingStream?.cancel();
  }

  List<TrackPoint> getActiveTrack() {
    return _trackRecording;
  }

  void saveActiveTrack() {
    if (_trackRecording.isEmpty) return;

    stopActiveTracking();
    _saveTrackToDisk().then((value) => _trackRecording.clear());
  }

  void discardActiveTrack() {
    stopActiveTracking();
    _trackRecording.clear();
  }

  Stream<LatLng> _startPassiveTracking() {
    var stream = Geolocator.getPositionStream();

    _passiveTrackingStream = stream.listen(_onPassiveTrackingStreamUpdate);

    return _passiveUpdateStreamController.stream;
  }

  void _onPassiveTrackingStreamUpdate(Position? position) {
    if (position == null) {
      return;
    }

    var latLng = LatLng(position.latitude, position.longitude);
    _passiveUpdateStreamController.add(latLng);
  }

  Stream<TrackPoint> _startActiveTracking() {
    var locationSettings = _getAndroidSettings();
    var positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);

    _activeTrackingStream =
        positionStream.listen(_onActiveTrackingStreamUpdate);

    return _activeUpdateStreamController.stream;
  }

  void _onActiveTrackingStreamUpdate(Position? position) {
    if (position == null) {
      return;
    }

    if (_isRecording) {
      var trackPoint = TrackPoint(
          latitude: position.latitude,
          longitude: position.longitude,
          elevation: position.altitude,
          datetime: position.timestamp!);

      _trackRecording.add(trackPoint);
      _activeUpdateStreamController.add(trackPoint);
    }
  }

  AndroidSettings _getAndroidSettings() {
    return AndroidSettings(
        distanceFilter: _distanceFilter,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "RANGR will continue to receive location updates in the background",
          notificationTitle: "Background Location Usage",
          enableWakeLock: true,
        ));
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
