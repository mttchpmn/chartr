import 'dart:convert';
import 'dart:io';

import 'package:chartr/models/Track.dart';
import 'package:path_provider/path_provider.dart';

class TracksRepository {
  Future<List<Track>> loadTracks() async {
    List<Track> result = [];
    var track = Track(name: 'Test Track', trackPoints: []);

    result.add(track);
    return result;

    final dir = await getApplicationDocumentsDirectory();
    final List<Track> tracks = [];

    var files = await dir.list().where((file) {
      return file.path.endsWith('.json') &&
          file.path.startsWith('${dir.path}/Track-');
    }).toList();

    for (var file in files) {
      if (file is File) {
        var content = await file.readAsString();
        var jsonData = jsonDecode(content);
        tracks.add(Track.fromJson(jsonData));
      }
    }

    return tracks;
  }
}
