import 'package:chartr/views/map_view.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const FullScreenMapWidget(),
        '/data': (context) => const Placeholder(),
        '/weather': (context) => WeatherScreen(),
      },
      title: 'Chartr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: FullScreenMapWidget(),
      ),
    );
  }
}
