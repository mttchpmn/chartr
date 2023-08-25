import 'package:chartr/models/map_provider.dart';
import 'package:chartr/models/map_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapProviderService {
  static String linzApiKey = dotenv.env['LINZ_API_KEY'] ?? "";
  static String thunderForestApiKey = dotenv.env['THUNDERFOREST_API_KEY'] ?? "";

  final List<MapProvider> _mapProviders = [
    TopoMapProvider("https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50767/EPSG:3857/{z}/{x}/{y}.png", "https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/layer=50798/EPSG:3857/{z}/{x}/{y}.png"),
    NauticalMapProvider("https://tiles-cdn.koordinates.com/services;key=$linzApiKey/tiles/v4/set=4758/EPSG:3857/{z}/{x}/{y}.png"),
    CycleMapProvider("https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=$thunderForestApiKey")
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