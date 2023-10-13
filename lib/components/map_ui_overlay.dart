import 'package:chartr/components/coordinate_display.dart';
import 'package:chartr/components/crosshair.dart';
import 'package:chartr/components/map_icons.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/services/coordinate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUiOverlay extends StatefulWidget {
  final VoidCallback onDrawToggle;
  final Function(MapType) onSelectMapType;
  final Function(bool) onToggleLocationTracking;

  LatLng deviceLocation;
  LatLng? mapCenterLatLng;
  GridRef? mapCenterGrid;
  MapController mapController;

  MapUiOverlay({
    super.key,
    required this.onSelectMapType,
    required this.onDrawToggle,
    required this.deviceLocation,
    required this.mapCenterLatLng,
    required this.mapCenterGrid,
    required this.mapController,
    required this.onToggleLocationTracking,
  });

  @override
  State<MapUiOverlay> createState() => _MapUiOverlayState();
}

class _MapUiOverlayState extends State<MapUiOverlay> {
  final Color _foregroundColor = Colors.deepOrange;
  final Color _backgroundColor = Colors.black87;

  bool _showNorthUp = true;

  bool _trackLocation = true;

  Icon _getNorthButtonIcon() {
    return _showNorthUp
        ? Icon(Icons.navigation, color: _foregroundColor)
        : const Icon(Icons.navigation, color: Colors.grey);
  }

  Icon _getLocationTrackingIcon() {
    return _trackLocation
        ? Icon(Icons.location_on, color: _foregroundColor)
        : const Icon(Icons.location_off, color: Colors.grey);
  }

  void _scrollToCurrentPosition() {
    var currentZoom = widget.mapController.zoom;
    var currentBearing = widget.mapController.rotation;
    widget.mapController.moveAndRotate(
        LatLng(widget.deviceLocation.latitude, widget.deviceLocation.longitude),
        currentZoom,
        currentBearing);
  }

  void _toggleLocationTracking() {
    setState(() {
      _trackLocation = !_trackLocation;
    });
    widget.onToggleLocationTracking(_trackLocation);
  }

  void _showMapLayerDialog(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.black87,
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Column(
                children: [
                  const Text(
                    'Select map layer',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onSelectMapType(MapType.street);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.drive_eta,
                            color: _foregroundColor,
                          ),
                        ),
                        const Text(
                          'Street',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      widget.onSelectMapType(MapType.topographic);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.hiking,
                            color: _foregroundColor,
                          ),
                        ),
                        const Text(
                          'Topographic',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      widget.onSelectMapType(MapType.nautical);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.directions_boat,
                            color: _foregroundColor,
                          ),
                        ),
                        const Text(
                          'Nautical',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      widget.onSelectMapType(MapType.satellite);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.satellite,
                            color: _foregroundColor,
                          ),
                        ),
                        const Text(
                          'Satellite',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return MapLayerDialog(
    //       onIconPressed: (mapType) {
    //         onSelectMapType(mapType);
    //         Navigator.of(context).pop(); // Close the dialog
    //       },
    //     );
    //   },
    // );
  }

  void _toggleNorthUp() {
    var currentCenter = widget.mapController.center;
    var currentZoom = widget.mapController.zoom;
    setState(() {
      _showNorthUp = !_showNorthUp;
    });
    _showNorthUp
        ? widget.mapController.moveAndRotate(currentCenter, currentZoom, 0)
        : widget.mapController.moveAndRotate(currentCenter, currentZoom, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Positioned.fill(
        child: Center(child: Crosshair()),
      ),
      Positioned(
        top: 50, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            _showMapLayerDialog(context);
          },
          mini: true,
          child: Icon(MapIcons.layer_group, color: _foregroundColor),
        ),
      ),
      Positioned(
        top: 100, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: _toggleNorthUp,
          mini: true,
          child: _getNorthButtonIcon(),
        ),
      ),
      Positioned(
        top: 150, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            _toggleLocationTracking();

            var text = _trackLocation
                ? "Location tracking enabled"
                : "Location tracking disabled";
            var color = _trackLocation ? Colors.green : Colors.red;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: color,
                duration: const Duration(seconds: 1),
                content: Text(text),
              ),
            );
          },
          mini: true,
          child: _getLocationTrackingIcon(),
        ),
      ),
      Positioned(
        top: 200, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: _scrollToCurrentPosition,
          mini: true,
          child: Icon(Icons.my_location, color: _foregroundColor),
        ),
      ),
      Positioned(
        top: 250, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            widget.onDrawToggle();
          },
          mini: true,
          child: Icon(Icons.draw, color: _foregroundColor),
        ),
      ),
      Positioned(
        bottom: 10,
        left: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            // Your action here for the bottom button
          },
          mini: true,
          child: Icon(MapIcons.map_marker_alt, color: Colors.grey),
        ),
      ),
      Positioned(
        bottom: 10,
        left: 65,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            // Your action here for the bottom button
          },
          mini: true,
          child: Icon(Icons.route, color: Colors.grey),
        ),
      ),
      Positioned(
        bottom: 10,
        left:
            MediaQuery.of(context).size.width / 2 - 20, // Centering the button
        child: Container(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: _backgroundColor,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Track recording started'),
                ),
              );
            },
            mini: true,
            child: RecordIcon(
                foregroundColor: _foregroundColor,
                backgroundColor: _backgroundColor),
          ),
        ),
      ),
      Positioned(
        bottom: 60, // Adjust the position as needed
        left: 20,
        child: CoordinateDisplay(
          mapCenter: widget.mapCenterLatLng,
          mapCenterGrid: widget.mapCenterGrid,
        ),
      )
    ]);
  }
}

class RecordIcon extends StatelessWidget {
  const RecordIcon({
    super.key,
    required Color foregroundColor,
    required Color backgroundColor,
  })  : _foregroundColor = foregroundColor,
        _backgroundColor = backgroundColor;

  final Color _foregroundColor;
  final Color _backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _foregroundColor,
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _backgroundColor,
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _foregroundColor,
          ),
        ),
        // const Icon(
        //   Icons.circle,
        //   color: Colors.yellow,
        //   size: 20,
        // ),
      ],
    );
  }
}
