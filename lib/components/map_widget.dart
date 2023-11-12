import 'package:chartr/components/crosshair.dart';
import 'package:chartr/components/distance_display.dart';
import 'package:chartr/components/map_ui_overlay.dart';
import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/components/paint_layer/paint_layer.dart';
import 'package:chartr/components/position_icon.dart';
import 'package:chartr/components/route_builder.dart';
import 'package:chartr/components/waypoint_icon.dart';
import 'package:chartr/models/grid_ref.dart';
import 'package:chartr/models/map_provider.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/models/waypoint.dart';
import 'package:chartr/services/coordinate_service.dart';
import 'package:chartr/services/location_service.dart';
import 'package:chartr/services/map_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../gateways/user_settings_gateway.dart';
import '../gateways/waypoint_gateway.dart';

class FullScreenMapWidget extends StatefulWidget {
  final Settings userSettings;

  const FullScreenMapWidget({super.key, required this.userSettings});

  @override
  FullScreenMapWidgetState createState() => FullScreenMapWidgetState();
}

class FullScreenMapWidgetState extends State<FullScreenMapWidget> {
  final MapController _mapController = MapController();
  final MapProviderService mapProviderService = MapProviderService();
  final LocationService _locationService = LocationService(1);
  final WaypointGateway _waypointGateway = WaypointGateway();

  late MapProvider _mapProvider;
  MapType _mapType = MapType.street;

  bool _showNorthUp = true;

  bool _hasTrackingEnabled = true;
  LatLng? _deviceLocation;
  LatLng? _mapCenterLatLng;
  GridRef? _mapCenterGrid;

  List<Marker> _markers = [];
  List<OverlayImage> _images = [];

  double _currentSpeed = 0;
  double _currentHeading = 0;
  List<LatLng> _deviceLocations = [];

  LatLng? markerALocation;
  LatLng? markerBLocation;
  double? distanceBetweenMarkers;
  double? bearingBetweenMarkers;

  List<Waypoint> _waypoints = [];

  MapMode _mapMode = MapMode.viewing;

  List<LatLng> _route = [];

  bool _getUiLayerVisibility(MapMode uiLayerMode) {
    return uiLayerMode == _mapMode;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _mapType = widget.userSettings.mapType;
    });

    _initMapProvider();

    _initLastPosition();
    _initTracking();
    _loadWaypoints();
  }

  void _initMapProvider() {
    _mapProvider = mapProviderService.getMapProvider(_mapType);
  }

  Future<void> _initLastPosition() async {
    var lastPos = await _locationService.getLastPosition();
    if (lastPos == null) return;

    var latLng = LatLng(lastPos.latitude, lastPos.longitude);

    setState(() {
      _deviceLocation = latLng;
    });

    _scrollToPosition(latLng);
  }

  Future<void> _initTracking() async {
    await _locationService.initializeAsync();
    _locationService.startTracking(_onLocationUpdate);
  }

  void _onLocationUpdate(LocationUpdate update) {
    if (!mounted) return;

    debugPrint("Location updated");

    setState(() {
      _deviceLocations = update.track;
      _currentSpeed = update.speed;
      _currentHeading = update.heading;
      _deviceLocation = update.currentPosition;
    });
  }

  void _loadWaypoints() async {
    if (!mounted) return;

    await _waypointGateway.loadWaypointsFromDisk();
    var waypoints = _waypointGateway.getWaypoints();

    setState(() {
      _waypoints = waypoints;
    });
  }

  void _scrollToPosition(LatLng latLng) {
    var currentZoom = _mapController.zoom;
    var currentBearing = _mapController.rotation;
    _mapController.moveAndRotate(
        LatLng(latLng.latitude, latLng.longitude), currentZoom, currentBearing);
  }

  void _scrollToCurrentPosition() async {
    var currentZoom = _mapController.zoom;
    var currentBearing = _mapController.rotation;
    var currentPosition = await _locationService.getPosition();
    _mapController.moveAndRotate(
        LatLng(currentPosition.latitude, currentPosition.longitude),
        currentZoom,
        currentBearing);
  }

  void _onWaypointSaved() async {
    _loadWaypoints();
  }

  void _onToggleLocationTracking() {
    setState(() {
      _hasTrackingEnabled = !_hasTrackingEnabled;
    });
    debugPrint("Location tracking: [$_hasTrackingEnabled]");

    _hasTrackingEnabled
        ? _locationService.startTracking(_onLocationUpdate)
        : _locationService.stopTracking();
  }

  void _onStartDrawing() {
    setState(() {
      _mapMode = MapMode.drawing;
    });
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

  void _onSelectFirstPoint() {
    setState(() {
      markerALocation = _mapController.center;
    });
  }

  void _onSelectSecondPoint() {
    setState(() {
      markerBLocation = _mapController.center;
    });

    var distanceBetween = Geolocator.distanceBetween(
      markerALocation!.latitude,
      markerALocation!.longitude,
      markerBLocation!.latitude,
      markerBLocation!.longitude,
    );

    var bearingBetween = Geolocator.bearingBetween(
      markerALocation!.latitude,
      markerALocation!.longitude,
      markerBLocation!.latitude,
      markerBLocation!.longitude,
    );

    setState(() {
      distanceBetweenMarkers = distanceBetween;
      bearingBetweenMarkers = bearingBetween;
    });
  }

  void _onClearMeasurement() {
    setState(() {
      markerALocation = null;
      markerBLocation = null;
      distanceBetweenMarkers = null;
      bearingBetweenMarkers = null;
    });
  }

  void _onStartRouting() {
    setState(() {
      _mapMode = MapMode.routing;
    });
  }

  void _onExitRouting() {
    setState(() {
      _mapMode = MapMode.viewing;
    });
  }

  void _onRouteChange(List<LatLng> route) {
    setState(() {
      _route = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                // Clear the search field or do something else
              },
            ),
          ),
          onChanged: (value) {},
        ),
      ),
      drawer: const MenuDrawer(),
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          nonRotatedChildren: [],
          options: _buildMapOptions(),
          children: _buildMapChildren(),
        ),
        Visibility(
          visible: _getUiLayerVisibility(MapMode.viewing) ||
              _getUiLayerVisibility(MapMode.routing),
          child: const Positioned.fill(
            child: Center(child: Crosshair()),
          ),
        ),
        Visibility(
            visible: _getUiLayerVisibility(MapMode.routing),
            child: RouteBuilder(
              mapCenter: _mapCenterLatLng,
              onExitRouting: _onExitRouting,
              onRouteChange: _onRouteChange,
            )),
        Visibility(
          visible: distanceBetweenMarkers != null,
          child: Positioned(
            bottom: 60,
            right: 15,
            child: DistanceDisplay(
                distance: distanceBetweenMarkers,
                bearing: bearingBetweenMarkers),
          ),
        ),
        Visibility(
          visible: _getUiLayerVisibility(MapMode.viewing),
          child: MapUiOverlay(
            onToggleLocationTracking: _onToggleLocationTracking,
            onSelectMapType: _setMapProvider,
            onDrawToggle: _onStartDrawing,
            mapController: _mapController,
            mapCenterLatLng: _mapCenterLatLng,
            mapCenterGrid: _mapCenterGrid,
            hasTrackingEnabled: _hasTrackingEnabled,
            onScrollToCurrentLocation: _scrollToCurrentPosition,
            deviceLocation: _deviceLocation,
            onSelectFirstPoint: _onSelectFirstPoint,
            onSelectSecondPoint: _onSelectSecondPoint,
            onFinishMeasurement: _onClearMeasurement,
            onAddWaypoint: _onWaypointSaved,
            onStartRouting: _onStartRouting,
          ),
        ),
        Visibility(
          visible: _getUiLayerVisibility(MapMode.drawing),
          child: PaintUiOverlay(
            onExit: _onExitDrawMode,
            onSaveImage: _onDrawSave,
          ),
        ),
      ]),
    );
  }

  List<Marker> _buildWaypoints() {
    List<Marker> result = [];

    _waypoints.forEach((wpt) {
      var m = Marker(
          width: 90,
          height: 60,
          point: LatLng(wpt.latitude, wpt.longitude),
          builder: (ctx) => WaypointIcon(waypoint: wpt));

      result.add(m);
    });

    return result;
  }

  List<Widget> _buildMapChildren() {
    List<Widget> result = [];
    List<Marker> markers = [];
    List<Polyline> polylines = [];
    List<OverlayImage> overlayImages = [];

    polylines.add(Polyline(
        points: _deviceLocations, color: Colors.black, strokeWidth: 6));
    polylines.add(Polyline(
        points: _deviceLocations, color: Colors.deepOrange, strokeWidth: 3));

    markers.addAll(_markers);

    if (_deviceLocation != null) {
      var marker = Marker(
          point: LatLng(_deviceLocation!.latitude, _deviceLocation!.longitude),
          width: 80,
          height: 80,
          builder: (context) => const PositionIcon());

      if (_hasTrackingEnabled) {
        markers.add(marker);
      }
    }

    var imageLayer = OverlayImageLayer(
      overlayImages: _images,
    );

    if (markerALocation != null) {
      var a = Marker(
          point: markerALocation!,
          builder: (ctx) => const Icon(
                Icons.circle,
                size: 20,
                color: Colors.green,
              ));

      markers.add(a);
    }

    if (markerBLocation != null) {
      var b = Marker(
          point: markerBLocation!,
          builder: (ctx) => const Icon(
                Icons.circle,
                color: Colors.red,
                size: 20,
              ));

      markers.add(b);
    }

    // Route
    var routeLine =
        Polyline(points: _route, color: Colors.purpleAccent, strokeWidth: 3);
    polylines.add(routeLine);
    var routeMarkers = _route.map((e) => Marker(
        point: e,
        builder: (ctx) => const Icon(
              Icons.circle,
              color: Colors.purpleAccent,
              size: 15,
            )));
    markers.addAll(routeMarkers);

    // Distance measurement
    if (markerALocation != null && markerBLocation != null) {
      var line = Polyline(
          points: [markerALocation!, markerBLocation!],
          color: Colors.black,
          strokeWidth: 3);
      polylines.add(line);
    }

    var waypoints = _buildWaypoints();
    markers.addAll(waypoints);

    var tileLayers = _mapProvider.getTileLayers();
    var markerLayer = MarkerLayer(markers: markers);

    var polylineLayer = PolylineLayer(polylines: polylines);

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
      _mapMode = MapMode.viewing;
    });
  }
}

enum MapMode { viewing, routing, drawing, navigating }
