import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WeeklyTab extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> hourlyWeather;

  WeeklyTab(
      {required this.location,
      required this.latitude,
      required this.longitude,
      this.hourlyWeather = const {},
    });

  @override
  _WeeklyTabState createState() => _WeeklyTabState();
}

class _WeeklyTabState extends State<WeeklyTab> {
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
      getWeeklyWeather();
  }

  @override
  void didUpdateWidget(WeeklyTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.latitude != latitude || widget.longitude != longitude) {
      latitude = widget.latitude;
      longitude = widget.longitude;
      getWeeklyWeather();
    }
  }

  void getWeeklyWeather() async {
    final Map<String, dynamic> weatherData =
        await apiService.getWeeklyWeather(latitude, longitude);
    setState(() {
      hourlyWeather.clear();
      for (var i = 0; i < weatherData['time'].length; i++) {
        hourlyWeather[weatherData['time'][i].toString()] = {
          'temperature_min': weatherData['temperature_2m_min'][i],
          'temperature_max': weatherData['temperature_2m_max'][i],
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
                              '${hourlyWeather[time]['weather_code']}, Max: ${hourlyWeather[time]['temperature_max']} °C, Min: ${hourlyWeather[time]['temperature_min']} °C'),
                        )
                    ],
              )
          ),
        ],
      ),
    );
  }
}
