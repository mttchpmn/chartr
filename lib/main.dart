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
    var purplePrimary = Colors.purpleAccent;
    var darkPurple = Color(0xFF2C0E37);
    var black = Colors.black;
    var palePurple = Color(0xFFFAE6FA);
    var accent = Color(0xFF76E5FC);

    var purpleHaze = ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: darkPurple,
        primaryColorLight: palePurple,
        highlightColor: accent,
        drawerTheme: DrawerThemeData(
          backgroundColor: darkPurple,
        ),
        inputDecorationTheme: InputDecorationTheme(
            prefixIconColor: purplePrimary,
            filled: true,
            fillColor: darkPurple,
            suffixIconColor: purplePrimary),
        listTileTheme: ListTileThemeData(
            iconColor: purplePrimary,
            textColor: palePurple,
            selectedTileColor: accent),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.black),
        iconTheme: IconThemeData(color: purplePrimary),
        textTheme: TextTheme(
            displayLarge: TextStyle(color: palePurple),
            displayMedium: TextStyle(color: palePurple),
            displaySmall: TextStyle(color: palePurple),
            headlineLarge: TextStyle(color: palePurple),
            headlineMedium: TextStyle(color: palePurple),
            headlineSmall: TextStyle(color: palePurple),
            titleLarge: TextStyle(color: palePurple),
            titleMedium: TextStyle(color: palePurple),
            titleSmall: TextStyle(color: palePurple),
            bodyLarge: TextStyle(color: palePurple),
            bodyMedium: TextStyle(color: palePurple),
            bodySmall: TextStyle(color: palePurple),
            labelLarge: TextStyle(color: palePurple),
            labelMedium: TextStyle(color: palePurple),
            labelSmall: TextStyle(color: palePurple)),
        appBarTheme: AppBarTheme(
            color: purplePrimary, iconTheme: IconThemeData(color: black)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: purplePrimary,
            primary: purplePrimary,
            primaryContainer: black,
            secondary: darkPurple,
            tertiary: accent));

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
      theme: purpleHaze,
      home: const Scaffold(
        body: FullScreenMapWidget(),
      ),
    );
  }
}
