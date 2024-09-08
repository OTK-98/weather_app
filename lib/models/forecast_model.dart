class ForecastModel {
  final DateTime time;
  final String day;
  final double tempDay;
  final double tempNight;
  final String weatherDescription;
  final String icon;

  ForecastModel({
    required this.time,
    required this.day,
    required this.tempDay,
    required this.tempNight,
    required this.weatherDescription,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final dayOfWeek =
        ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
    return ForecastModel(
      time: date,
      day: dayOfWeek,
      tempDay: json['main']['temp'].toDouble(),
      tempNight: json['main']['temp_min'].toDouble(),
      weatherDescription: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
