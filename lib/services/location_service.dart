import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:latlong2/latlong.dart';

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
  final List<LatLng> _track = [];
  double _currentSpeed = 0;
  double _currentHeading = 0;

  final int _distanceFilter;

  LocationService(this._distanceFilter);

  void startTracking(Function(LocationUpdate) onLocationUpdate) {
    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: _distanceFilter
    );
    // var locationSettings = AndroidSettings(
    //     accuracy: LocationAccuracy.best,
    //     distanceFilter: _distanceFilter,
    //     intervalDuration: const Duration(seconds: 3),
    //     foregroundNotificationConfig: const ForegroundNotificationConfig(
    //       // Keep app alive in background
    //       notificationText:
    //           "Chartr will continue to receive your location in the background for tracking purposes",
    //       notificationTitle: "Background Location Usage",
    //       enableWakeLock: true,
    //     ));

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (position != null) {
        _currentSpeed = position.speed / 1000 * 60 * 60; // ms to kmh
        _currentHeading = position.heading;
        var currentPosition = LatLng(position.latitude, position.longitude);
        _track.add(currentPosition);

        var update = LocationUpdate(
            currentPosition: currentPosition,
            speed: _currentSpeed,
            heading: _currentHeading,
            track: _track);

        onLocationUpdate(update);
      }
    });
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

  Future<Position> getPosition() async {
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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
