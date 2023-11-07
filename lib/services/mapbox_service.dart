import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapboxService {
  static final String _accessToken = dotenv.env['MAPBOX_API_KEY'] ?? "";

  Future<String> getLocalityForCoordinates(LatLng coordinates) async {
    var response = await _getApiResponse(coordinates);
    var locality = _parseApiResponse(response);

    return locality;
  }

  Future<String> _getApiResponse(LatLng coordinates) async {
    if (_accessToken == "") {
      throw Exception('MAPBOX_API_KEY is unset');
    }

    var client = http.Client();
    var domain = "api.mapbox.com";
    var path =
        "geocoding/v5/mapbox.places/${coordinates.longitude},${coordinates.latitude}.json";
    var queryParams = {'access_token': _accessToken};

    var url = Uri.https(domain, path, queryParams);

    try {
      var response = await client.get(url);

      return response.body;
    } finally {
      client.close();
    }
  }

  String _parseApiResponse(String response) {
    Map<String, dynamic> json = jsonDecode(response);

    var features = List<Map<String, dynamic>>.from(
        json["features"].map((e) => Map<String, dynamic>.from(e)));

    var localityFeature = features.firstWhere((element) {
      List<String> placeType = List<String>.from(element["place_type"]);

      return placeType.contains("locality");
    });

    return localityFeature["text"];
  }
}
