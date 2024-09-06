class WeatherModel {
  final String cityName;
  final String country; // New field for country or state
  final double temperature;
  final String mainCondition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final int sunrise;
  final int sunset;

  WeatherModel({
    required this.cityName,
    required this.country, // Initialize new field
    required this.temperature,
    required this.mainCondition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      country: json['sys']
          ['country'], // Retrieve the country or state from JSON
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
