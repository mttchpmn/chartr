import 'package:chartr/components/map_widget.dart';
import 'package:chartr/repositories/user_settings_gateway.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettings>(
      builder: (context, userSettings, child) {
        return FutureBuilder<Settings>(
          future: userSettings.getSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var settings = snapshot.data!;
                return FullScreenMapWidget(
                  userSettings: settings,
                );
              } else {
                return const Scaffold(
                  body: Center(child: Text('Error loading user settings')),
                );
              }
            }
            // Show a loading spinner while waiting for the settings
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}
