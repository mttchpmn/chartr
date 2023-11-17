import 'package:chartr/blocs/active_track_bloc.dart';
import 'package:chartr/blocs/tracks_bloc.dart';
import 'package:chartr/repositories/user_settings_gateway.dart';
import 'package:chartr/themes/theme_generator.dart';
import 'package:chartr/views/map_screen.dart';
import 'package:chartr/views/settings_screen.dart';
import 'package:chartr/views/tracks_screen.dart';
import 'package:chartr/views/waypoints_screen.dart';
import 'package:chartr/views/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<TracksBloc>(create: (_) => TracksBloc()),
        BlocProvider<ActiveTrackBloc>(create: (_) => ActiveTrackBloc())
      ],
      child: Consumer<UserSettings>(
        builder: (context, userSettings, child) {
          return FutureBuilder<Settings>(
            future: userSettings.getSettings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  var settings = snapshot.data!;
                  return MaterialApp(
                    routes: {
                      '/home': (context) => MapScreen(),
                      '/weather': (context) => WeatherScreen(),
                      '/waypoints': (context) => const WaypointScreen(),
                      '/tracks': (context) => const TracksScreen(),
                      '/downloads': (context) => const Placeholder(),
                      '/settings': (context) => const SettingsScreen(),
                    },
                    title: 'RANGR',
                    theme: _themeGenerator.getTheme(settings.themeName),
                    home: const Scaffold(
                      body: MapScreen(),
                    ),
                  );
                } else {
                  return MaterialApp(
                    home: Scaffold(
                      body: Center(child: Text('Error loading settings 1')),
                    ),
                  );
                }
              }
              // Show a loading spinner while waiting for the settings
              return MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
