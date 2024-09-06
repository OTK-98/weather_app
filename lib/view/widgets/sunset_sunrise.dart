import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

class SunsetSunrise extends StatelessWidget {
  final WeatherModel weatherModel;

  const SunsetSunrise({required this.weatherModel, super.key});

  String formatTime(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: const Color(0xFF1b1c48),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wb_sunny, size: 40, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    formatTime(weatherModel.sunrise),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.nightlight_round,
                      size: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    formatTime(weatherModel.sunset),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
