import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'services/api_service.dart';
import 'services/location_service.dart';
import 'includes/custom_app_bar.dart';
import 'includes/custom_bottom_navbar.dart';
import 'pages/currently_tab.dart';
import 'pages/today_tab.dart';
import 'pages/weekly_tab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  List<dynamic> _suggestions = [];
  String _location = "Location";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchSuggestions(String query) async {
    try {
      final suggestions = await _apiService.getCitySuggestions(query);
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      print(e);
    }
  }

  void onCitySelected(Map<String, dynamic> city) {
    setState(() {
      _location = city['name'];
      _suggestions.clear();
    });
    // Here you can implement the logic to fetch weather data for the selected city
    // fetchWeather(city['latitude'], city['longitude']);
  }

  void getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _location = '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearchChanged: (value) {
          fetchSuggestions(value);
        },
        onLocationPressed: () {
          getCurrentLocation();
        },
      ),
      body: Column(
        children: [
          if (_suggestions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(suggestion['name']),
                    subtitle: Text('${suggestion['admin1']}, ${suggestion['country']}'),
                    onTap: () => onCitySelected(suggestion),
                  );
                },
              ),
            ),
          // Main Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CurrentlyTab(location: _location),
                TodayTab(location: _location),
                WeeklyTab(location: _location),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(tabController: _tabController),
    );
  }
}
