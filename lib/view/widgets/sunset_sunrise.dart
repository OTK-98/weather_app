import 'package:flutter/material.dart';
import 'package:weathero/config/colors.dart';
import 'package:weathero/models/weather_model.dart';

class SunsetSunrise extends StatelessWidget {
  final WeatherModel weatherModel;

  const SunsetSunrise({required this.weatherModel, super.key});

  String formatTime(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final time =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: CustomColors.fsCard,
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
                  Image.asset(
                    'assets/icons/icone-de-soleil-jaune.png',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatTime(weatherModel.sunrise),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: CustomColors.whiteColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/eclipse-forecast-moon-night-space-icon.png',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatTime(weatherModel.sunset),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomColors.whiteColor,
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
