import 'package:chartr/data_providers/data_provider.dart';
import 'package:chartr/data_providers/weather_point_data_provider.dart';
import 'package:chartr/models/weather_point_data.dart';

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
}
