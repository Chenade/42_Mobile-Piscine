import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CurrentlyTab extends StatefulWidget {
  final String location;
  final String temperature;
  final String weatherCode;
  final IconData weatherIcon;
  final String windSpeed;
  final double latitude;
  final double longitude;

  CurrentlyTab({
    this.location = "Location",
    this.temperature = "Temperature",
    this.weatherCode = "",
    this.weatherIcon = Icons.question_mark,
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
  late IconData weatherIcon;
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
    weatherIcon = widget.weatherIcon;
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
        weatherIcon = apiService.getWeatherIcon(currentWeather['current']['weather_code'].toString());
        windSpeed = currentWeather['current']['wind_speed_10m'].toString();
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          '  $location',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    // add a horizontal line
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                    
                    Text(
                      '$temperature °C',
                      style: const TextStyle(color: Colors.orange, fontSize: 45),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                    Icon(
                      weatherIcon,
                      color: Colors.white,
                      size: 50,
                    ),
                    Text(
                      '$weatherCode',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.lightBlue,
                          size: 20,
                        ),
                        Text(
                          '  $windSpeed m/s',
                          style: const TextStyle(color: Colors.lightBlue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
