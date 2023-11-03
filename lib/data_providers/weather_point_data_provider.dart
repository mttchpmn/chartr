import 'dart:convert';

import 'package:chartr/data_providers/data_provider.dart';
import 'package:chartr/models/weather_point_data.dart';
import 'package:http/http.dart' as http;

class WeatherPointDataProvider
    extends DataProvider<WeatherPointData, WeatherPointDataInput> {
  final String apiDomain = "forecast-v2.metoceanapi.com";
  final String apiPath = "point/time";

  @override
  Future<WeatherPointData> getData(WeatherPointDataInput input) async {
    var apiResponse = await _getApiResponse(input);
    var data = _buildData(apiResponse, input);

    return data;
  }

  Future<String> _getApiResponse(WeatherPointDataInput input) async {
    var client = http.Client();
    var url = Uri.https(apiDomain, apiPath);
    try {
      var body = {
        "points": [
          {
            "lat": input.point.latitude,
            "lon": input.point.longitude,
          }
        ],
        "variables": [
          "air.pressure.at-sea-level",
          "air.humidity.at-2m",
          "air.temperature.at-2m",
          "cloud.cover",
          "cloud.base.height",
          "precipitation.rate",
          "wind.direction.at-10m",
          "wind.speed.at-10m",
          "wind.speed.gust.at-10m"
        ],
        "time": {
          "from": input.fromDate,
          "interval": "1h",
          "repeat": input.repeat
        }
      };

      var response = await client.post(url,
          headers: {
            "x-api-key": "9k8QxkjvPm5MLHCJu36STE",
            "content-type": "application/json"
          },
          body: jsonEncode(body));

      return response.body;
    } finally {
      client.close();
    }
  }

  WeatherPointData _buildData(String apiResponse, WeatherPointDataInput input) {
    Map<String, dynamic> json = jsonDecode(apiResponse);

    List<dynamic> timePointsTmp = json["dimensions"]["time"]["data"];
    List<DateTime> timePoints =
        timePointsTmp.map((e) => DateTime.parse(e)).toList();

    var airPressure = _getVariableData("air.pressure.at-sea-level", json);
    var airHumidity = _getVariableData("air.humidity.at-2m", json);
    var airTemperature = _getVariableData("air.temperature.at-2m", json);

    var cloudCover = _getVariableData("air.temperature.at-2m", json);
    var cloudBase = _getVariableData("air.temperature.at-2m", json);
    var precipitationRate = _getVariableData("air.temperature.at-2m", json);

    var windDirection = _getVariableData("air.temperature.at-2m", json);
    var windSpeed = _getVariableData("air.temperature.at-2m", json);
    var windGust = _getVariableData("air.temperature.at-2m", json);

    var airPressureHpa = _zipPointsAndData(timePoints, airPressure, "hPa")
        .map((e) => PointData(
            dateTime: e.dateTime,
            value: e.value != null ? e.value! / 100 : null,
            unit: e.unit))
        .toList();

    var airTempDegC = _zipPointsAndData(timePoints, airTemperature, "deg C")
        .map((e) => PointData(
            dateTime: e.dateTime,
            value: e.value != null ? e.value! - 273.15 : null,
            unit: e.unit))
        .toList();

    var windSpeedKmh = _zipPointsAndData(timePoints, windSpeed, "kmh")
        .map((e) => PointData(
            dateTime: e.dateTime,
            value: e.value != null ? e.value! * 60 * 60 / 1000 : null,
            unit: e.unit))
        .toList();

    var windGustKmh = _zipPointsAndData(timePoints, windGust, "kmh")
        .map((e) => PointData(
            dateTime: e.dateTime,
            value: e.value != null ? e.value! * 60 * 60 / 1000 : null,
            unit: e.unit))
        .toList();

    var result = WeatherPointData(
        point: input.point,
        fromDate: DateTime.parse(input.fromDate),
        interval: input.interval,
        repeat: input.repeat,
        airPressure: airPressureHpa,
        airHumidity: _zipPointsAndData(timePoints, airHumidity, "%"),
        airTemperature: airTempDegC,
        cloudCover: _zipPointsAndData(timePoints, cloudCover, "%"),
        cloudBase: _zipPointsAndData(timePoints, cloudBase, "m"),
        precipitationRate:
            _zipPointsAndData(timePoints, precipitationRate, "mm/hr"),
        windDirection: _zipPointsAndData(timePoints, windDirection, "deg"),
        windSpeed: windSpeedKmh,
        windGust: windGustKmh);

    return result;
  }

  List<double> _getVariableData(
      String variableName, Map<String, dynamic> json) {
    List<dynamic> tmp = json["variables"][variableName]["data"];
    List<double> result = List<double>.from(tmp);

    return result;
  }

  List<PointData> _zipPointsAndData(
      List<DateTime> points, List<double> data, String unit) {
    List<PointData> result = [];

    for (var i = 0; i < points.length - 1; i++) {
      var pointData =
          PointData(dateTime: points[i], value: data[i], unit: unit);

      result.add(pointData);
    }

    return result;
  }
}
