import 'package:EatNow/services/geolocator_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class WeatherService {
  String currentWeather = '';

  Future<String> getWeather() async {
    final geoService = GeoLocatorService();
    final center = await geoService.getLocation();
    final lat = center.latitude.toString();
    final lng = center.longitude.toString();
    final appId = "f055993d0581539f5cf077296555feb4";

    var waetherResult = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=$appId');
    var result = convert.jsonDecode(waetherResult.body);
    var consolidated = result["weather"];
    var data = consolidated[0];

    currentWeather = data["main"];
    return currentWeather;
  }
}
