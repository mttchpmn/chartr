import 'package:chartr/components/map_icons.dart';
import 'package:chartr/components/map_layer_dialog.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class FullScreenMapWidget extends StatefulWidget {
  @override
  _FullScreenMapWidgetState createState() => _FullScreenMapWidgetState();
}

class _FullScreenMapWidgetState extends State<FullScreenMapWidget> {
  final MapController mapController = MapController();
  final LocationService locationService = LocationService();
  bool _showNorthUp = true;
  MapType _mapType = MapType.openStreetMap;
  String _mapProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  Position? _deviceLocation;
  final Color _iconColor = const Color(0xFF41548C);

  @override
  void initState() {
    super.initState();
    _setInitialPosition();
  }

  Future<void> _setInitialPosition() async {
    var position = await locationService.getPosition();
    setState(() {
      _deviceLocation = position;
    });
  }

  void _toggleNorthUp() {
    var currentCenter = mapController.center;
    var currentZoom = mapController.zoom;
    setState(() {
      _showNorthUp = !_showNorthUp;
    });
    _showNorthUp
        ? mapController.moveAndRotate(currentCenter, currentZoom, 0)
        : mapController.moveAndRotate(currentCenter, currentZoom, 5);
  }

  void _scrollToCurrentPosition() {
    if (_deviceLocation == null) {
      print("Not scrolling as don't have position");
      return;
    }

    var currentZoom = mapController.zoom;
    var currentBearing = mapController.rotation;
    mapController.moveAndRotate(
        LatLng(_deviceLocation!.latitude, _deviceLocation!.longitude),
        currentZoom,
        currentBearing);
  }

  String _getMapTileProvider(MapType mapType) {
    var defaultProvider = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    var linzApiKey = dotenv.env['LINZ_API_KEY'];
    var thunderForestApiKey = dotenv.env['THUNDERFOREST_API_KEY'];

    var topo50Provider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50767/EPSG:3857/{z}/{x}/{y}.png';
    var topo250Provider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50798/EPSG:3857/{z}/{x}/{y}.png';
    var northIslandMarineProvider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/set=4758/EPSG:3857/{z}/{x}/{y}.png';
    var satelliteProvider =
        'https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=109401/EPSG:3857/{z}/{x}/{y}.png';

    var outdoorsProvider = "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=$thunderForestApiKey";
    var cycleProvider = "https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=$thunderForestApiKey";

    switch (mapType) {
      case MapType.openStreetMap:
        return defaultProvider;
      case MapType.topo50:
        return topo50Provider;
      case MapType.topo250:
        return topo250Provider;
      case MapType.marine:
        return northIslandMarineProvider;
      case MapType.satellite:
        return satelliteProvider;
      case MapType.outdoors:
        return outdoorsProvider;
      case MapType.cycle:
        return cycleProvider;
    }
  }

  void _changeMapType(MapType mapType) {
    var provider = _getMapTileProvider(mapType);

    setState(() {
      _mapType = mapType;
      _mapProvider = provider;
    });
    var currentCenter = mapController.center;
    var currentZoom = mapController.zoom;
    var currentBearing = mapController.rotation;
    mapController.moveAndRotate(currentCenter, currentZoom, currentBearing);

    debugPrint("Set map to $provider");
  }

  void _handleTopoZoom(position) {
    if (_mapType != MapType.topo50 && _mapType != MapType.topo250) {
      return;
    }

    var mapType = position.zoom < 12 ? MapType.topo250 : MapType.topo50;
    debugPrint(position.zoom.toString());
    debugPrint(_mapType.toString());

    setState(() {
      _mapType = mapType;
      _mapProvider = _getMapTileProvider(mapType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onPositionChanged: (position, hasGesture) {
              _handleTopoZoom(position);
            },
            center: _deviceLocation == null
                ? LatLng(-36.862091, 174.851387)
                : LatLng(
                    _deviceLocation!.latitude, _deviceLocation!.longitude),
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
            MarkerLayer(
              markers: [
                Marker(
                  // point: LatLng(-36.862091, 174.851387),
                  point: LatLng(_deviceLocation!.latitude, _deviceLocation!.longitude),
                  width: 80,
                  height: 80,
                  builder: (context) => Icon(
                    MapIcons.location_arrow,
                    color: _iconColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        ButtonStack(
          onToggleNorthUp: () {
            _toggleNorthUp();
          },
          onScrollToLocation: _scrollToCurrentPosition,
          northButtonIcon:
              _showNorthUp ? Icon(MapIcons.arrow_up, color: _iconColor) : Icon(MapIcons.compass, color: _iconColor),
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
  final VoidCallback onScrollToLocation;
  final Function(MapType) onSelectMapType;
  Icon northButtonIcon;

  final Color _iconColor = const Color(0xFF41548C);

  ButtonStack({
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
