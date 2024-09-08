class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final String mainCondition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final int sunrise;
  final int sunset;
  final int timezoneOffset;
  final DateTime lastRefreshTime;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.mainCondition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
    required this.timezoneOffset,
    required this.lastRefreshTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      timezoneOffset: json['timezone'],
      lastRefreshTime: DateTime.now(),
    );
  }

  DateTime getLocalTime() {
    Duration offset = Duration(seconds: timezoneOffset);
    return DateTime.now().toUtc().add(offset);
  }

  String getIconPath() {
    DateTime localTime = getLocalTime();
    bool isDayTime = localTime.hour >= 6 && localTime.hour < 18;

    if (mainCondition == 'Clear') {
      return isDayTime
          ? 'icone-de-soleil-jaune.png'
          : 'eclipse-forecast-moon-night-space-icon.png';
    } else if (mainCondition == 'Clouds') {
      if (icon.contains('rain')) {
        return isDayTime
            ? 'cloud-day-forecast-rain-rainy-icon.png'
            : 'cloud-cloudy-forecast-rain-sun-icon.png';
      } else if (icon.contains('snow')) {
        return isDayTime
            ? 'loud-day-forecast-precipitation-snow-icon.png'
            : 'cloud-moon-night-precipitation-snow-icon.png';
      } else if (icon.contains('thunderstorm')) {
        return isDayTime
            ? 'cloud-day-light-bolt-rain-sun-icon.png'
            : 'bolt-light-moon-night-rain-icon.png';
      } else {
        return isDayTime
            ? 'cloud-cloudy-day-forecast-sun-icon.png'
            : 'cloud-clouds-cloudy-forecast-weather-icon.png';
      }
    } else if (mainCondition == 'Rain') {
      return isDayTime
          ? 'cloud-day-forecast-rain-rainy-icon.png'
          : 'cloud-cloudy-forecast-rain-sun-icon.png';
    } else if (mainCondition == 'Snow') {
      return isDayTime
          ? 'loud-day-forecast-precipitation-snow-icon.png'
          : 'cloud-moon-night-precipitation-snow-icon.png';
    } else if (mainCondition == 'Thunderstorm') {
      return isDayTime
          ? 'loud-day-forecast-precipitation-snow-icon.png'
          : 'cloud-moon-night-precipitation-snow-icon.png';
    } else {
      return isDayTime
          ? 'icone-de-soleil-jaune.png'
          : 'eclipse-forecast-moon-night-space-icon.png';
    }
  }
}
