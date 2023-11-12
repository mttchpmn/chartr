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
  @override
  Widget build(BuildContext context) {
    var baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      useMaterial3: true,
    );

    var purpleHaze = ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.black),
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 18, color: Colors.black87)),
        appBarTheme: const AppBarTheme(
            color: Colors.purpleAccent,
            iconTheme: IconThemeData(color: Colors.black)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            primary: Colors.purpleAccent,
            secondary: Colors.black));

    var searchAndRescue = ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.black),
        iconTheme: IconThemeData(color: Colors.deepOrange),
        textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 18, color: Colors.black87)),
        appBarTheme: const AppBarTheme(
            color: Colors.deepOrange,
            iconTheme: IconThemeData(color: Colors.black)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            primary: Colors.deepOrange,
            secondary: Colors.black));

    return MaterialApp(
      routes: {
        '/home': (context) => const FullScreenMapWidget(),
        '/weather': (context) => WeatherScreen(),
        '/waypoints': (context) => const WaypointScreen(),
        '/tracks': (context) => const Placeholder(),
        '/downloads': (context) => const Placeholder(),
        '/settings': (context) => const Placeholder(),
      },
      title: 'NAVRANGR',
      theme: searchAndRescue,
      home: const Scaffold(
        body: FullScreenMapWidget(),
      ),
    );
  }
}
