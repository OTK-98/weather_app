import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:weathero/models/forecast_model.dart';
import 'package:weathero/models/weather_model.dart';
import 'package:weathero/services/geo_services.dart';
import 'package:weathero/services/weather_services.dart';

class WeatherController extends GetxController {
  final weatherServices = WeatherService();
  final geoServices = GeoService();

  var weatherModel = Rxn<WeatherModel>();
  var forecast = <ForecastModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final cityController = TextEditingController().obs;
  var citySuggestions = <String>[].obs;
  var showSearchField = false.obs;
  var lastRefreshTime = DateTime.now().obs;
  Timer? _debounce;

  // New variable to store selected city
  var selectedCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWeatherAndForecast();
  }

  Future<void> fetchWeatherAndForecast({String? cityName}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      cityName = cityName ?? selectedCity.value;
      if (cityName.isEmpty) {
        cityName = await geoServices.getCurrentCity();
      }

      weatherModel.value = await weatherServices.getWeather(cityName: cityName);
      forecast.value = await weatherServices.getForecast(cityName: cityName);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value =
          'We couldn\'t find the city.\nPlease Check your internet connection!\n \nIf don\'t work,try again later or use the search feature.';
    }
  }

  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      citySuggestions.clear();
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final suggestions = await geoServices.getCitySuggestions(query);
        citySuggestions.value = suggestions;
      } catch (e) {
        print('Failed to fetch city suggestions: $e');
      }
    });
  }

  String formatCurrentDate() {
    final now = DateTime.now();
    final day =
        ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][now.weekday % 7];
    final date = now.day;
    final month = [
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
    ][now.month - 1];
    return '$day, $date $month';
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
