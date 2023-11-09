import 'dart:convert';

import 'package:chartr/models/current_weather_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OpenWeatherMapDataProvider {
  static final String _accessToken = dotenv.env['OWM_API_KEY'] ?? "";
  final String apiDomain = "api.openweathermap.org";
  final String apiPath = "data/2.5/weather";

  Future<CurrentWeatherData> getData(LatLng location) async {
    var response = await _getApiResponse(location);
    var result = _parseApiReponse(response);

    return result;
  }

  Future<String> _getApiResponse(LatLng location) async {
    var client = http.Client();
    var queryParams = {
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString(),
      'units': 'metric',
      'appid': _accessToken
    };
    var url = Uri.https(apiDomain, apiPath, queryParams);

    try {
      var response = await client.get(url);

      return response.body;
    } finally {
      client.close();
    }
  }

  CurrentWeatherData _parseApiReponse(String response) {
    var json = jsonDecode(response);

    var lat = json["coord"]["lat"];
    var lng = json["coord"]["lon"];
    var coordinates = LatLng(lat, lng);

    var tempCurrent = json["main"]["temp"];
    var tempFeelsLike = json["main"]["feels_like"];
    var tempMin = json["main"]["temp_min"];
    var tempMax = json["main"]["temp_max"];
    var pressure = json["main"]["pressure"];
    var humidity = json["main"]["humidity"];
    var visibility = json["visibility"];
    var windSpeed = json["wind"]["speed"];
    var windDir = json["wind"]["deg"];

    var sunriseTimestamp = json["sys"]["sunrise"];
    var sunrise = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);

    var sunsetTimestamp = json["sys"]["sunset"];
    var sunset = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    var temp = TemperatureData(
        current: tempCurrent,
        min: tempMin,
        max: tempMax,
        feelsLike: tempFeelsLike);

    return CurrentWeatherData(
        coordinates: coordinates,
        sunrise: sunrise,
        sunset: sunset,
        temperature: temp,
        pressure: pressure,
        humidity: humidity,
        windSpeed: windSpeed,
        windDirection: windDir,
        visibility: visibility);
  }
}
