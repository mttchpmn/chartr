import 'package:chartr/data_providers/data_provider.dart';
import 'package:chartr/data_providers/openweathermap_data_provider.dart';
import 'package:chartr/data_providers/tide_point_data_provider.dart';
import 'package:chartr/data_providers/weather_point_data_provider.dart';
import 'package:chartr/models/current_weather_data.dart';
import 'package:chartr/models/weather_point_data.dart';
import 'package:latlong2/latlong.dart';

class WeatherService {
  final DataProvider<WeatherPointData, WeatherPointDataInput>
      _weatherPointDataProvider;

  WeatherService(
      {DataProvider<WeatherPointData, WeatherPointDataInput>?
          weatherPointDataProvider})
      : _weatherPointDataProvider =
            weatherPointDataProvider ?? WeatherPointDataProvider();

  Future<WeatherPointData> getWeatherPointData(
      WeatherPointDataInput input) async {
    var data = await _weatherPointDataProvider.getData(input);

    return data;
  }

  Future<List<PointData>> getTideData(WeatherPointDataInput input) async {
    var tideService = TidePointDataProvider();
    var tides = await tideService.getData(input);

    return tides;
  }

  Future<CurrentWeatherData> getCurrentWeatherData(LatLng input) async {
    var owmProvider = OpenWeatherMapDataProvider();

    var result = await owmProvider.getData(input);

    return result;
  }
}
