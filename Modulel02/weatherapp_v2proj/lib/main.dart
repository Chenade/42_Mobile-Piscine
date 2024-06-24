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
  final String location;
  final double latitude;
  final double longitude;

  MainPage({this.location = "Location", this.latitude = 0.0, this.longitude = 0.0});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  List<dynamic> _suggestions = [];
  String _location = "Location";
  double _latitude = 0.0;
  double _longitude = 0.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _location = widget.location;
    _latitude = widget.latitude;
    _longitude = widget.longitude;
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
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching suggestions. Please try again.";
      });
      // _showErrorSnackBar("Error fetching suggestions. Please try again.");
    }
  }

  void onCitySelected(Map<String, dynamic> city) {
    setState(() {
      _location = (city['name'] ?? '') + ', ' + (city['admin1'] ?? '') + ', ' + (city['country'] ?? '');
      _latitude = city['latitude'];
      _longitude = city['longitude'];
      _suggestions.clear();
      _errorMessage = null;
    });
  }

  void getCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      // String _city = await _locationrService.getCityName(position.latitude, position.longitude);
      setState(() {
        _location = 'current location: ' + position.latitude.toString() + ', ' + position.longitude.toString();
        _latitude = position.latitude;
        _longitude = position.longitude;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error getting current location. Please check your permissions.";
      });
      // _showErrorSnackBar("Error getting current location. Please check your permissions.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CurrentlyTab(
                  location: _location,
                  latitude: _latitude,
                  longitude: _longitude,
                ),
                TodayTab(
                  location: _location,
                  latitude: _latitude,
                  longitude: _longitude,
                ),
                WeeklyTab(
                  location: _location,
                  latitude: _latitude,
                  longitude: _longitude,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(tabController: _tabController),
    );
  }
}
