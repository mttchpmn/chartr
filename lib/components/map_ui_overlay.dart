import 'package:chartr/components/coordinate_display.dart';
import 'package:chartr/components/crosshair.dart';
import 'package:chartr/components/map_icons.dart';
import 'package:chartr/components/map_layer_dialog.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/services/coordinate_service.dart';
import 'package:chartr/views/map_view.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapUiOverlay extends StatelessWidget {
  final VoidCallback onToggleNorthUp;
  final VoidCallback onScrollToLocation;
  final VoidCallback onDrawToggle;
  final Function(MapType) onSelectMapType;
  Icon northButtonIcon;

  // final Color _iconColor = const Color(0xFF41548C);
  final Color _foregroundColor = Colors.deepOrange;
  final Color _backgroundColor = Colors.black87;

  LatLng? mapCenter;
  GridRef? mapCenterGrid;

  MapUiOverlay({
    super.key,
    required this.onToggleNorthUp,
    required this.northButtonIcon,
    required this.onSelectMapType,
    required this.onScrollToLocation,
    required this.onDrawToggle,
    required this.mapCenter,
    required this.mapCenterGrid,
  });

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
                      onSelectMapType(MapType.street);
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
                      onSelectMapType(MapType.topographic);
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
                      onSelectMapType(MapType.nautical);
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
                      onSelectMapType(MapType.satellite);
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
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
          child: Icon(MapIcons.layer_group, color: _foregroundColor),
          mini: true,
        ),
      ),
      Positioned(
        top: 100, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            onToggleNorthUp();
          },
          child: northButtonIcon,
          mini: true,
        ),
      ),
      Positioned(
        top: 150, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            onScrollToLocation();
          },
          child: Icon(MapIcons.location_arrow, color: _foregroundColor),
          mini: true,
        ),
      ),
      Positioned(
        top: 200, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          onPressed: () {
            onDrawToggle();
          },
          child: Icon(Icons.draw, color: _foregroundColor),
          mini: true,
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
          child: Icon(MapIcons.map_marker_alt, color: _foregroundColor),
          mini: true,
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
          child: Icon(Icons.route, color: _foregroundColor),
          mini: true,
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
                SnackBar(
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
          mapCenter: mapCenter,
          mapCenterGrid: mapCenterGrid,
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
