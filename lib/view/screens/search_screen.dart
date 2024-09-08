import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weathero/config/colors.dart';
import 'package:weathero/controller/weather_controller.dart';

class SearchScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.fsBackground,
      appBar: AppBar(
        backgroundColor: CustomColors.appBarBackground,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.appBarIcon),
          onPressed: () {
            weatherController.showSearchField.value = false;
            Get.back(result: false);
          },
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: CustomColors.appBartitle,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: CustomColors.boxShadow, blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: weatherController.cityController.value,
                      decoration: InputDecoration(
                        hintText: 'Enter City Name',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            weatherController.cityController.value.clear();
                            weatherController.fetchCitySuggestions('');
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                color: CustomColors.tfSuffixIcon,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        hintStyle: const TextStyle(
                          color: CustomColors.tfHint,
                        ),
                      ),
                      style: const TextStyle(color: CustomColors.tfColor),
                      onChanged: (value) {
                        weatherController.fetchCitySuggestions(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                final suggestions = weatherController.citySuggestions;
                return ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final option = suggestions[index];
                    return ListTile(
                      title: Text(option,
                          style: const TextStyle(color: CustomColors.ltTitle)),
                      onTap: () {
                        weatherController.cityController.value.text = option;
                        weatherController.selectedCity.value = option;
                        weatherController.fetchWeatherAndForecast(
                            cityName: option);
                        weatherController.showSearchField.value = false;
                        weatherController.citySuggestions.clear();
                        Get.back(result: true);
                      },
                      trailing: const Icon(Icons.chevron_right,
                          color: CustomColors.ltTrailing),
                      tileColor: CustomColors.ltTile,
                      textColor: CustomColors.ltText,
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
