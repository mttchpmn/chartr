import 'package:chartr/components/coordinate_display.dart';
import 'package:chartr/components/crosshair.dart';
import 'package:chartr/components/map_icons.dart';
import 'package:chartr/components/waypoint_form.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/services/coordinate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUiOverlay extends StatefulWidget {
  final VoidCallback onDrawToggle;
  final Function(MapType) onSelectMapType;
  final VoidCallback onToggleLocationTracking;
  final VoidCallback onScrollToCurrentLocation;

  LatLng deviceLocation;
  LatLng? mapCenterLatLng;
  GridRef? mapCenterGrid;
  MapController mapController;

  bool hasTrackingEnabled;

  final VoidCallback onSelectFirstPoint;
  final VoidCallback onSelectSecondPoint;
  final VoidCallback onFinishMeasurement;

  final Function(String, String?) onAddWaypoint;

  final VoidCallback onStartRouting;

  MapUiOverlay(
      {super.key,
      required this.onSelectMapType,
      required this.onDrawToggle,
      required this.deviceLocation,
      required this.mapCenterLatLng,
      required this.mapCenterGrid,
      required this.mapController,
      required this.hasTrackingEnabled,
      required this.onToggleLocationTracking,
      required this.onScrollToCurrentLocation,
      required this.onSelectFirstPoint,
      required this.onSelectSecondPoint,
      required this.onFinishMeasurement,
      required this.onAddWaypoint,
      required this.onStartRouting});

  @override
  State<MapUiOverlay> createState() => _MapUiOverlayState();
}

class _MapUiOverlayState extends State<MapUiOverlay> {
  final Color _foregroundColor = Colors.deepOrange;
  final Color _backgroundColor = Colors.black87;

  bool _showNorthUp = true;

  Icon _getNorthButtonIcon() {
    return _showNorthUp
        ? Icon(Icons.navigation, color: _foregroundColor)
        : const Icon(Icons.navigation, color: Colors.grey);
  }

  Icon _getLocationTrackingIcon() {
    return widget.hasTrackingEnabled
        ? Icon(Icons.location_on, color: _foregroundColor)
        : const Icon(Icons.location_off, color: Colors.grey);
  }

  void _toggleLocationTracking() {
    widget.onToggleLocationTracking();
  }

  void _showAddWaypointSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.black87,
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: WaypointForm(
                onSaveWaypoint: widget.onAddWaypoint,
              ),
            ));
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

            var text = widget.hasTrackingEnabled
                ? "Location tracking disabled"
                : "Location tracking enabled";
            var color = widget.hasTrackingEnabled ? Colors.red : Colors.green;

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
          onPressed: widget.onScrollToCurrentLocation,
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
            _handleAddWaypoint(context);
          },
          mini: true,
          child: Icon(Icons.add_location, color: _foregroundColor),
        ),
      ),
      Positioned(
        bottom: 10,
        left: 65,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            widget.onStartRouting();
          },
          mini: true,
          child: Icon(Icons.route, color: _foregroundColor),
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
      DistanceMeasureButton(
        backgroundColor: _backgroundColor,
        onSelectFirstPoint: widget.onSelectFirstPoint,
        onSelectSecondPoint: widget.onSelectSecondPoint,
        onFinishMeasurement: widget.onFinishMeasurement,
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

  void _handleAddWaypoint(BuildContext context) =>
      _showAddWaypointSheet(context);
}

class DistanceMeasureButton extends StatefulWidget {
  final Color _backgroundColor;
  final VoidCallback onSelectFirstPoint;
  final VoidCallback onSelectSecondPoint;
  final VoidCallback onFinishMeasurement;

  const DistanceMeasureButton({
    super.key,
    required Color backgroundColor,
    required this.onSelectFirstPoint,
    required this.onSelectSecondPoint,
    required this.onFinishMeasurement,
  }) : _backgroundColor = backgroundColor;

  @override
  State<DistanceMeasureButton> createState() => _DistanceMeasureButtonState();
}

class _DistanceMeasureButtonState extends State<DistanceMeasureButton> {
  int _state = 0;

  void _onFirstTap() {
    // Start measuring
    setState(() {
      _state = 1;
    });

    widget.onSelectFirstPoint();
  }

  void _onSecondTap() {
    // Finish measuring
    setState(() {
      _state = 2;
    });

    widget.onSelectSecondPoint();
  }

  void _onThirdTap() {
    // Back to start
    setState(() {
      _state = 0;
    });

    widget.onFinishMeasurement();
  }

  Icon _getIcon() {
    switch (_state) {
      case 1:
        return Icon(
          Icons.start,
          color: Colors.deepOrange,
        );
      case 2:
        return Icon(
          Icons.flag,
          color: Colors.deepOrange,
        );
      default:
        return Icon(
          MapIcons.drafting_compass,
          color: Colors.deepOrange,
        );
    }
  }

  void _handleTap() {
    switch (_state) {
      case 0:
        return _onFirstTap();
      case 1:
        return _onSecondTap();
      case 2:
        return _onThirdTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 15,
      child: FloatingActionButton(
        backgroundColor: widget._backgroundColor,
        onPressed: _handleTap,
        mini: true,
        child: _getIcon(),
      ),
    );
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
