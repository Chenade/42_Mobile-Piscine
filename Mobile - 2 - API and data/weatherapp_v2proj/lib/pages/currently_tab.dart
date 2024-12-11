import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CurrentlyTab extends StatefulWidget {
  final String location;
  final String temperature;
  final String weatherCode;
  final String windSpeed;
  final double latitude;
  final double longitude;

  CurrentlyTab({
    this.location = "Location",
    this.temperature = "Temperature",
    this.weatherCode = "Weather Code",
    this.windSpeed = "Wind Speed",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  @override
  _CurrentlyTabState createState() => _CurrentlyTabState();
}

class _CurrentlyTabState extends State<CurrentlyTab> {
  late String location;
  late String temperature;
  late String weatherCode;
  late String windSpeed;
  late double latitude;
  late double longitude;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Initialize state variables from widget properties
    location = widget.location;
    temperature = widget.temperature;
    weatherCode = widget.weatherCode;
    windSpeed = widget.windSpeed;
    latitude = widget.latitude;
    longitude = widget.longitude;
    if (latitude != 0.0 && longitude != 0.0)
      getCurrentWeather();
  }

  @override
  void didUpdateWidget(CurrentlyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if latitude or longitude has changed
    if (widget.latitude != latitude || widget.longitude != longitude) {
      latitude = widget.latitude;
      longitude = widget.longitude;
      location = widget.location;
      getCurrentWeather();
    }
  }

  void getCurrentWeather() async {
    try {
      final Map<String, dynamic> currentWeather = await apiService.getCurrentWeather(latitude, longitude);
      setState(() {
        // print(currentWeather['current']);
        temperature = currentWeather['current']['temperature_2m'].toString();
        weatherCode = apiService.getWeatherDescription(currentWeather['current']['weather_code'].toString());
        windSpeed = currentWeather['current']['wind_speed_10m'].toString();
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text("Currently"),
          Text(location),
          Expanded(
            child: ListView(
              children: (temperature == "Temperature" || weatherCode == "Weather Code" || windSpeed == "Wind Speed")
                  ? [const ListTile(title: Text('No weather data available'))]
                  :
                [
                  ListTile(
                    title: Text("Temperature: $temperature °C"),
                  ),
                  ListTile(
                    title: Text("Weather: $weatherCode"),
                  ),
                  ListTile(
                    title: Text("Wind Speed: $windSpeed km/h"),
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }
}
