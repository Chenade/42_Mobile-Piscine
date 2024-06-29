import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/api_service.dart';

class WeeklyTab extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> hourlyWeather;

  WeeklyTab({
    required this.location,
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
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    location = widget.location;
    latitude = widget.latitude;
    longitude = widget.longitude;
    hourlyWeather = Map<String, dynamic>.from(widget.hourlyWeather); // Make a mutable copy
    if (latitude != 0.0 && longitude != 0.0) {
      getWeeklyWeather();
    }
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
              weatherData['weather_code'][i].toString()),
          'weather_icon': apiService.getWeatherIcon(
              weatherData['weather_code'][i].toString()),
        };
      }
    });
  }

  List<_ChartData> _generateMinChartData() {
    List<_ChartData> chartDataMin = [];
    
    for (var time in hourlyWeather.keys) {
      chartDataMin.add(_ChartData(
        time,
        hourlyWeather[time]['temperature_min'].toDouble(),
      ));
    }
    
    return chartDataMin;
  }

  List<_ChartData> _generateMaxChartData() {
    List<_ChartData> chartDataMax = [];
    
    for (var time in hourlyWeather.keys) {
      chartDataMax.add(_ChartData(
        time,
        hourlyWeather[time]['temperature_max'].toDouble(),
      ));
    }
    
    return chartDataMax;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1.0),
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
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelPlacement: LabelPlacement.onTicks, // Position labels at ticks
                    edgeLabelPlacement: EdgeLabelPlacement.shift, // Shift labels to fit within the chart
                  ),
                  title: ChartTitle(text: 'Weekly Temperature'),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom, // Position legends at the bottom
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_ChartData, String>>[
                    LineSeries<_ChartData, String>(
                      name: 'Min Temperature',
                      dataSource: _generateMinChartData(),
                      xValueMapper: (_ChartData data, _) => data.time,
                      yValueMapper: (_ChartData data, _) =>
                          data.temperature,
                      dataLabelSettings:
                          DataLabelSettings(isVisible: true),
                    ),
                    LineSeries<_ChartData, String>(
                      name: 'Max Temperature',
                      dataSource: _generateMaxChartData(),
                      xValueMapper: (_ChartData data, _) => data.time,
                      yValueMapper: (_ChartData data, _) =>
                          data.temperature,
                      dataLabelSettings:
                          DataLabelSettings(isVisible: false),
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
                        subtitle: Column(
                          children: [
                            Text(
                              time,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
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
                            Text(
                              'Max: ${hourlyWeather[time]['temperature_max']}°C',
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                            Text(
                              'Min: ${hourlyWeather[time]['temperature_min']}°C',
                              style: const TextStyle(color: Colors.lightBlue, fontSize: 13),
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
