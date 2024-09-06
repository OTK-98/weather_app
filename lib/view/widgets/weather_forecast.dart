import 'package:flutter/material.dart';
import 'package:weather_app/models/forecast_model.dart';

class WeatherForecast extends StatelessWidget {
  final List<ForecastModel> forecast;

  const WeatherForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    // Group forecasts by date
    Map<String, List<ForecastModel>> groupedForecasts = {};

    for (var item in forecast) {
      String date = item.time
          .toIso8601String()
          .substring(0, 10); // Format date as yyyy-MM-dd
      if (!groupedForecasts.containsKey(date)) {
        groupedForecasts[date] = [];
      }
      groupedForecasts[date]!.add(item);
    }

    return Column(
      children: groupedForecasts.entries.map((entry) {
        String day = formatDay(DateTime.parse(entry.key));
        String date = formatDate(DateTime.parse(entry.key));

        double minTemp =
            entry.value.map((e) => e.tempNight).reduce((a, b) => a < b ? a : b);
        double maxTemp =
            entry.value.map((e) => e.tempDay).reduce((a, b) => a > b ? a : b);

        return DayForecast(
          day: day,
          date: date,
          weatherSummary:
              entry.value.isNotEmpty ? entry.value[0].weatherDescription : '',
          minTemp: minTemp,
          maxTemp: maxTemp,
          hourlyForecast: entry.value,
        );
      }).toList(),
    );
  }

  String formatDay(DateTime dateTime) {
    return [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ][dateTime.weekday % 7];
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day} ${[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][dateTime.month - 1]}';
  }
}

class DayForecast extends StatelessWidget {
  final String day;
  final String date;
  final String weatherSummary;
  final double minTemp;
  final double maxTemp;
  final List<ForecastModel> hourlyForecast;

  const DayForecast({
    super.key,
    required this.day,
    required this.date,
    required this.weatherSummary,
    required this.minTemp,
    required this.maxTemp,
    required this.hourlyForecast,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$day, $date',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny), // Placeholder icon
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
                    .map((hour) => HourlyForecast(hour: hour))
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
        Text('${hour.time.hour}:00'), // Example time format
        Image.network(
          'http://openweathermap.org/img/wn/${hour.icon}@2x.png',
          height: 50,
        ),
        Text('${hour.tempDay.round()}°C'),
      ],
    );
  }
}
