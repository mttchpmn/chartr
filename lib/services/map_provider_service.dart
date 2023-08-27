import 'package:chartr/models/map_provider.dart';
import 'package:chartr/models/map_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapProviderService {
  static String linzApiKey = dotenv.env['LINZ_API_KEY'] ?? "";
  static String thunderForestApiKey = dotenv.env['THUNDERFOREST_API_KEY'] ?? "";

  static LayeredMapProvider streetMapProvider = LayeredMapProvider(layerData: [
    LayerData(layerUrl: "https://tile.openstreetmap.org/{z}/{x}/{y}.png")
  ], mapType: MapType.street);

  static LayeredMapProvider outdoorMapProvider = LayeredMapProvider(layerData: [
    LayerData(
        layerUrl:
            "https://tile.thunderforest.com/outdoor/{z}/{x}/{y}.png?apikey=$thunderForestApiKey")
  ], mapType: MapType.outdoor);

  static LayeredMapProvider cycleMapProvider = LayeredMapProvider(layerData: [
    LayerData(
        layerUrl:
            "https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=$thunderForestApiKey")
  ], mapType: MapType.cycle);

  static LayeredMapProvider topoMapProvider = LayeredMapProvider(layerData: [
    LayerData(
        layerUrl: // 50
            "https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50767/EPSG:3857/{z}/{x}/{y}.png",
        maxZoom: 25),
    LayerData(
        layerUrl: // 250
            "https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50798/EPSG:3857/{z}/{x}/{y}.png",
        maxZoom: 13),
  ], mapType: MapType.topographic);

  static LayeredMapProvider nauticalMapProvider =
      LayeredMapProvider(layerData: [
    LayerData(
        layerUrl:
            "https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/set=4758/EPSG:3857/{z}/{x}/{y}.png")
  ], mapType: MapType.nautical);

  static LayeredMapProvider satelliteMapProvider =
      LayeredMapProvider(layerData: [
    LayerData(
        layerUrl:
            "https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=109401/EPSG:3857/{z}/{x}/{y}.png",
        maxZoom: 16),
    LayerData(
        layerUrl: // Hi-res Auckland
            "https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=95497/EPSG:3857/{z}/{x}/{y}.png",
        maxZoom: 25)
  ], mapType: MapType.satellite);

  final List<MapProvider> _mapProviders = [
    streetMapProvider,
    outdoorMapProvider,
    cycleMapProvider,
    topoMapProvider,
    nauticalMapProvider,
    satelliteMapProvider
  ];

  MapProvider getMapProvider(MapType mapType) {
    var provider = _mapProviders.where((element) => element.mapType == mapType);

    if (provider.isEmpty) {
      throw Exception("No map provider registered for type $mapType");
    }

    if (provider.length > 1) {
      throw Exception("More than 1 map provider registered for type $mapType");
    }

    return provider.single;
  }
}
