import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/config/constants.dart';

class GeoService {
  Future<Map<String, double>> getCityCoordinates(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=${ApiConfig.apiKey}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final cityData = data[0];
        return {
          'lat': cityData['lat'],
          'lon': cityData['lon'],
        };
      } else {
        throw Exception('City not found');
      }
    } else {
      throw Exception('Failed to load city coordinates');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    return city ?? '';
  }

  Future<List<String>> getCitySuggestions(String query) async {
    final String url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=${ApiConfig.apiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map<String>((location) {
        final city = location['name'];
        final country = location['country'];
        return '$city, $country';
      }).toList();
    } else {
      throw Exception('Failed to fetch city suggestions');
    }
  }
}
