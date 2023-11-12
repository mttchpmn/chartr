import 'package:chartr/components/menu_drawer.dart';
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

  @override
  void initState() {
    super.initState();

    var theme =
        Provider.of<UserSettings>(context, listen: false).settings.themeName;

    setState(() {
      _selectedName = theme;
    });
  }

  void _changeTheme(ThemeName? name) {
    if (name == null) return;

    Provider.of<UserSettings>(context, listen: false).setTheme(name);

    setState(() {
      _selectedName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      drawer: MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Application Theme"),
                DropdownButton<ThemeName>(
                    value: _selectedName,
                    items: ThemeName.values
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toString().split(".").last)))
                        .toList(),
                    onChanged: (item) {
                      _changeTheme(item);
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserSettings extends ChangeNotifier {
  Settings _settings = Settings(themeName: ThemeName.searchAndRescue);

  Settings get settings => _settings;

  void setTheme(ThemeName name) {
    _settings.themeName = name;

    notifyListeners();
  }
}

class Settings {
  ThemeName themeName;

  Settings({required this.themeName});
}
