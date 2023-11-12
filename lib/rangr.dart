import 'package:chartr/themes/theme_generator.dart';
import 'package:chartr/views/map_screen.dart';
import 'package:chartr/views/settings_screen.dart';
import 'package:chartr/views/waypoints_screen.dart';
import 'package:chartr/views/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Rangr extends StatefulWidget {
  const Rangr({super.key});

  @override
  State<Rangr> createState() => _RangrState();
}

class _RangrState extends State<Rangr> {
  var _themeGenerator = ThemeGenerator();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettings>(
      builder: (context, userSettings, child) {
        return MaterialApp(
          routes: {
            '/home': (context) => const FullScreenMapWidget(),
            '/weather': (context) => WeatherScreen(),
            '/waypoints': (context) => const WaypointScreen(),
            '/tracks': (context) => const Placeholder(),
            '/downloads': (context) => const Placeholder(),
            '/settings': (context) => const SettingsScreen(),
          },
          title: 'RANGR',
          theme: _themeGenerator.getTheme(userSettings.settings.themeName),
          home: const Scaffold(
            body: FullScreenMapWidget(),
          ),
        );
      },
    );
  }
}
