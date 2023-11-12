import 'package:chartr/models/current_weather_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentWeatherDisplay extends StatelessWidget {
  final CurrentWeatherData data;

  const CurrentWeatherDisplay({super.key, required this.data});

  String _formatDatetime(DateTime dt) {
    return DateFormat('Hms').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350, // TODO
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DataDisplay(
                      data: _formatDatetime(data.sunrise),
                      units: "",
                      text: "Sunrise",
                    ),
                    DataDisplay(
                      data: _formatDatetime(data.sunset),
                      units: "",
                      text: "Sunset",
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Column(
              children: [
                Text("Temperature"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DataDisplay(
                        data: "${data.temperature.current}",
                        units: "°C",
                        text: "Current"),
                    DataDisplay(
                        data: "${data.temperature.feelsLike}",
                        units: "°C",
                        text: "Feels like"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DataDisplay(
                        data: "${data.temperature.min}",
                        units: "°C",
                        text: "Min"),
                    DataDisplay(
                        data: "${data.temperature.max}",
                        units: "°C",
                        text: "Max"),
                  ],
                )
              ],
            ),
            Divider(),
            Column(
              children: [
                Text("Wind"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DataDisplay(
                        data: "${data.windSpeed}",
                        units: "kmh",
                        text: "Wind Speed"),
                    DataDisplay(
                        data: "${data.windDirection}",
                        units: "°",
                        text: "Wind Direction"),
                  ],
                ),
              ],
            ),
            Divider(),
            Column(
              children: [
                Text("Atmosphere"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DataDisplay(
                        data: "${data.pressure}",
                        units: "hPa",
                        text: "Pressure"),
                    DataDisplay(
                        data: "${data.humidity}", units: "%", text: "Humidity"),
                  ],
                ),
                DataDisplay(
                    data: "${data.visibility / 1000}",
                    units: "km",
                    text: "Visibility"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DataDisplay extends StatelessWidget {
  final String data;
  final String units;
  final String text;

  const DataDisplay(
      {super.key, required this.data, required this.units, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data,
                style: Theme.of(context).textTheme.titleLarge,
                // style: TextStyle(fontSize: 24, inherit: true),
              ),
              SizedBox(
                width: 2,
              ),
              Text(units)
            ],
          ),
          Text(
            text,
            // style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
