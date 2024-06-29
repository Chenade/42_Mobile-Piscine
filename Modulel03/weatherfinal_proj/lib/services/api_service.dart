import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String geocodingApiUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<dynamic>> getCitySuggestions(String query) async {
    final response = await http.get(Uri.parse('$geocodingApiUrl?name=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  String getWeatherDescription(String code) {
    switch (code) {
      case '0':
        return('Clear sky');
      case '1':
        return('Mainly clear sky');
      case '2':
        return('Partly cloudy');
      case '3':
        return('Mainly cloudy');
      case '45':
        return('Fog');
      case '48':
        return('Light rain showers');
      case '51':
        return('Light rain showers');
      case '53':
        return('Moderate rain showers');
      case '56':
        return('Heavy rain showers');
      case '60':
        return('Light snow showers');
      case '63':
        return('Moderate snow showers');
      case '66':
        return('Heavy snow showers');
      case '80':
        return('Thunderstorm');
      default:
        return('Unknown weather code');
    }
  }

  IconData getWeatherIcon(String code) {
    // print(code);
    switch (code) {
      case '0':
        return Icons.wb_sunny;
      case '1':
        return Icons.wb_sunny;
      case '2':
        return Icons.wb_cloudy;
      case '3':
        return Icons.wb_cloudy;
      case '45':
        return Icons.cloud;
      case '48':
        return Icons.cloud;
      case '51':
        return Icons.cloud;
      case '53':
        return Icons.cloud;
      case '56':
        return Icons.cloud;
      case '60':
        return Icons.ac_unit;
      case '63':
        return Icons.ac_unit;
      case '66':
        return Icons.ac_unit;
      case '80':
        return Icons.flash_on;
      default:
        return Icons.error;
    }
  }

  static const String weatherApiUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>> getCurrentWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('$weatherApiUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,weather_code,wind_speed_10m'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getTodayWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('$weatherApiUrl?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,weather_code,wind_speed_10m&forecast_days=1'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['hourly'];
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getWeeklyWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('$weatherApiUrl?latitude=$latitude&longitude=$longitude&daily=weather_code,temperature_2m_max,temperature_2m_min'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['daily'];
    } else {
      throw Exception('Failed to load weather data');
    }
  }

}
