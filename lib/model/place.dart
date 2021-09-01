import 'package:EatNow/model/geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceMain {
  String name;
  double rating;
  String vicinity;
  Geometry geometry;
  BitmapDescriptor icon;
  List<Photos> photos;
  String businessStatus;
  int priceLevel;
  bool openingHours = false;

  PlaceMain(
      {this.businessStatus,
      this.priceLevel,
      this.geometry,
      this.name,
      this.rating,
      this.vicinity,
      this.photos,
      this.icon,
      this.openingHours});

  PlaceMain.fromJson(Map<String, dynamic> json, BitmapDescriptor icons) {
    businessStatus = json['business_status'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    rating = (json['rating'] != null) ? json['rating'].toDouble() : null;
    name = json['name'];
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    icon = icon;
    if (json['opening_hours'] != null) {
      openingHours = (json['opening_hours']['open_now'] != null)
          ? json['opening_hours']['open_now']
          : null;
    } else
      openingHours = openingHours;

    priceLevel = json['price_level'];
    vicinity = json['vicinity'];
    icon = icons;
  }
}

class Photos {
  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

// class TrendMain {
//   final String name;
//   final double rating;
//   final int userRatingCount;
//   final String vicinity;
//   final Geometry geometry;
//   final BitmapDescriptor icon;

//   TrendMain(
//       {this.geometry,
//       this.name,
//       this.rating,
//       this.userRatingCount,
//       this.vicinity,
//       this.icon});

//   TrendMain.fromJson(Map<dynamic, dynamic> parsedJson, BitmapDescriptor icon)
//       : name = parsedJson['name'],
//         rating = (parsedJson['rating'] != null)
//             ? parsedJson['rating'].toDouble()
//             : null,
//         userRatingCount = (parsedJson['user_ratings_total'] != null)
//             ? parsedJson['user_ratings_total']
//             : null,
//         vicinity = parsedJson['vicinity'],
//         geometry = Geometry.fromJson(parsedJson['geometry']),
//         icon = icon;
// }

class ListPlaces {
  String name;
  double rating;
  String vicinity;
  Geometry geometry;
  List<Photos> photos;
  String businessStatus;
  int priceLevel;
  bool openingHours = false;

  ListPlaces(
      {this.businessStatus,
      this.priceLevel,
      this.geometry,
      this.name,
      this.rating,
      this.vicinity,
      this.photos,
      this.openingHours});

  ListPlaces.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    rating = (json['rating'] != null) ? json['rating'].toDouble() : 0.0;
    name = json['name'];
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    if (json['opening_hours'] != null) {
      openingHours = (json['opening_hours']['open_now'] != null)
          ? json['opening_hours']['open_now']
          : null;
    } else
      openingHours = openingHours;

    priceLevel = (json['price_level'] != null) ? json['price_level'] : 0;
    vicinity = json['vicinity'];
  }
}

class PlaceRes {
  final String name;
  final double rating;
  final int userRatingCount;
  final String vicinity;
  final String latitude;
  final String longitude;

  PlaceRes({
    this.name,
    this.rating,
    this.userRatingCount,
    this.vicinity,
    this.latitude,
    this.longitude,
  });

  PlaceRes.fromJson(Map<dynamic, dynamic> parsedJson)
      : name = parsedJson['name'],
        rating = (parsedJson['user_rating']['aggregate_rating'] != null)
            ? parsedJson['user_rating']['aggregate_rating'].toDouble()
            : null,
        userRatingCount = (parsedJson['user_rating']['votes'] != null)
            ? parsedJson['restaurant']['user_rating']['votes']
            : null,
        vicinity = parsedJson['location']['locatily_verbose'],
        latitude = parsedJson['location']['latitude'].toString(),
        longitude = parsedJson['location']['longitude'].toString();
}
