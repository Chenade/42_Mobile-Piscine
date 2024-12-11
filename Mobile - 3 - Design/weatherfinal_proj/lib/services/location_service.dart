import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getCityName(double latitude, double longitude) async {
    try {
      if (latitude == 0.0 || longitude == 0.0) {
        return Future.error('Invalid latitude or longitude');
      }
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude,
          longitude,
        );
        if (placemarks.isEmpty) {
          return Future.error('No placemarks found for the provided coordinates');
        }
        print(placemarks[0]);
        return placemarks[0].locality ?? 'Unknown';
    } catch (e) {
      return Future.error('Error occurred while fetching city name: $e');
    }
  }

}