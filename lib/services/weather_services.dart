import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weathero/config/constants.dart';
import 'package:weathero/models/forecast_model.dart';
import 'package:weathero/models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> getWeather({required String cityName}) async {
    try {
      final response = await http.get(Uri.parse(
          '${ApiConfig.baseUrl}weather?q=$cityName&appid=${ApiConfig.apiKey}&units=metric&lang=en'));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'We couldn\'t find the city.\nPlease Check your internet connection!\n \nIf don\'t work,try again later or use the search feature.');
      }
    } catch (e) {
      throw Exception(
          'We couldn\'t find the city.\nPlease Check your internet connection!\n \nIf don\'t work,try again later or use the search feature.');
    }
  }

  Future<List<ForecastModel>> getForecast({required String cityName}) async {
    final response = await http.get(Uri.parse(
        '${ApiConfig.forecastUrl}?q=$cityName&appid=${ApiConfig.apiKey}&units=metric&lang=en'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      return forecastList.map((json) => ForecastModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
