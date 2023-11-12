import 'package:chartr/components/enum_button.dart';
import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/gateways/user_settings_gateway.dart';
import 'package:chartr/models/map_type.dart';
import 'package:chartr/themes/theme_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeName _selectedName;
  late MapType _selectedMapType;

  void _setTheme(ThemeName? name) {
    if (name == null) return;

    setState(() {
      _selectedName = name;
    });

    Provider.of<UserSettings>(context, listen: false).setTheme(name);
  }

  void _setDefaultMapType(MapType? mapType) {
    if (mapType == null) return;

    setState(() {
      _selectedMapType = mapType;
    });

    Provider.of<UserSettings>(context, listen: false)
        .setDefaultMapType(mapType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      drawer: const MenuDrawer(),
      body: FutureBuilder<Settings>(
        future: Provider.of<UserSettings>(context, listen: false).getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              _selectedName = snapshot.data!.themeName;
              _selectedMapType = snapshot.data!.mapType;
              return buildSettingsContent();
            } else {
              return const Center(child: Text('Error loading settings'));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildSettingsContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Application Theme"),
              EnumButton(
                  enumValues: ThemeName.values,
                  value: _selectedName,
                  onChanged: _setTheme)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Default Map Type"),
              EnumButton(
                enumValues: MapType.values,
                value: _selectedMapType,
                onChanged: _setDefaultMapType,
              )
            ],
          ),
        ],
      ),
    );
  }
}
