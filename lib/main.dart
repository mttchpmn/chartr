import 'package:chartr/gateways/user_settings_gateway.dart';
import 'package:chartr/rangr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await FlutterMapTileCaching.initialise();
  await FMTC.instance('mapStore').manage.createAsync();

  runApp(ChangeNotifierProvider(
      create: (context) => UserSettings(), child: const Rangr()));
}
