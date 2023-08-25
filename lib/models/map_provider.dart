import 'package:chartr/models/map_type.dart';
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

class TopoMapProvider implements MapProvider {
  final String _topo250Url;
  final String _topo50Url;
  String _activeProvider;

  @override
  String get baseProviderUrl => _topo250Url;

  @override
  MapType get mapType => MapType.topographic;

  TopoMapProvider(this._topo50Url, this._topo250Url) :
        _activeProvider = _topo250Url;


  @override
  String onZoomLevelChange(zoomLevel) {
    _activeProvider = zoomLevel < 15 ? _topo250Url : _topo50Url;

    return _activeProvider;
  }

  @override
  List<TileLayer> getTileLayers() {
    return [
      TileLayer(
        urlTemplate: _activeProvider,
        userAgentPackageName: MapProvider.packageName,
      )
    ];
  }
}

class NauticalMapProvider implements MapProvider {
  final String _baseProviderUrl;

  @override
  String get baseProviderUrl => _baseProviderUrl;

  @override
  MapType get mapType => MapType.nautical;

  NauticalMapProvider(this._baseProviderUrl);

  @override
  List<TileLayer> getTileLayers() {
    return [
      TileLayer(
        urlTemplate: _baseProviderUrl,
        userAgentPackageName: MapProvider.packageName,
      )
    ];
  }

  @override
  String onZoomLevelChange(double zoomLevel) {
    // TODO: implement onZoomLevelChange
    throw UnimplementedError();
  }

}

class CycleMapProvider implements MapProvider {
  final String _baseProviderUrl;

  @override
  String get baseProviderUrl => _baseProviderUrl;

  @override
  MapType get mapType => MapType.cycle;

  CycleMapProvider(this._baseProviderUrl);

  @override
  List<TileLayer> getTileLayers() {
    return [
      TileLayer(
        urlTemplate: _baseProviderUrl,
        userAgentPackageName: 'com.chartr',
      )
    ];
  }

  @override
  String onZoomLevelChange(double zoomLevel) {
    // TODO: implement onZoomLevelChange
    throw UnimplementedError();
  }

}

