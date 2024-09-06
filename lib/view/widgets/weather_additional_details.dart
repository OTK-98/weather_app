import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherAdditionalDetails extends StatelessWidget {
  final WeatherModel weatherModel;

  const WeatherAdditionalDetails({super.key, required this.weatherModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF1b1c48),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.thermostat_outlined, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    'Feels Like\n${weatherModel.feelsLike.round()}°',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              color: Colors.white,
              thickness: 1,
              width: 32,
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.water, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    'Humidity\n${weatherModel.humidity}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              color: Colors.white,
              thickness: 1,
              width: 32,
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.air, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    'Wind Speed\n${weatherModel.windSpeed} km/h',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
