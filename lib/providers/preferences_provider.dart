import 'package:EatNow/model/user_preferences.dart';
import 'package:EatNow/screen/search_restaurant.dart';
import 'package:EatNow/services/database.dart';
import 'package:flutter/cupertino.dart';

class AddProvider with ChangeNotifier {
  final firestoreService = FirestoreService();

  String _preferId;

  String _preferName, _preferFood, _preferCulture;
  double _preferRating;
  int _preferPrice;
  bool _preferWeather, _preferTrending;

  var uuid = Uuid();
  //getter
  String get preferId => _preferId;
  String get preferName => _preferName;
  String get preferFood => _preferFood;
  String get preferCulture => _preferCulture;
  double get preferRating => _preferRating;
  int get preferPrice => _preferPrice;
  bool get preferWeather => _preferWeather;
  bool get preferTrending => _preferTrending;

  Stream<List<Preferences>> get preferencesData =>
      firestoreService.getPreferences();

//setter
  set changeName(String name) {
    _preferName = name;
    notifyListeners();
  }

  set changeFood(String food) {
    _preferFood = food;
    notifyListeners();
  }

  set changeCulture(String culture) {
    _preferCulture = culture;
    notifyListeners();
  }

  set changeRating(double rating) {
    _preferRating = rating;
    notifyListeners();
  }

  set changePrice(int price) {
    _preferPrice = price;
    notifyListeners();
  }

  set changeWeather(bool weather) {
    _preferWeather = weather;
    notifyListeners();
  }

  set changeTrending(bool trending) {
    _preferTrending = trending;
    notifyListeners();
  }

  loadAll(Preferences preferences) {
    if (preferences != null) {
      _preferId = preferences.preferId;
      _preferName = preferences.preferName;
      _preferFood = preferences.perferFood;
      _preferRating = preferences.preferRating;
      _preferPrice = preferences.preferPrice;
      _preferTrending = preferences.preferTrending;
      _preferWeather = preferences.preferWeather;
      _preferCulture = preferences.preferCulture;
    } else {
      _preferId = null;
      _preferName = null;
      _preferFood = 'Anything';
      _preferRating = 0.0;
      _preferPrice = 0;
      _preferTrending = false;
      _preferWeather = false;
      _preferCulture = 'Anything';
    }
  }

  saveEntry() {
    if (_preferId == null) {
      String myNewId = uuid.generateV4();
      var newPreferences = Preferences(
          preferId: myNewId,
          preferName: _preferName,
          perferFood: _preferFood,
          preferRating: _preferRating,
          preferPrice: _preferPrice,
          preferCulture: _preferCulture,
          preferTrending: _preferTrending,
          preferWeather: _preferWeather);
      firestoreService.setPreferences(newPreferences);

      var newDefault = Default(
          defaultId: 'myDefaultValue',
          defaultPreferences: myNewId,
          defaultName: _preferName,
          defaultFood: _preferFood,
          defaultRating: _preferRating,
          defaultPrice: _preferPrice,
          defaultCulture: _preferCulture,
          defaultTrending: _preferTrending,
          defaultWeather: _preferWeather);
      firestoreService.setDefault(newDefault);
    } else {
      var updatePreferences = Preferences(
          preferId: _preferId,
          preferName: _preferName,
          perferFood: _preferFood,
          preferRating: _preferRating,
          preferPrice: _preferPrice,
          preferCulture: _preferCulture,
          preferTrending: _preferTrending,
          preferWeather: _preferWeather);
      firestoreService.setPreferences(updatePreferences);

      var newDefault = Default(
          defaultId: 'myDefaultValue',
          defaultPreferences: _preferId,
          defaultName: _preferName,
          defaultFood: _preferFood,
          defaultCulture: _preferCulture,
          defaultRating: _preferRating,
          defaultPrice: _preferPrice,
          defaultTrending: _preferTrending,
          defaultWeather: _preferWeather);
      firestoreService.setDefault(newDefault);
    }
  }

  removePreferences(String preferId, String defaultPreferences) async {
    if (defaultPreferences == preferId) {
      print(defaultPreferences);
      print(preferId);
      firestoreService.removeDefault();
      firestoreService.removePreferences(preferId);
    } else {
      if (defaultPreferences == null) {
        firestoreService.removePreferences(preferId);
      } else {
        firestoreService.removePreferences(preferId);
      }
    }
  }
}
