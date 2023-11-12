import 'package:chartr/components/menu_drawer.dart';
import 'package:chartr/gateways/user_settings_gateway.dart';
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

  void _changeTheme(ThemeName? name) {
    if (name == null) return;

    setState(() {
      _selectedName = name;
    });

    Provider.of<UserSettings>(context, listen: false).setTheme(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      drawer: MenuDrawer(),
      body: FutureBuilder<Settings>(
        future: Provider.of<UserSettings>(context, listen: false).getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              _selectedName = snapshot.data!.themeName;
              return buildSettingsContent();
            } else {
              return Center(child: Text('Error loading settings'));
            }
          }
          return Center(child: CircularProgressIndicator());
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
              Text("Application Theme"),
              DropdownButton<ThemeName>(
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  value: _selectedName,
                  items: ThemeName.values
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toString().split(".").last,
                          )))
                      .toList(),
                  onChanged: (item) {
                    _changeTheme(item);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
