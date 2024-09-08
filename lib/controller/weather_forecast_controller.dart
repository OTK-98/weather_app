import 'package:weathero/models/forecast_model.dart';

class WeatherForecastController {
  final List<ForecastModel> forecast;

  WeatherForecastController(this.forecast);

  Map<String, List<ForecastModel>> groupForecastsByDate() {
    return forecast.fold({}, (Map<String, List<ForecastModel>> acc, item) {
      String date = item.time.toIso8601String().substring(0, 10);
      acc.putIfAbsent(date, () => []).add(item);
      return acc;
    });
  }

  double getMinTemperature(List<ForecastModel> forecasts) {
    return forecasts.map((e) => e.tempNight).reduce((a, b) => a < b ? a : b);
  }

  double getMaxTemperature(List<ForecastModel> forecasts) {
    return forecasts.map((e) => e.tempDay).reduce((a, b) => a > b ? a : b);
  }

  String formatDate(DateTime dateTime) {
    return '${[
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
    ][dateTime.month - 1]}, ${dateTime.day} ${[
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ][dateTime.weekday % 7]}';
  }
}
