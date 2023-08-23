import 'package:chartr/components/map_icons.dart';
import 'package:chartr/components/map_layer_dialog.dart';
import 'package:chartr/models/map_type.dart';
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
  String _mapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  void _toggleNorthUp() {
    var currentCenter = mapController.center;
    var currentZoom = mapController.zoom;
    mapController.moveAndRotate(currentCenter, currentZoom, 0);
    setState(() {
      _showNorthUp = !_showNorthUp;
    });
  }

  String _getMapTileProvider(MapType mapType) {
    var defaultProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    var linzApiKey = '';

    var topo50Provider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50767/EPSG:3857/{z}/{x}/{y}.png';
    var topo250Provider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50798/EPSG:3857/{z}/{x}/{y}.png';
    var northIslandMarineProvider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/set=4758/EPSG:3857/{z}/{x}/{y}.png';

    switch (mapType) {
      case MapType.openStreetMap:
        return defaultProvider;
      case MapType.topo50:
        return topo50Provider;
      case MapType.topo250:
        return topo250Provider;
      case MapType.marine:
        return northIslandMarineProvider;
    }
  }

  void _changeMapType(MapType mapType) {
    var provider = _getMapTileProvider(mapType);

    setState(() {
      _mapProvider = provider;
    });
    var currentCenter = mapController.center;
    var currentZoom = mapController.zoom;
    var currentBearing = mapController.rotation;
    mapController.moveAndRotate(currentCenter, currentZoom, currentBearing);

    debugPrint("Set map to $provider");
  }

  @override
  Widget build(BuildContext context) {
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
              urlTemplate: _mapProvider,
              userAgentPackageName: 'com.chartr',
            ),
          ],
        ),
        ButtonStack(
          onToggleNorthUp: () {
            _toggleNorthUp();
          },
          northButtonIcon:
              _showNorthUp ? Icon(MapIcons.arrow_up) : Icon(MapIcons.compass),
          onSelectMapType: (mapType) {
            _changeMapType(mapType);
          },
        ),
      ]),
    );
  }
}

class ButtonStack extends StatelessWidget {
  final VoidCallback onToggleNorthUp;
  final Function(MapType) onSelectMapType;
  Icon northButtonIcon;

  ButtonStack({
    super.key,
    required this.onToggleNorthUp,
    required this.northButtonIcon,
    required this.onSelectMapType,
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
