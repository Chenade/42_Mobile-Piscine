import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TodayTab extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> hourlyWeather;

  TodayTab(
      {required this.location,
      required this.latitude,
      required this.longitude,
      this.hourlyWeather = const {},
    });

  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  late String location;
  late double latitude;
  late double longitude;
  late Map<String, dynamic> hourlyWeather;
  late String error;
  final ApiService apiService = ApiService();


  @override
  void initState() {
    super.initState();
    location = widget.location;
    latitude = widget.latitude;
    longitude = widget.longitude;
    hourlyWeather = Map<String, dynamic>.from(widget.hourlyWeather); // Make a mutable copy
    if (latitude != 0.0 && longitude != 0.0)
      getTodayWeather();
  }

  @override
  void didUpdateWidget(TodayTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.latitude != latitude || widget.longitude != longitude) {
      latitude = widget.latitude;
      longitude = widget.longitude;
      location = widget.location;
      getTodayWeather();
    }
  }

  void getTodayWeather() async {
    final Map<String, dynamic> weatherData =
        await apiService.getTodayWeather(latitude, longitude);
    setState(() {
      hourlyWeather.clear();
      for (var i = 0; i < weatherData['time'].length; i++) {
        hourlyWeather[weatherData['time'][i].toString()] = {
          'temperature': weatherData['temperature_2m'][i],
          'wind_speed': weatherData['wind_speed_10m'][i],
          'weather_code': apiService.getWeatherDescription(
              weatherData['weather_code'][i].toString())
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text("Today"),
          Text(location),
          Expanded(
            child: ListView(
              children: hourlyWeather.isEmpty
                  ? [const ListTile(title: Text('No weather data available'))]
                  : [
                      for (var time in hourlyWeather.keys)
                        ListTile(
                          title: Text(time),
                          subtitle: Text(
                              '${hourlyWeather[time]['weather_code']}, Temperature: ${hourlyWeather[time]['temperature']}°C, Wind speed: ${hourlyWeather[time]['wind_speed']} km/s'),
                        )
                    ],
              )
          ),
        ],
      ),
    );
  }
}
