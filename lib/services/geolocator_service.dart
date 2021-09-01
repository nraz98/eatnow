import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoLocatorService {
  final geolocator = Geolocator();
  GoogleMapController mapController;

  Future<Position> getLocation() async {
    return await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.location);
  }

  Future<double> getDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    double distance = await geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    double distance2 = distance / 1000;
    String myDistance = distance2.toStringAsFixed(1);
    double finalDistance = double.parse(myDistance);
    return finalDistance;
  }
}
