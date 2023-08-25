import 'package:chartr/components/map_button_stack.dart';
import 'package:chartr/components/map_icons.dart';
import 'package:chartr/models/map_provider.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/services/location_service.dart';
import 'package:chartr/services/map_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  late MapProvider _mapProvider;

  bool _showNorthUp = true;
  MapType _mapType = MapType.cycle;
  Position? _deviceLocation;
  final Color _iconColor = const Color(0xFF41548C);

  @override
  void initState() {
    super.initState();
    _initMapProvider();
    _setInitialPosition();
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

  // REMOVE
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

    var outdoorsProvider =
        "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=$thunderForestApiKey";
    var cycleProvider =
        "https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=$thunderForestApiKey";

    switch (mapType) {
      case MapType.street:
        return defaultProvider;
      case MapType.topographic:
        return topo50Provider;
      case MapType.nautical:
        return northIslandMarineProvider;
      case MapType.satellite:
        return satelliteProvider;
      case MapType.outdoor:
        return outdoorsProvider;
      case MapType.cycle:
        return cycleProvider;
    }
  }

  void _setMapProvider(MapType mapType) {
    debugPrint("Request to set map to ${mapType.toString()}");
    var mapProvider = mapProviderService.getMapProvider(mapType);

    print("New map provider: ${mapProvider.mapType.toString()}");

    setState(() {
      _mapType = mapType;
      _mapProvider = mapProvider;
    });

    _refreshMap();

    debugPrint("Set map to ${_mapProvider.mapType.toString()}");
  }

  void _refreshMap() {
    var currentCenter = mapController.center;
    var currentZoom = mapController.zoom;
    var currentBearing = mapController.rotation;
    mapController.moveAndRotate(currentCenter, currentZoom, currentBearing);
    debugPrint("Refreshed map");
  }

  // REMOVE
  // void _handleTopoZoom(position) {
  //   if (_mapType != MapType.topo50 && _mapType != MapType.topo250) {
  //     return;
  //   }
  //
  //   var mapType = position.zoom < 12 ? MapType.topo250 : MapType.topo50;
  //   debugPrint(position.zoom.toString());
  //   debugPrint(_mapType.toString());
  //
  //   setState(() {
  //     _mapType = mapType;
  //     _mapProvider = _getMapTileProvider(mapType);
  //   });
  // }

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
        _buildMapButtonStack(),
      ]),
    );
  }

  List<Widget> _buildMapChildren() {
    List<Widget> result = [];

    var tileLayers = _mapProvider.getTileLayers();
    var markerLayer = MarkerLayer(
      markers: [
        Marker(
          point: LatLng(-36.862091, 174.851387),
          // point: LatLng(_deviceLocation!.latitude, _deviceLocation!.longitude),
          width: 80,
          height: 80,
          builder: (context) => Icon(
            MapIcons.location_arrow,
            color: _iconColor,
          ),
        ),
      ],
    );

    // result.add(TileLayer(
    // ));

    var tileLayer = TileLayer(
      urlTemplate:
          "https://tiles-cdn.koordinates.com/services;key=ea77759bac544955a28e87f9a05c821c/tiles/v4/layer=52343/EPSG:3857/{z}/{x}/{y}.png",
      userAgentPackageName: MapProvider.packageName,
    );

    result.addAll(tileLayers);
    result.add(markerLayer);

    return result;
  }

  MapButtonStack _buildMapButtonStack() {
    return MapButtonStack(
      onToggleNorthUp: () {
        _toggleNorthUp();
      },
      onScrollToLocation: _scrollToCurrentPosition,
      northButtonIcon: _showNorthUp
          ? Icon(MapIcons.arrow_up, color: _iconColor)
          : Icon(MapIcons.compass, color: _iconColor),
      onSelectMapType: (mapType) {
        print("User tapped ${mapType.toString()}");
        _setMapProvider(mapType);
      },
    );
  }

  MapOptions _buildMapOptions() {
    return MapOptions(
      onPositionChanged: (position, hasGesture) {
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
}
