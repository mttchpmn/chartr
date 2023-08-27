import 'package:chartr/models/map_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class MapProvider {
  static String packageName = 'com.chartr';

  MapType get mapType;

  String get baseProviderUrl;

  String onZoomLevelChange(double zoomLevel) {
    return baseProviderUrl;
  }

  List<TileLayer> getTileLayers();
}

class LayerData {
  final String layerUrl;
  double maxZoom;
  double minZoom;
  final Color backgroundColor;

  LayerData(
      {required this.layerUrl,
      this.maxZoom = 25,
      this.minZoom = 5,
      this.backgroundColor = const Color.fromRGBO(0, 0, 0, 0)});
}

class LayeredMapProvider implements MapProvider {
  LayeredMapProvider(
      {required List<LayerData> layerData, required MapType mapType})
      : _layerData = layerData,
        _mapType = mapType;

  @override
  String get baseProviderUrl => throw UnimplementedError();

  final List<LayerData> _layerData;
  final MapType _mapType;

  @override
  List<TileLayer> getTileLayers() {
    var tileLayers = _layerData
        .map((e) => TileLayer(
              urlTemplate: e.layerUrl,
              userAgentPackageName: MapProvider.packageName,
              maxZoom: e.maxZoom,
              backgroundColor: e.backgroundColor,
            ))
        .toList();

    return tileLayers;
  }

  @override
  MapType get mapType => _mapType;

  @override
  String onZoomLevelChange(double zoomLevel) {
    // TODO: implement onZoomLevelChange
    throw UnimplementedError();
  }
}
