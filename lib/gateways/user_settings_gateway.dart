import 'dart:convert';
import 'dart:io';

import 'package:chartr/models/map_type.dart';
import 'package:chartr/themes/theme_generator.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UserSettings extends ChangeNotifier {
  Future<Settings> getSettings() async {
    var settings = await _loadFromDisk();

    return settings;
  }

  Future<void> setTheme(ThemeName name) async {
    var settings = await _loadFromDisk();
    settings.themeName = name;
    await _saveToDisk(settings);

    notifyListeners();
  }

  Future<void> setDefaultMapType(MapType mapType) async {
    var settings = await _loadFromDisk();
    settings.mapType = mapType;
    await _saveToDisk(settings);

    notifyListeners();
  }

  Future<Settings> _loadFromDisk() async {
    var file = await _getSettingsFile();
    var json = await file.readAsString();

    if (json == "") {
      return Settings(
          themeName: ThemeName.searchAndRescue, mapType: MapType.topographic);
    }

    Map<String, dynamic> data = jsonDecode(json);
    var themeName = data["themeName"];
    var mapType = data["mapType"];

    var themeValue = ThemeName.values.firstWhere(
        (element) => element.toString().split(".").last == themeName);

    var mapTypeValue = MapType.values.firstWhere(
        (element) => element.toString().split(".").last == mapType,
        orElse: () => MapType.topographic);

    var settings = Settings(themeName: themeValue, mapType: mapTypeValue);

    return settings;
  }

  Future<void> _saveToDisk(Settings settings) async {
    var file = await _getSettingsFile();
    var data = _serializeSettings(settings);

    await file.writeAsString(data);
  }

  Future<File> _getSettingsFile() async {
    var folder = await getApplicationDocumentsDirectory();
    var filePath = "${folder.path}/settings.json";

    return File(filePath).create();
  }

  String _serializeSettings(Settings settings) {
    var tmp = {'themeName': settings.themeName.name};

    return jsonEncode(tmp);
  }
}

class Settings {
  ThemeName themeName;
  MapType mapType;

  Settings({required this.themeName, required this.mapType});
}
