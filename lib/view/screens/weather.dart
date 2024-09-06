import 'package:flutter/material.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/geo_services.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/view/widgets/sunset_sunrise.dart';
import 'package:weather_app/view/widgets/weather_additional_details.dart';
import 'package:weather_app/view/widgets/weather_forecast.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  final weatherServices = WeatherService();
  final geoServices = GeoService();

  WeatherModel? weatherModel;
  List<ForecastModel> forecast = [];
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController _cityController = TextEditingController();
  List<String> _citySuggestions = [];
  bool _showSearchField = false;

  Future<void> fetchWeatherAndForecast({String? cityName}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      if (cityName == null || cityName.isEmpty) {
        cityName = await geoServices.getCurrentCity();
      }

      print('Fetching weather for city: $cityName');

      weatherModel = await weatherServices.getWeather(cityName: cityName);
      forecast = await weatherServices.getForecast(cityName: cityName);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch weather and forecast data: $e';
      });
      print('Error fetching weather data: $e');
    }
  }

  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _citySuggestions = [];
      });
      return;
    }
    try {
      final suggestions = await geoServices.getCitySuggestions(query);
      setState(() {
        _citySuggestions = suggestions;
      });
    } catch (e) {
      print('Failed to fetch city suggestions: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherAndForecast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11103A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showSearchField
                          ? Autocomplete<String>(
                              key: const ValueKey('searchField'),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) async {
                                await fetchCitySuggestions(
                                    textEditingValue.text);
                                return _citySuggestions;
                              },
                              onSelected: (String selection) {
                                _cityController.text = selection;
                                fetchWeatherAndForecast(cityName: selection);
                                setState(() {
                                  _showSearchField = false;
                                });
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController
                                      fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                return SizedBox(
                                  height: 56.0,
                                  child: TextField(
                                    key: const ValueKey('textField'),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter City Name',
                                      border: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFF11103A),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (value) {
                                      fetchCitySuggestions(value);
                                    },
                                  ),
                                );
                              },
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected<String> onSelected,
                                  Iterable<String> options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4,
                                    borderRadius: BorderRadius.circular(4),
                                    color:
                                        const Color.fromARGB(255, 80, 80, 110),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 290.0,
                                        maxHeight: 56.0 * 4,
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final option =
                                              options.elementAt(index);
                                          return InkWell(
                                            onTap: () => onSelected(option),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(option,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text(
                              'Weather Forecast',
                              key: ValueKey('weatherForecastText'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _showSearchField ? Icons.close : Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSearchField = !_showSearchField;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : errorMessage.isNotEmpty
                            ? Center(child: Text(errorMessage))
                            : Container(
                                margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40),
                                height:
                                    MediaQuery.of(context).size.height * 0.41,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFF1b1c48),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Today',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22),
                                        ),
                                        Text(
                                          formatCurrentDate(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${weatherModel?.temperature.round()}°',
                                              style: const TextStyle(
                                                fontSize: 72,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              weatherModel?.mainCondition ?? '',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        weatherModel != null
                                            ? Image.network(
                                                'http://openweathermap.org/img/wn/${weatherModel!.icon}@2x.png',
                                                height: 150,
                                                fit: BoxFit.fill,
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                    const SizedBox(height: 36),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.yellowAccent,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          weatherModel != null
                                              ? '${weatherModel!.cityName}, ${weatherModel!.country}' // Display city and country/state
                                              : 'Loading...',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.refresh,
                                              size: 25),
                                          onPressed: () {
                                            fetchWeatherAndForecast(
                                                cityName: _cityController.text);
                                          },
                                          tooltip: 'Refresh',
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Last updated: ${formatDateTime(lastRefreshTime)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                    if (weatherModel != null) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 16),
                        child: Text(
                          'Additional Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      WeatherAdditionalDetails(weatherModel: weatherModel!),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 16),
                        child: Text(
                          'Sunrise & Sunset',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SunsetSunrise(weatherModel: weatherModel!),
                    ],
                    if (forecast.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 16),
                        child: Text(
                          'Weather Forecast for next 5 days',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      WeatherForecast(forecast: forecast),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  DateTime get lastRefreshTime => DateTime.now();
}
