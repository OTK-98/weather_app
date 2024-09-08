import 'package:flutter/material.dart';
import 'package:weathero/controller/weather_forecast_controller.dart';
import 'package:weathero/models/forecast_model.dart';

class WeatherForecast extends StatelessWidget {
  final List<ForecastModel> forecast;

  const WeatherForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final controller = WeatherForecastController(forecast);
    Map<String, List<ForecastModel>> groupedForecasts =
        controller.groupForecastsByDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text header
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Text(
            'Weekly Weather Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Forecast list
        ...groupedForecasts.entries.map((entry) {
          String formattedDate =
              controller.formatDate(DateTime.parse(entry.key));
          double minTemp = controller.getMinTemperature(entry.value);
          double maxTemp = controller.getMaxTemperature(entry.value);

          return DayForecast(
            date: formattedDate,
            weatherSummary:
                entry.value.isNotEmpty ? entry.value[0].weatherDescription : '',
            minTemp: minTemp,
            maxTemp: maxTemp,
            hourlyForecast: entry.value,
          );
        }),
      ],
    );
  }
}

class DayForecast extends StatelessWidget {
  final String date;
  final String weatherSummary;
  final double minTemp;
  final double maxTemp;
  final List<ForecastModel> hourlyForecast;

  const DayForecast({
    super.key,
    required this.date,
    required this.weatherSummary,
    required this.minTemp,
    required this.maxTemp,
    required this.hourlyForecast,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny),
                    const SizedBox(width: 8),
                    Text(weatherSummary),
                  ],
                ),
                Text('Min: ${minTemp.round()}°C  Max: ${maxTemp.round()}°C'),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: hourlyForecast
                    .map((hour) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: HourlyForecast(hour: hour),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  final ForecastModel hour;

  const HourlyForecast({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${hour.time.hour}:00'),
        Image.network(
          'http://openweathermap.org/img/wn/${hour.icon}@2x.png',
          height: 50,
        ),
        Text('${hour.tempDay.round()}°C'),
      ],
    );
  }
}
