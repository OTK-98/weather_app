import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weathero/config/colors.dart';
import 'package:weathero/controller/weather_controller.dart';
import 'package:weathero/view/widgets/sunset_sunrise.dart';
import 'package:weathero/view/widgets/weather_additional_details.dart';
import 'package:weathero/view/widgets/weather_forecast.dart';
import 'package:weathero/view/screens/search_screen.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});
  final WeatherController weatherController = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CustomColors.fsBackground,
        appBar: AppBar(
          backgroundColor: CustomColors.appBarBackground,
          title: const AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Text(
              'Weathero',
              key: ValueKey('weatherForecastText'),
              style: TextStyle(
                color: CustomColors.appBartitle,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: CustomColors.appBarIcon,
                  size: 30,
                ),
                onPressed: () async {
                  if (weatherController.showSearchField.value) {
                    weatherController.showSearchField.value = false;
                    Get.back();
                  } else {
                    weatherController.showSearchField.value = true;
                    final result = await Get.to(() => SearchScreen());
                    if (result != null && result is bool) {
                      if (result) {
                        weatherController.cityController.value.clear();
                      }
                    }
                  }
                },
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Current"),
              Tab(text: "Forecast"),
            ],
            indicatorColor: CustomColors.tabBarIndicator,
            labelColor: CustomColors.tabBarLabel,
            unselectedLabelColor: CustomColors.tabBarUnselectedLabel,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 14),
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            if (weatherController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                    color: CustomColors.loadingIndicator),
              );
            } else if (weatherController.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: CustomColors.errorIcon,
                        size: 40,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        weatherController.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CustomColors.errorText,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          weatherController.fetchWeatherAndForecast();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.whiteColor,
                        ),
                        child: const Text('Retry',
                            style: TextStyle(
                                fontSize: 16, color: CustomColors.blackColor)),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = constraints.maxWidth;
                  final double screenHeight = constraints.maxHeight;
                  final double dynamicMargin =
                      screenWidth * 0.05; // 4% of screen width
                  final double dynamicPadding =
                      screenWidth * 0.05; // 5% of screen width
                  final double dynamicSizedBoxHeight =
                      screenHeight * 0.02; // 2% of screen height
                  final double dynamicImageHeight =
                      screenHeight * 0.15; // 15% of screen height
                  final double dynamicFontSizeTitle =
                      screenHeight * 0.03; // 3% of screen height
                  final double dynamicFontSizeSubtitle =
                      screenHeight * 0.02; // 2% of screen height
                  final double dynamicFontSizeBody =
                      screenHeight * 0.018; // 1.8% of screen height

                  return TabBarView(
                    children: [
                      // Tab 1: Current Weather
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: dynamicSizedBoxHeight),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: dynamicMargin,
                                  vertical: dynamicMargin),
                              padding: EdgeInsets.symmetric(
                                  vertical: dynamicPadding,
                                  horizontal: dynamicPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: CustomColors.fsCard,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Today',
                                        style: TextStyle(
                                            color: CustomColors.weatherText,
                                            fontSize:
                                                dynamicFontSizeTitle * 1.2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        weatherController.formatCurrentDate(),
                                        style: TextStyle(
                                            color: CustomColors.weatherText,
                                            fontSize:
                                                dynamicFontSizeSubtitle * 1.2),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: dynamicSizedBoxHeight),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '${weatherController.weatherModel.value?.temperature.round() ?? 0}°C',
                                              style: TextStyle(
                                                fontSize:
                                                    dynamicFontSizeTitle * 3,
                                                fontWeight: FontWeight.bold,
                                                color: CustomColors.weatherText,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            weatherController.weatherModel.value
                                                    ?.mainCondition ??
                                                '',
                                            style: TextStyle(
                                              fontSize:
                                                  dynamicFontSizeSubtitle * 1.5,
                                              fontStyle: FontStyle.italic,
                                              color: CustomColors.weatherText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      weatherController.weatherModel.value !=
                                              null
                                          ? Container(
                                              constraints: BoxConstraints(
                                                maxHeight: dynamicImageHeight,
                                              ),
                                              child: Image.asset(
                                                'assets/icons/${weatherController.weatherModel.value?.getIconPath() ?? 'default.png'}',
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                  SizedBox(height: dynamicSizedBoxHeight * 2.6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: CustomColors.locationIcon,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        weatherController.weatherModel.value !=
                                                null
                                            ? '${weatherController.weatherModel.value!.cityName}, ${weatherController.weatherModel.value!.country}'
                                            : 'Loading...',
                                        style: TextStyle(
                                          fontSize: dynamicFontSizeSubtitle,
                                          color: CustomColors.weatherText,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon:
                                            const Icon(Icons.refresh, size: 25),
                                        onPressed: () {
                                          final cityName = weatherController
                                              .cityController.value.text;
                                          if (cityName.isNotEmpty) {
                                            weatherController
                                                .selectedCity.value = cityName;
                                            weatherController
                                                .fetchWeatherAndForecast(
                                                    cityName: cityName);
                                          } else {
                                            weatherController
                                                .fetchWeatherAndForecast();
                                          }
                                        },
                                        tooltip: 'Refresh',
                                        color: CustomColors.refreshIcon,
                                      ),
                                      Text(
                                        'Last updated: ${weatherController.formatDateTime(weatherController.weatherModel.value?.lastRefreshTime ?? DateTime.now())}',
                                        style: TextStyle(
                                          fontSize: dynamicFontSizeBody,
                                          color: CustomColors.weatherText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: dynamicSizedBoxHeight * 1.5),
                            WeatherAdditionalDetails(
                                weatherModel:
                                    weatherController.weatherModel.value!),
                            SizedBox(height: dynamicSizedBoxHeight * 1.5),
                            SunsetSunrise(
                                weatherModel:
                                    weatherController.weatherModel.value!),
                          ],
                        ),
                      ),
                      // Tab 2: Forecast
                      Padding(
                        padding: EdgeInsets.only(top: dynamicMargin),
                        child: SingleChildScrollView(
                          child: WeatherForecast(
                              forecast: weatherController.forecast),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
