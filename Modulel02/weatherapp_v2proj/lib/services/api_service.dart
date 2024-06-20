import 'dart:convert';
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
}
