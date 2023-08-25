import 'package:chartr/components/map_icons.dart';
import 'package:chartr/components/map_layer_dialog.dart';
import 'package:chartr/models/map_type.dart';
import 'package:flutter/material.dart';

class MapButtonStack extends StatelessWidget {
  final VoidCallback onToggleNorthUp;
  final VoidCallback onScrollToLocation;
  final Function(MapType) onSelectMapType;
  Icon northButtonIcon;

  final Color _iconColor = const Color(0xFF41548C);

  MapButtonStack({
    super.key,
    required this.onToggleNorthUp,
    required this.northButtonIcon,
    required this.onSelectMapType,
    required this.onScrollToLocation,
  });

  void _showMapLayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MapLayerDialog(
          onIconPressed: (mapType) {
            onSelectMapType(mapType);
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 50, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          onPressed: () {
            _showMapLayerDialog(context);
          },
          child: Icon(MapIcons.layer_group, color: _iconColor),
          mini: true,
        ),
      ),
      Positioned(
        top: 100, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
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
          onPressed: () {
            onScrollToLocation();
          },
          child: Icon(MapIcons.location_arrow, color: _iconColor),
          mini: true,
        ),
      ),
      Positioned(
        bottom: 10,
        left: 15,
        child: FloatingActionButton(
          onPressed: () {
            // Your action here for the bottom button
          },
          child: Icon(MapIcons.map_marker_alt, color: _iconColor),
          mini: true,
        ),
      ),
      Positioned(
        bottom: 10,
        left: 65,
        child: FloatingActionButton(
          onPressed: () {
            // Your action here for the bottom button
          },
          child: Icon(MapIcons.drafting_compass, color: _iconColor),
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
            onPressed: () {
              // Your action here for the bottom button
            },
            child: Icon(MapIcons.record_vinyl, color: _iconColor),
            mini: true,
          ),
        ),
      )
    ]);
  }
}
