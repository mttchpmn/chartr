import 'package:latlong2/latlong.dart';

class CurrentWeatherData {
  final LatLng coordinates;

  final DateTime sunrise;
  final DateTime sunset;

  final TemperatureData temperature;

  final int pressure;
  final int humidity;

  final double windSpeed;
  final int windDirection;

  final int visibility;

  CurrentWeatherData(
      {required this.coordinates,
      required this.sunrise,
      required this.sunset,
      required this.temperature,
      required this.pressure,
      required this.humidity,
      required this.windSpeed,
      required this.windDirection,
      required this.visibility});
}

class TemperatureData {
  final double current;
  final double min;
  final double max;
  final double feelsLike;

  TemperatureData(
      {required this.current,
      required this.min,
      required this.max,
      required this.feelsLike});
}
