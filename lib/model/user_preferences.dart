import 'package:flutter/cupertino.dart';

class Preferences {
  final String preferId;
  final String preferName;
  final String perferFood;
  final String preferCulture;
  final double preferRating;
  final int preferPrice;
  final bool preferWeather;
  final bool preferTrending;

  Preferences({
    @required this.preferId,
    this.preferWeather,
    this.preferTrending,
    this.preferName,
    this.perferFood,
    this.preferRating,
    this.preferCulture,
    this.preferPrice,
  });
  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      preferId: json['preferId'],
      preferName: json['preferName'],
      perferFood: json['preferFood'],
      preferRating: json['preferRating'],
      preferCulture: json['preferCulture'],
      preferPrice: json['preferPrice'],
      preferTrending: json['preferTrending'],
      preferWeather: json['preferWeather'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'preferId': preferId,
      'preferName': preferName,
      'preferFood': perferFood,
      'preferRating': preferRating,
      'preferCulture': preferCulture,
      'preferPrice': preferPrice,
      'preferWeather': preferWeather,
      'preferTrending': preferTrending,
    };
  }
}

class Default {
  final String defaultId;
  final String defaultPreferences;
  final String defaultName;
  final String defaultFood;
  final String defaultCulture;
  final double defaultRating;
  final int defaultPrice;
  final bool defaultTrending;
  final bool defaultWeather;

  Default({
    @required this.defaultId,
    this.defaultPreferences,
    this.defaultName,
    this.defaultFood,
    this.defaultRating,
    this.defaultCulture,
    this.defaultPrice,
    this.defaultTrending,
    this.defaultWeather,
  });
  factory Default.fromJson(Map<String, dynamic> json) {
    return Default(
      defaultId: json['defaultId'],
      defaultPreferences: json['defaultPreferences'],
      defaultName: json['defaultName'],
      defaultFood: json['defaultFood'],
      defaultCulture: json['defaultCulture'],
      defaultRating: json['defaultRating'],
      defaultPrice: json['defaultPrice'],
      defaultTrending: json['defaultTrending'],
      defaultWeather: json['defaultWeather'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'defaultId': defaultId,
      'defaultPreferences': defaultPreferences,
      'defaultName': defaultName,
      'defaultFood': defaultFood,
      'defaultCulture': defaultCulture,
      'defaultRating': defaultRating,
      'defaultPrice': defaultPrice,
      'defaultWeather': defaultWeather,
      'defaultTrending': defaultTrending,
    };
  }
}
