import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/config/constants.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> getWeather({required String cityName}) async {
    final response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}weather?q=$cityName&appid=${ApiConfig.apiKey}&units=metric'));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['message'] ?? 'Failed to load weather';
      throw Exception('Error: $errorMessage');
    }
  }

  Future<List<ForecastModel>> getForecast({required String cityName}) async {
    final response = await http.get(Uri.parse(
        '${ApiConfig.forecastUrl}?q=$cityName&appid=${ApiConfig.apiKey}&units=metric'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      return forecastList.map((json) => ForecastModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
