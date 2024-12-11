import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Ensure this import is included
import '../services/api_service.dart';

class TodayTab extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> hourlyWeather;

  TodayTab({
    required this.location,
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
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    location = widget.location;
    latitude = widget.latitude;
    longitude = widget.longitude;
    hourlyWeather = Map<String, dynamic>.from(widget.hourlyWeather);
    if (latitude != 0.0 && longitude != 0.0) getTodayWeather();
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
        DateTime dateTime = DateTime.parse(weatherData['time'][i]);
        hourlyWeather[DateFormat('kk:mm').format(dateTime)] = {
          'temperature': weatherData['temperature_2m'][i],
          'wind_speed': weatherData['wind_speed_10m'][i],
          'weather_code': apiService.getWeatherDescription(
              weatherData['weather_code'][i].toString()),
          'weather_icon': apiService.getWeatherIcon(
              weatherData['weather_code'][i].toString()),
        };
      }
    });
  }

  List<_ChartData> _generateChartData() {
    List<_ChartData> chartData = [];
    for (var time in hourlyWeather.keys) {
      chartData.add(_ChartData(
        time,
        hourlyWeather[time]['temperature'].toDouble(),
      ));
    }
    return chartData;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20), // Add some spacing at the top
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
              Container(
                height: 400,
                padding: const EdgeInsets.all(16.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries<_ChartData, String>>[
                    LineSeries<_ChartData, String>(
                      name: 'Today\'s weather',
                      color: Colors.yellow,
                      dataSource: _generateChartData(),
                      xValueMapper: (_ChartData data, _) => data.time,
                      yValueMapper: (_ChartData data, _) => data.temperature,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hourlyWeather.length,
                  itemBuilder: (context, index) {
                    var time = hourlyWeather.keys.elementAt(index);
                    return Container(
                      width: 200,
                      child: ListTile(
                        title: const Text(""),
                        subtitle: 
                        Column(
                          children: [
                            Text(
                              time,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                            ),
                            Text(
                              '${hourlyWeather[time]['temperature']}°C',
                              style: const TextStyle(color: Colors.orange, fontSize: 15),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                            ),
                            Icon(
                              hourlyWeather[time]['weather_icon'],
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              '${hourlyWeather[time]['weather_code']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.air,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Text(
                                  '${hourlyWeather[time]['wind_speed']} km/s',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _ChartData {
  _ChartData(this.time, this.temperature);

  final String time;
  final double temperature;
}
