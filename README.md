# Weather App 🌦️

A beautifully designed weather application built with Flutter. This app provides real-time weather information, forecasts, and city search functionality using the OpenWeatherMap API.

## Features ✨

- **Real-time Weather Data**: Get current weather conditions like temperature, humidity, wind speed, and more.
- **Hourly and Daily Forecasts**: View weather forecasts for the upcoming hours and days.
- **City Search**: Search for weather data by city, allowing you to check the weather in any location.
- **Interactive UI**: Modern and user-friendly interface with animated weather icons.
- **Professional Design**: Customized weather curves, sunrise/sunset times, and detailed forecast displays.

## Screenshots 📱

<p float="left">
  <img src="assets/screenshots/screenshot1.png" alt="Weather Details" width="300"" />
  <img src="assets/screenshots/screenshot2.png" alt="Forecasts Details" width="300" />
</p>

## Installation and Setup 🚀

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/weather-app.git
   ```
   
2. Navigate to the project directory:

   ```bash
   cd weather-app
   ```

3. Install the necessary dependencies:

   ```bash
   flutter pub get
   ```

4. Obtain your API key from OpenWeatherMap and add it to your project:

   - Create a file called `.env` in the root directory.
   - Add the following line:

     ```plaintext
     WEATHER_API_KEY=your_api_key_here
     ```

5. Run the app:

   ```bash
   flutter run
   ```

## Technologies Used 🛠️

- **Flutter**: UI toolkit for building natively compiled applications.
- **GetX**: State management and dependency injection.
- **OpenWeatherMap API**: Provides weather data and forecasts.

## Project Structure 📁

```
lib/
│
├── models/
│   ├── forecast_model.dart
│   └── weather_model.dart
│
├── services/
│   ├── weather_services.dart
│   └── geo_services.dart
└── views/
    ├── weather.dart
    └── search_screen.dart
    
```

## Future Enhancements 🔮

- **More Detailed Forecasts**: Add more detailed forecasts like hourly wind speed, precipitation chances, etc.

## Contributing 🤝

Contributions are welcome! If you have any ideas, suggestions, or issues, feel free to submit a pull request or open an issue.

---

Developed by **Bakhti Khaled** with ❤️ using Flutter.
