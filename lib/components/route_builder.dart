import 'package:chartr/components/distance_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class RouteBuilder extends StatefulWidget {
  LatLng? mapCenter;

  VoidCallback onExitRouting;
  Function(List<LatLng>) onRouteChange;

  RouteBuilder(
      {super.key,
      required this.mapCenter,
      required this.onExitRouting,
      required this.onRouteChange});

  @override
  State<StatefulWidget> createState() => _RouteBuilderState();
}

class _RouteBuilderState extends State<RouteBuilder> {
  List<LatLng> _route = [];
  double _distance = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 50, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            setState(() {
              _route = [];
            });
            widget.onRouteChange(_route);
            widget.onExitRouting();
          },
          mini: true,
          child: Icon(Icons.clear, color: Colors.deepOrange),
        ),
      ),
      Positioned(
        bottom: 10, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            if (widget.mapCenter != null) {
              setState(() {
                _route.add(widget.mapCenter!);
              });
              if (_route.length > 1) {
                var prevPoint = _route.elementAt(_route.length - 2);
                var newPoint = _route.last;
                var dist = Geolocator.distanceBetween(prevPoint.latitude,
                    prevPoint.longitude, newPoint.latitude, newPoint.longitude);
                setState(() {
                  _distance += dist;
                });
                debugPrint("DIST: $_distance");
                debugPrint("DIST-CALC: $dist");
                debugPrint("LAT 1: ${prevPoint.latitude}");
                debugPrint("LNG 1: ${prevPoint.longitude}");
                debugPrint("LAT 2: ${newPoint.latitude}");
                debugPrint("LNG 2: ${newPoint.longitude}");
              }
              widget.onRouteChange(_route);
            }
          },
          mini: true,
          child: Icon(Icons.add_location, color: Colors.deepOrange),
        ),
      ),
      Positioned(
        bottom: 10, // Adjust the position as needed
        right: 65,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            if (_route.length == 1) {
              setState(() {
                _distance = 0;
              });
            } else {
              var last = _route.last;
              var prev = _route.elementAt(_route.length - 2);

              var dist = Geolocator.distanceBetween(
                  prev.latitude, prev.longitude, last.latitude, last.longitude);
              setState(() {
                _distance -= dist;
              });
            }
            setState(() {
              _route.removeLast();
            });
            widget.onRouteChange(_route);
          },
          mini: true,
          child: Icon(Icons.undo, color: Colors.deepOrange),
        ),
      ),
      Positioned(
        bottom: 60,
        right: 15,
        child: DistanceDisplay(
          distance: _distance,
          bearing: null,
        ),
      )
    ]);
  }
}
