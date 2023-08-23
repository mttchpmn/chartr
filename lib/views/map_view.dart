import 'package:chartr/components/map_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FullScreenMapWidget extends StatefulWidget {
  @override
  _FullScreenMapWidgetState createState() => _FullScreenMapWidgetState();
}

class _FullScreenMapWidgetState extends State<FullScreenMapWidget> {
  final MapController mapController = MapController();
  bool _showNorthUp = true;

  void _toggleNorthUp() {
    var currentCenter = mapController.center;
    var currentZoom = mapController.zoom;
    mapController.moveAndRotate(currentCenter, currentZoom, 0);
    setState(() {
      _showNorthUp = !_showNorthUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var defaultProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    var linzApiKey = '';

    var topo50Provider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50767/EPSG:3857/{z}/{x}/{y}.png';
    var topo250Provider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50798/EPSG:3857/{z}/{x}/{y}.png';
    var northIslandMarineProvider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/set=4758/EPSG:3857/{z}/{x}/{y}.png';

    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(-36.862091, 174.851387),
            // San Francisco coordinates
            interactiveFlags: _showNorthUp
                ? InteractiveFlag.pinchZoom | InteractiveFlag.drag
                : InteractiveFlag.all,
            zoom: 12,
          ),
          nonRotatedChildren: [],
          children: [
            TileLayer(
              // urlTemplate:  defaultProvider,
              urlTemplate: topo50Provider,
              // urlTemplate:  topo250Provider,
              // urlTemplate: northIslandMarineProvider,
              userAgentPackageName: 'com.chartr',
            ),
          ],
        ),
        ButtonStack(onToggleNorthUp: () {
          _toggleNorthUp();
        }, northButtonIcon: _showNorthUp ? Icon(MapIcons.arrow_up) : Icon(MapIcons.compass),),
      ]),
    );
  }
}

class ButtonStack extends StatelessWidget {
  final VoidCallback onToggleNorthUp;
  Icon northButtonIcon;

  ButtonStack({
    super.key,
    required this.onToggleNorthUp,
    required this.northButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 50, // Adjust the position as needed
        right: 15,
        child: FloatingActionButton(
          onPressed: () {
            // Your action here
          },
          child: Icon(MapIcons.layer_group),
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
            // Your action here
          },
          child: Icon(MapIcons.location_arrow),
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
          child: Icon(MapIcons.map_marker_alt),
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
          child: Icon(MapIcons.drafting_compass),
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
            child: Icon(MapIcons.record_vinyl),
            mini: true,
          ),
        ),
      )
    ]);
  }
}
