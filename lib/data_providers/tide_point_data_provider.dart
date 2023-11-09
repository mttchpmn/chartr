import 'dart:convert';

import 'package:chartr/models/weather_point_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TidePointDataProvider {
  static final String _accessToken = dotenv.env['NIWA_API_KEY'] ?? "";
  final String apiDomain = "api.niwa.co.nz";
  final String apiPath = "tides/data";

  Future<List<PointData>> getData(WeatherPointDataInput input) async {
    var apiResponse = await _getApiResponse(input);
    var data = _buildData(apiResponse, input);

    return data;
  }

  Future<String> _getApiResponse(WeatherPointDataInput input) async {
    var client = http.Client();
    var queryParams = {
      'lat': input.point.latitude.toString(),
      'long': input.point.longitude.toString(),
      'interval': '15',
      // 'datum': 'MSL',
      'numberOfDays': '1',
      'apikey': _accessToken
    };
    var url = Uri.https(apiDomain, apiPath, queryParams);
    try {
      var response = await client.get(url);

      return response.body;
    } finally {
      client.close();
    }
  }

  List<PointData> _buildData(String apiResponse, WeatherPointDataInput input) {
    Map<String, dynamic> json = jsonDecode(apiResponse);

    var values = List<Map<String, dynamic>>.from(
        json["values"].map((e) => Map<String, dynamic>.from(e)));

    var result = values
        .map((e) => PointData(
            dateTime: DateTime.parse(e["time"]),
            value: e["value"] is double ? e["value"] : e["value"].toDouble(),
            unit: "m"))
        .toList();

    result.removeLast();

    return result;
  }
}
