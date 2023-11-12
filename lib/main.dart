import 'package:chartr/themes/theme_generator.dart';
import 'package:chartr/views/map_screen.dart';
import 'package:chartr/views/waypoints_screen.dart';
import 'package:chartr/views/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await FlutterMapTileCaching.initialise();
  await FMTC.instance('mapStore').manage.createAsync();

  runApp(const NavRanger());
}

class NavRanger extends StatefulWidget {
  const NavRanger({super.key});

  @override
  State<NavRanger> createState() => _NavRangerState();
}

class _NavRangerState extends State<NavRanger> {
  var _themeGenerator = ThemeGenerator();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const FullScreenMapWidget(),
        '/weather': (context) => WeatherScreen(),
        '/waypoints': (context) => const WaypointScreen(),
        '/tracks': (context) => const Placeholder(),
        '/downloads': (context) => const Placeholder(),
        '/settings': (context) => const Placeholder(),
      },
      title: 'RANGR',
      theme: _themeGenerator.getTheme(ThemeName.searchAndRescue),
      home: const Scaffold(
        body: FullScreenMapWidget(),
      ),
    );
  }
}
