import 'dart:convert';
import 'dart:io';

import 'package:chartr/models/Track.dart';
import 'package:path_provider/path_provider.dart';

class TracksRepository {
  Future<List<Track>> loadTracks() async {
    final dir = await getApplicationDocumentsDirectory();

    var files = await getFiles(dir);

    var tracks = await _loadTracksFromFiles(files);

    return tracks;
  }

  Future<List<Track>> _loadTracksFromFiles(List<FileSystemEntity> files) async {
    List<Track> result = [];

    for (var file in files) {
      if (file is File) {
        var content = await file.readAsString();
        if (content == "") {
          continue;
        }
        var jsonData = jsonDecode(content);
        result.add(Track.fromJson(jsonData));
      }
    }

    return result;
  }

  Future<List<FileSystemEntity>> getFiles(Directory dir) async {
    return await dir.list().where((file) {
      return file.path.endsWith('.json') &&
          file.path.startsWith('${dir.path}/Track-');
    }).toList();
  }
}
