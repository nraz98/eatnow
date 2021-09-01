import 'package:EatNow/model/place.dart';
import 'package:EatNow/services/ruleBased_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyC7kc7T93DYQ8ZmV9aJaVu-mNs1HCOx6rk';
  Future<List<ListPlaces>> getListPlaces(double lat, double lng) async {
    var response = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=restaurant&rankby=distance&key=$key');
    var json = convert.jsonDecode(response.body);

    var jsonResults = json['results'] as List;

    return jsonResults.map((place) => ListPlaces.fromJson(place)).toList();
  }

  Future<List<PlaceMain>> getPlacesNearby(
      double lat, double lng, BitmapDescriptor icon) async {
    var response = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=restaurant&opennow&rankby=distance&key=$key');
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => PlaceMain.fromJson(place, icon)).toList();
  }
}

class PlaceNearbyService {
  final key = 'AIzaSyC7kc7T93DYQ8ZmV9aJaVu-mNs1HCOx6rk';

  Future<List<dynamic>> getTrendSearch(
      double lat, double lng, String name) async {
    var response = await http.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?type=restaurant&type=cafe&type=food&keyword=$name&location=$lat,$lng&rankby=distance&key=$key');
    var json = convert.jsonDecode(response.body);

    var jsonResults = json['results'] as List;

    if (jsonResults == null) {
      return [];
    } else {
      return jsonResults.map((place) => ListPlaces.fromJson(place)).toList();
    }
  }

  Future<List<ListPlaces>> getTrendDetails(double lat, double lng) async {
    List<ListPlaces> finalResult = [];
    List<ListPlaces> resultOne = [];
    final ruleBased = RuleBased();
    final trendRule = await ruleBased.getRuleBased();
    print(trendRule);

    for (int i = 0; i < trendRule.length; i++) {
      final result = await getTrendSearch(lat, lng, trendRule[i]);

      if (result.length > 0) {
        resultOne = [result.first];
        finalResult = finalResult + resultOne;
      } else {
        finalResult = finalResult;
      }
    }

    return finalResult;
  }
}
