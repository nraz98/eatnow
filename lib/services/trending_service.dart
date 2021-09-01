import 'package:EatNow/model/trend.dart';
import 'package:EatNow/model/venue_search.dart';
import 'package:EatNow/services/geolocator_service.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Trending {
  Future<List<TrendingModel>> getTrendingPlaces() async {
    final geoService = GeoLocatorService();
    final center = await geoService.getLocation();
    final lat = center.latitude.toString();
    final lng = center.longitude.toString();
    final String cat = '4d4b7105d754a06374d81259';

    var response = await http.get(
        'https://api.foursquare.com/v2/venues/explore?client_id=D2RR3T3YXZIZCBUABPHZ1HF5EASPODCNO4RFWPLFTGTX1ZMY&client_secret=RGA04SE1LRXFQVABDAA0BA4UAN2PHSZ0DCM1S4XIHKZQDK0L&v=20191128&ll=$lat,$lng&limit=10&categoryId=$cat');

    var json = convert.jsonDecode(response.body);

    var jsonResults = json['response']['groups'] as List;

    return jsonResults
        .map((trending) => TrendingModel.fromJson(trending))
        .toList();
  }

  Future<List<VenueSearch>> getListCategory(String name) async {
    final geoService = GeoLocatorService();
    final center = await geoService.getLocation();
    final lat = center.latitude.toString();
    final lng = center.longitude.toString();

    final String clientId = 'D2RR3T3YXZIZCBUABPHZ1HF5EASPODCNO4RFWPLFTGTX1ZMY';
    final String secretId = 'RGA04SE1LRXFQVABDAA0BA4UAN2PHSZ0DCM1S4XIHKZQDK0L';

    var response = await http.get(
        'https://api.foursquare.com/v2/venues/search?client_id=$clientId&radius=10000&client_secret=$secretId&v=20191128&ll=$lat,$lng&categoryId=$name&limit=4');

    var json = convert.jsonDecode(response.body);

    var jsonResults = json['response']['venues'] as List;

    if (jsonResults == null) {
      return [];
    } else {
      return jsonResults
          .map((trending) => VenueSearch.fromJson(trending))
          .toList();
    }
  }
}
