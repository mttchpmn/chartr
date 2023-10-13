import 'dart:async';
import 'dart:ui';

import 'package:chartr/components/coordinate_display.dart';
import 'package:chartr/components/map_ui_overlay.dart';
import 'package:chartr/components/map_icons.dart';
import 'package:chartr/components/paint_layer/paint_layer.dart';
import 'package:chartr/components/position_icon.dart';
import 'package:chartr/models/ais_position_report.dart';
import 'package:chartr/models/map_provider.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/services/coordinate_service.dart';
import 'package:chartr/services/location_service.dart';
import 'package:chartr/services/map_provider_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class FullScreenMapWidget extends StatefulWidget {
  const FullScreenMapWidget({super.key});

  @override
  FullScreenMapWidgetState createState() => FullScreenMapWidgetState();
}

class FullScreenMapWidgetState extends State<FullScreenMapWidget> {
  final MapController _mapController = MapController();
  final MapProviderService mapProviderService = MapProviderService();
  final LocationService locationService = LocationService(1);

  late MapProvider _mapProvider;
  MapType _mapType = MapType.street;

  bool _showNorthUp = true;
  bool _isDrawing = false;

  LatLng _deviceLocation = const LatLng(-36.839325, 174.802966);
  LatLng? _mapCenterLatLng;
  GridRef? _mapCenterGrid;

  List<Marker> _markers = [];
  List<OverlayImage> _images = [];

  double _currentSpeed = 0;
  double _currentHeading = 0;
  List<LatLng> _deviceLocations = [];

  void _onLocationUpdate(LocationUpdate update) {
    setState(() {
      _deviceLocations = update.track;
      _currentSpeed = update.speed;
      _currentHeading = update.heading;
      _deviceLocation = update.currentPosition;
    });
  }

  void _startTracking() async {
    await locationService.initializeAsync();
    locationService.startTracking(_onLocationUpdate);
  }

  @override
  void initState() {
    super.initState();
    _initMapProvider();

    _startTracking();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onToggleLocationTracking(bool hasTrackingEnabled) {
    debugPrint("Location tracking: [$hasTrackingEnabled]");
    hasTrackingEnabled
        ? locationService.startTracking(_onLocationUpdate)
        : locationService.stopTracking();
  }

  void _initMapProvider() {
    _mapProvider = mapProviderService.getMapProvider(_mapType);
  }

  void _onDrawToggle() {
    setState(() {
      _isDrawing = !_isDrawing;
    });
    print("Drawing: $_isDrawing");
  }

  void _setMapProvider(MapType mapType) {
    var mapProvider = mapProviderService.getMapProvider(mapType);

    setState(() {
      _mapType = mapType;
      _mapProvider = mapProvider;
    });

    _refreshMap();

    print("Set map to ${_mapProvider.mapType.toString()}");
  }

  void _refreshMap() {
    var currentCenter = _mapController.center;
    var currentZoom = _mapController.zoom;
    var currentBearing = _mapController.rotation;
    _mapController.moveAndRotate(currentCenter, currentZoom, currentBearing);
    debugPrint("Refreshed map");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // FIXME - Adding this throws off the paintlayer by the AppBar's height
      // appBar: AppBar(
      //   title: Text(
      //       "Speed: ${_currentSpeed.toStringAsFixed(1)} | Heading: ${_currentHeading.toStringAsFixed(1)}"),
      // ),
      // drawer: const Drawer( // TODO - Implement nav drawer
      //   child: Text("Chartr"),
      // ),
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          nonRotatedChildren: [],
          options: _buildMapOptions(),
          children: _buildMapChildren(),
        ),
        Visibility(
          visible: !_isDrawing,
          child: MapUiOverlay(
            onToggleLocationTracking: _onToggleLocationTracking,
            onSelectMapType: _setMapProvider,
            onDrawToggle: _onDrawToggle,
            mapController: _mapController,
            mapCenterLatLng: _mapCenterLatLng,
            mapCenterGrid: _mapCenterGrid,
            deviceLocation: _deviceLocation,
          ),
        ),
        Visibility(
          visible: _isDrawing,
          child: PaintUiOverlay(
            onExit: _onExitDrawMode,
            onSaveImage: _onDrawSave,
          ),
        ),
      ]),
    );
  }

  List<Widget> _buildMapChildren() {
    List<Widget> result = [];

    var deviceLocation = Marker(
        point: LatLng(_deviceLocation.latitude, _deviceLocation.longitude),
        width: 80,
        height: 80,
        builder: (context) => const PositionIcon());

    List<Marker> markers = [];
    markers.add(deviceLocation);
    markers.addAll(_markers);

    var deviceLocations = [
      const LatLng(37.410337, -122.048840),
      const LatLng(37.493567, -121.999931)
    ];

    var tileLayers = _mapProvider.getTileLayers();
    var markerLayer = MarkerLayer(markers: markers);

    var polylineLayer = PolylineLayer(
      polylines: [
        Polyline(points: _deviceLocations, color: Colors.black, strokeWidth: 6),
        Polyline(
            points: _deviceLocations, color: Colors.deepOrange, strokeWidth: 3),
      ],
    );

    var imageLayer = OverlayImageLayer(
      overlayImages: _images,
    );

    result.addAll(tileLayers);
    result.add(polylineLayer);
    result.add(markerLayer);
    result.add(imageLayer);

    return result;
  }

  MapOptions _buildMapOptions() {
    return MapOptions(
      onPositionChanged: (position, hasGesture) {
        if (position.center != null) {
          var grid = CoordinateService().latLngToGrid(position.center!);
          setState(() {
            _mapCenterGrid = grid;
          });
        }
        setState(() {
          _mapCenterLatLng = position.center;
        });
        // debugPrint("Map zoom: ${mapController.zoom}");
        // _handleTopoZoom(position);
      },
      center: _deviceLocation,
      interactiveFlags: _showNorthUp
          ? InteractiveFlag.pinchZoom | InteractiveFlag.drag
          : InteractiveFlag.all,
      zoom: 12,
    );
  }

  _onDrawSave(MemoryImage image) async {
    var overlay = OverlayImage(
        bounds: LatLngBounds(
            _mapController.bounds!.northWest, _mapController.bounds!.southEast),
        imageProvider: image);

    setState(() {
      _images.add(overlay);
    });

    _onExitDrawMode();
  }

  _onExitDrawMode() {
    setState(() {
      _isDrawing = false;
    });
  }
}
