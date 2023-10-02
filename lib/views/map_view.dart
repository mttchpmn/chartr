import 'dart:async';
import 'dart:ui';

import 'package:chartr/components/map_button_stack.dart';
import 'package:chartr/components/map_icons.dart';
import 'package:chartr/components/paint_layer/paint_layer.dart';
import 'package:chartr/models/ais_position_report.dart';
import 'package:chartr/models/map_provider.dart';
import 'package:chartr/models/map_type.dart';
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
  final MapController mapController = MapController();
  final MapProviderService mapProviderService = MapProviderService();
  final LocationService locationService = LocationService();
  late StreamSubscription<AisPositionReport> streamSubscription;

  late StreamSubscription<Position> positionStream;

  late MapProvider _mapProvider;

  bool _showNorthUp = true;
  bool _isDrawing = false;
  MapType _mapType = MapType.street;
  Position? _deviceLocation;

  final Color _iconColor = const Color(0xFF41548C);

  List<Marker> _markers = [];
  List<OverlayImage> _images = [];

  @override
  void initState() {
    super.initState();
    _initMapProvider();
    _setInitialPosition();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        setState(() {
          _deviceLocation = position;
        });
      }
    });

    // final aisService = AisService();
    //
    // streamSubscription = aisService.stream.listen((event) {
    //   var marker = Marker(
    //       point: LatLng(event.latitude, event.longitude),
    //       builder: (c) =>
    //           // Column(children: [Icon(Icons.sailing), Text(event.shipName)],)
    //           Icon(Icons.sailing));
    //
    //   setState(() {
    //     _markers.add(marker);
    //   });
    // });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  void _initMapProvider() {
    _mapProvider = mapProviderService.getMapProvider(_mapType);
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
    var currentCenter = mapController.center;
    var currentZoom = mapController.zoom;
    var currentBearing = mapController.rotation;
    mapController.moveAndRotate(currentCenter, currentZoom, currentBearing);
    debugPrint("Refreshed map");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: mapController,
          nonRotatedChildren: [],
          options: _buildMapOptions(),
          children: _buildMapChildren(),
        ),
        if (_isDrawing)
          PaintLayer(
            onExit: _onExitDrawMode,
            onSaveImage: _onDrawSave,
          ),
        Visibility(
          visible: !_isDrawing,
          child: MapButtonStack(
            onToggleNorthUp: _toggleNorthUp,
            onScrollToLocation: _scrollToCurrentPosition,
            onSelectMapType: _setMapProvider,
            onDrawToggle: _onDrawToggle,
            northButtonIcon: _showNorthUp
                ? Icon(MapIcons.long_arrow_alt_up, color: _iconColor)
                : Icon(MapIcons.compass, color: _iconColor),
          ),
        ),
      ]),
    );
  }

  List<Widget> _buildMapChildren() {
    List<Widget> result = [];

    var deviceLocation = Marker(
      // point: LatLng(-36.862091, 174.851387),
      point: LatLng(_deviceLocation!.latitude, _deviceLocation!.longitude),
      width: 80,
      height: 80,
      builder: (context) => Icon(
        MapIcons.location_arrow,
        color: _iconColor,
      ),
    );

    List<Marker> markers = [];
    markers.add(deviceLocation);
    markers.addAll(_markers);

    var tileLayers = _mapProvider.getTileLayers();
    var markerLayer = MarkerLayer(markers: markers);

    var imageLayer = OverlayImageLayer(
      overlayImages: _images,
    );

    result.addAll(tileLayers);
    result.add(markerLayer);
    result.add(imageLayer);

    return result;
  }

  MapOptions _buildMapOptions() {
    return MapOptions(
      onPositionChanged: (position, hasGesture) {
        // debugPrint("Map zoom: ${mapController.zoom}");
        // _handleTopoZoom(position);
      },
      center: _deviceLocation == null
          ? LatLng(-36.862091, 174.851387)
          : LatLng(_deviceLocation!.latitude, _deviceLocation!.longitude),
      // San Francisco coordinates
      interactiveFlags: _showNorthUp
          ? InteractiveFlag.pinchZoom | InteractiveFlag.drag
          : InteractiveFlag.all,
      zoom: 12,
    );
  }

  _onDrawSave(MemoryImage image) async {
    var overlay = OverlayImage(
        bounds: LatLngBounds(
            mapController.bounds!.northWest, mapController.bounds!.southEast),
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
