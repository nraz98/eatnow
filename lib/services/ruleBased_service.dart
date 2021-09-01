import 'package:EatNow/model/trend.dart';
import 'package:EatNow/model/user_preferences.dart';
import 'package:EatNow/model/venue_search.dart';
import 'package:EatNow/services/database.dart';
import 'package:EatNow/services/weather_service.dart';

import 'package:intl/intl.dart';
import 'package:EatNow/services/trending_service.dart';

class RuleBased {
  final weatherService = WeatherService();
  String currentWeather = '';
  int temperature = 0;
  String location = '';
  String time = DateFormat('HH:mm').format(DateTime.now());
  String expectedMeal;

  final firestoreService = FirestoreService();

  Future<String> getWeatherRule() async {
    String currentWeather = await weatherService.getWeather();
    return currentWeather;
  }

  Future<List<Default>> getRuleDefault() async {
    final firestoreService = FirestoreService();
    final result = await firestoreService.getDefault().first;
    return result;
  }

  Future<List<TrendingModel>> getRuleTrending() async {
    final trending = Trending();
    final result = await trending.getTrendingPlaces();
    return result;
  }

  Future<List<String>> getRuleBased() async {
    DateTime now = DateTime.now();
    DateFormat dateFormat = new DateFormat.Hm();
    List<String> suggestRes = [];
    List<String> beforeSuggest = [];
    final trending = Trending();
    final defaultData = await getRuleDefault();
    final trendingData = await getRuleTrending();
    final weatherData = await getWeatherRule();

    List<TrendingModel> trend = trendingData;
    print(now);
    //Default Data
    final String dCulture = defaultData.first.defaultCulture;
    final String dFood = defaultData.first.defaultFood;
    final bool dTrending = defaultData.first.defaultTrending;

    //Weather Data
    final bool dWeather = defaultData.first.defaultWeather;

    //Trend data
    final int tLength = trend[0].items.length;

    //Breakfast
    DateTime bfStart = dateFormat.parse("07:00");
    bfStart = new DateTime(
        now.year, now.month, now.day, bfStart.hour, bfStart.minute);
    DateTime bfEnd = dateFormat.parse("10:00");
    bfEnd =
        new DateTime(now.year, now.month, now.day, bfEnd.hour, bfEnd.minute);
    //After Breakfast
    DateTime snackStart = dateFormat.parse("10:01");
    snackStart = new DateTime(
        now.year, now.month, now.day, snackStart.hour, snackStart.minute);
    DateTime snackEnd = dateFormat.parse("11:59");
    snackEnd = new DateTime(
        now.year, now.month, now.day, snackEnd.hour, snackEnd.minute);
    //Lunch
    DateTime lunchStart = dateFormat.parse("12:00");
    lunchStart = new DateTime(
        now.year, now.month, now.day, lunchStart.hour, lunchStart.minute);
    DateTime lunchEnd = dateFormat.parse("16:00");
    lunchEnd = new DateTime(
        now.year, now.month, now.day, lunchEnd.hour, lunchEnd.minute);
    //Tea
    DateTime teaStart = dateFormat.parse("16:01");
    teaStart = new DateTime(
        now.year, now.month, now.day, teaStart.hour, teaStart.minute);
    DateTime teaEnd = dateFormat.parse("18:59");
    teaEnd =
        new DateTime(now.year, now.month, now.day, teaEnd.hour, teaEnd.minute);
    //Dinner
    DateTime dinnerStart = dateFormat.parse("19:00");
    dinnerStart = new DateTime(
        now.year, now.month, now.day, dinnerStart.hour, dinnerStart.minute);
    DateTime dinnerEnd = dateFormat.parse("22:30");
    dinnerEnd = new DateTime(
        now.year, now.month, now.day, dinnerEnd.hour, dinnerEnd.minute);
    //Supper
    DateTime supperStart = dateFormat.parse("22:31");
    supperStart = new DateTime(
        now.year, now.month, now.day, supperStart.hour, supperStart.minute);
    DateTime supperEnd = dateFormat.parse("23:59");
    supperEnd = new DateTime(
        now.year, now.month, now.day, supperEnd.hour, supperEnd.minute);

    //Rule 1
    if (now.isAfter(bfStart) && now.isBefore(bfEnd)) {
      {
        expectedMeal = "Breakfast";
      }
    } else if (now.isAfter(lunchStart) && now.isBefore(lunchEnd)) {
      {
        expectedMeal = "Lunch";
      }
    } else if (now.isAfter(teaStart) && now.isBefore(teaEnd)) {
      {
        expectedMeal = "Tea";
      }
    } else if (now.isAfter(dinnerStart) && now.isBefore(dinnerEnd)) {
      {
        expectedMeal = "Dinner";
      }
    } else if (now.isAfter(supperStart) && now.isBefore(supperEnd)) {
      {
        expectedMeal = "Supper";
      }
    } else if (now.isAfter(snackStart) && now.isBefore(snackEnd)) {
      {
        expectedMeal = "Snack";
      }
    } else {
      expectedMeal = "Late Snack";
    }

    print(expectedMeal);

    //Start Rule
    if (expectedMeal == "Breakfast") {
      if (dCulture == "Local") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (dFood == "Spicy") {
              if (tName == "Nasi Lemak" || tName == "Warung") {
                suggestRes = suggestRes + [tName];
              }
            } else if (tCat == "Malay") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            //beforeSuggest = ["Malay"];
            beforeSuggest = ["4bf58dd8d48988d156941735"];
          }
        } else if (dTrending == false) {
          if (dFood == "Spicy")
            suggestRes = ["Nasi Lemak", "Warung"];
          else
            //beforeSuggest = ["Malay"];
            beforeSuggest = ["4bf58dd8d48988d156941735"];
        } else {
          //beforeSuggest = ["Malay"];
          beforeSuggest = ["4bf58dd8d48988d156941735"];
        }
      } else
      //Breakfast Indian
      if (dCulture == "Indian") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "Mamak") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            //beforeSuggest = ["Mamak"];
            beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
          }
        } else if (dTrending == false) {
          // beforeSuggest = ["Mamak"];
          beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
        } else {
          //beforeSuggest = ["Mamak"];
          beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
        }
      } else
      //Breakfast Asian
      if (dCulture == "Asian") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "Asian") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            // beforeSuggest = ["Asian"];
            beforeSuggest = ["4bf58dd8d48988d142941735"];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["Asian"];
          beforeSuggest = ["4bf58dd8d48988d142941735"];
        } else {
          // beforeSuggest = ["Asian"];
          beforeSuggest = ["4bf58dd8d48988d142941735"];
        }
      } else if (dCulture == "Western") {
        //American Restaurant //Western Restaurant

        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "American" || tCat == "English") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            // beforeSuggest = ["American", "English", "Fast-Food"];
            beforeSuggest = [
              "4bf58dd8d48988d14e941735",
              "52e81612bcbc57f1066b7a05",
              "4bf58dd8d48988d16e941735"
            ];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["American", "English", "Fast-Food"];
          beforeSuggest = [
            "4bf58dd8d48988d14e941735",
            "52e81612bcbc57f1066b7a05",
            "4bf58dd8d48988d16e941735"
          ];
        } else {
          // beforeSuggest = ["American", "English", "Fast-Food"];
          beforeSuggest = [
            "4bf58dd8d48988d14e941735",
            "52e81612bcbc57f1066b7a05",
            "4bf58dd8d48988d16e941735"
          ];
        }
      } else {
        //beforeSuggest = ["Breakfast"];
        beforeSuggest = ["4bf58dd8d48988d143941735"];
      }
    } else if (expectedMeal == "Lunch") {
      if (dCulture == "Local") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (dFood == "Spicy") {
              if (tName == "Asam Pedas" || tName == "Cili Api") {
                suggestRes = suggestRes + [tName];
              }
            } else {
              if (tCat == "Malay") {
                suggestRes = suggestRes + [tName];
              }
            }
          }
          if (suggestRes.length == 0) {
            //beforeSuggest = ["Malay"];
            beforeSuggest = ["4bf58dd8d48988d156941735"];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["Malay"];
          if (dFood == "Spicy")
            suggestRes = ["Asam Pedas", "Cili Api"];
          else
            beforeSuggest = ["4bf58dd8d48988d156941735"];
        } else {
          //beforeSuggest = ["Malay"];
          beforeSuggest = ["4bf58dd8d48988d156941735"];
        }
      } else if (dCulture == "Indian") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "Mamak") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            //beforeSuggest = ["Mamak"];
            beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["Mamak"];
          beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
        } else {
          // beforeSuggest = ["Mamak"];
          beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
        }
      } else if (dCulture == "Asian") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "Asian") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            //beforeSuggest = ["Asian"];
            beforeSuggest = ["4bf58dd8d48988d142941735"];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["Asian"];
          beforeSuggest = ["4bf58dd8d48988d142941735"];
        } else {
          // beforeSuggest = ["Asian"];
          beforeSuggest = ["4bf58dd8d48988d142941735"];
        }
      } else if (dCulture == "Western") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "American" ||
                tCat == "English" ||
                tCat == "Fast-Food") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            // beforeSuggest = ["American", "English","Fast Food"];
            beforeSuggest = [
              "4bf58dd8d48988d14e941735",
              "52e81612bcbc57f1066b7a05",
              "4bf58dd8d48988d16e941735"
            ];
          }
        } else if (dTrending == false) {
          // beforeSuggest = ["American", "English","Fast Food"];
          beforeSuggest = [
            "4bf58dd8d48988d14e941735",
            "52e81612bcbc57f1066b7a05",
            "4bf58dd8d48988d16e941735"
          ];
        } else {
          // beforeSuggest = ["American", "English","Fast Food"];
          beforeSuggest = [
            "4bf58dd8d48988d14e941735",
            "52e81612bcbc57f1066b7a05",
            "4bf58dd8d48988d16e941735"
          ];
        }
      } else
        //beforeSuggest = ["Restaurant"];
        beforeSuggest = [" 4bf58dd8d48988d1c4941735"];
    } else if (expectedMeal == "Dinner") {
      if (dCulture == "Local") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "Malay") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            //beforeSuggest = ["Malay"];
            beforeSuggest = ["4bf58dd8d48988d156941735"];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["Malay"];
          beforeSuggest = ["4bf58dd8d48988d156941735"];
        } else {
          //beforeSuggest = ["Malay"];
          beforeSuggest = ["4bf58dd8d48988d156941735"];
        }
      } else if (dCulture == "Indian") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "Mamak") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            //beforeSuggest = ["Mamak"];
            beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["Mamak"];
          beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
        } else {
          //beforeSuggest = ["Mamak"];
          beforeSuggest = ["5ae9595eb77c77002c2f9f26"];
        }
      } else if (dCulture == "Asian") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "Asian" ||
                tCat == "Seafood" ||
                tCat == "Buffet" ||
                tCat == "Thai" ||
                tCat == "BBQ") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            // beforeSuggest = ["Asian", "Seafood", "Buffet", "Thai", "BBQ"];
            beforeSuggest = [
              "4bf58dd8d48988d142941735",
              "4bf58dd8d48988d1ce941735",
              "52e81612bcbc57f1066b79f4",
              "4bf58dd8d48988d149941735",
              "4bf58dd8d48988d1df931735"
            ];
          }
        } else if (dTrending == false) {
          // beforeSuggest = ["Asian", "Seafood", "Buffet", "Thai", "BBQ"];
          beforeSuggest = [
            "4bf58dd8d48988d142941735",
            "4bf58dd8d48988d1ce941735",
            "52e81612bcbc57f1066b79f4",
            "4bf58dd8d48988d149941735",
            "4bf58dd8d48988d1df931735"
          ];
        } else {
          // beforeSuggest = ["Asian", "Seafood", "Buffet", "Thai", "BBQ"];
          beforeSuggest = [
            "4bf58dd8d48988d142941735",
            "4bf58dd8d48988d1ce941735",
            "52e81612bcbc57f1066b79f4",
            "4bf58dd8d48988d149941735",
            "4bf58dd8d48988d1df931735"
          ];
        }
      } else if (dCulture == "Western") {
        if (dTrending == true) {
          suggestRes.length = 0;
          for (int i = 0; i < tLength; i++) {
            String tCat = trend[0].items[i].venue.categories[0].shortName;
            String tName = trend[0].items[i].venue.name;
            if (tCat == "American" ||
                tCat == "English" ||
                tCat == "Fast Food") {
              suggestRes = suggestRes + [tName];
            }
          }
          if (suggestRes.length == 0) {
            // beforeSuggest = ["American", "English","Fast Food"];
            beforeSuggest = [
              "4bf58dd8d48988d14e941735",
              "52e81612bcbc57f1066b7a05",
              "4bf58dd8d48988d16e941735"
            ];
          }
        } else if (dTrending == false) {
          //beforeSuggest = ["American", "English","Fast Food"];
          beforeSuggest = [
            "4bf58dd8d48988d14e941735",
            "52e81612bcbc57f1066b7a05",
            "4bf58dd8d48988d16e941735"
          ];
        } else {
          // beforeSuggest = ["American", "English","Fast Food"];
          beforeSuggest = [
            "4bf58dd8d48988d14e941735",
            "52e81612bcbc57f1066b7a05",
            "4bf58dd8d48988d16e941735"
          ];
        }
      } else {
        beforeSuggest = ["Diner"];
      }
    } else if (expectedMeal == "Tea" || expectedMeal == "Snack") {
      if (dWeather == true) {
        if (weatherData == "Clouds" || weatherData == "Clear") {
          if (dTrending == true) {
            suggestRes.length = 0;
            for (int i = 0; i < tLength; i++) {
              String tCat = trend[0].items[i].venue.categories[0].shortName;
              String tName = trend[0].items[i].venue.name;
              if (dCulture == "Local") {
                if (tName == "Cendol" || tName == "ABC") {
                  {
                    suggestRes = suggestRes + [tName];
                  }
                } else
                  suggestRes = ["Cendol", "ABC"];
              } else {
                if (tCat == "Dessert" || tCat == "Bubble Tea") {
                  suggestRes = suggestRes + [tName];
                }
              }
            }
            if (suggestRes.length == 0) {
              //beforeSuggest = ["Dessert", "Bubble Tea"];
              beforeSuggest = [
                "4bf58dd8d48988d1d0941735",
                "52e81612bcbc57f1066b7a0c"
              ];
            } else if (dTrending == false) {
              if (dCulture == "Local") {
                suggestRes = ["Cendol", "ABC"];
              } else {
                //beforeSuggest = ["Dessert", "Bubble Tea"];
                beforeSuggest = [
                  "4bf58dd8d48988d1d0941735",
                  "52e81612bcbc57f1066b7a0c"
                ];
              }
            } else {
              //beforeSuggest = ["Dessert", "Bubble Tea"];
              beforeSuggest = [
                "4bf58dd8d48988d1d0941735",
                "52e81612bcbc57f1066b7a0c"
              ];
            }
          } else
            beforeSuggest = [
              "4bf58dd8d48988d1d0941735",
              "52e81612bcbc57f1066b7a0c"
            ];
        } else if (weatherData == "Rain" ||
            weatherData == "Thunderstorm" ||
            weatherData == "Drizzle") {
          if (dTrending == true) {
            suggestRes.length = 0;
            for (int i = 0; i < tLength; i++) {
              String tCat = trend[0].items[i].venue.categories[0].shortName;
              String tName = trend[0].items[i].venue.name;
              if (dFood == "Spicy") {
                if (tName == "Laksa" || tName == "Mee") {
                  suggestRes = suggestRes + [tName];
                }
              } else if (dFood == "Bitter") {
                if (tName == "Coffee") {
                  suggestRes = suggestRes + [tName];
                }
              } else {
                if (tCat == "Noodle" ||
                    tCat == "Coffee" ||
                    tCat == "Kebab" ||
                    tCat == "Soup") {
                  suggestRes = suggestRes + [tName];
                }
              }
            }
            if (suggestRes.length == 0) {
              //beforeSuggest = [ "Cofee", "Kebab", "Soup"];
              beforeSuggest = [
                "4bf58dd8d48988d1e0931735",
                "5283c7b4e4b094cb91ec88d7",
                "4bf58dd8d48988d1dd931735"
              ];
            }
          } else if (dTrending == false) {
            //beforeSuggest = ["Cofee", "Kebab", "Soup"];
            if (dFood == "Spicy")
              suggestRes = ["Laksa", "Mee"];
            else if (dFood == "Bitter") {
              suggestRes = ["Cofee"];
            } else {
              //beforeSuggest = [ "Cofee", "Kebab", "Soup"];
              beforeSuggest = [
                "4bf58dd8d48988d1e0931735",
                "5283c7b4e4b094cb91ec88d7",
                "4bf58dd8d48988d1dd931735"
              ];
            }
          } else {
            //beforeSuggest = [ "Cofee", "Kebab", "Soup"];
            beforeSuggest = [
              "4bf58dd8d48988d1e0931735",
              "5283c7b4e4b094cb91ec88d7",
              "4bf58dd8d48988d1dd931735"
            ];
          }
        } else {
          //beforeSuggest = ["Cofee", "Kebab",  "Soup","Dessert", "Bubble Tea"];
          beforeSuggest = [
            "4bf58dd8d48988d1e0931735",
            "5283c7b4e4b094cb91ec88d7",
            "4bf58dd8d48988d1dd931735"
                "4bf58dd8d48988d1d0941735",
            "52e81612bcbc57f1066b7a0c"
          ];
        }
      } else {
        //beforeSuggest = ["Cofee", "Kebab",  "Dessert", "Bubble Tea"];
        beforeSuggest = [
          "4bf58dd8d48988d1e0931735",
          "5283c7b4e4b094cb91ec88d7",
          "4bf58dd8d48988d1d0941735",
          "52e81612bcbc57f1066b7a0c"
        ];
      }
    } else if (expectedMeal == "Supper" || expectedMeal == "Late Snack") {
      if (dCulture == "Local" || dCulture == "Asian" || dCulture == "Indian") {
        //beforeSuggest = ["Malay", "Mamak"];
        beforeSuggest = [
          "4bf58dd8d48988d156941735",
          "5ae9595eb77c77002c2f9f26"
        ];
      } else if (dCulture == "Western") {
        //beforeSuggest = ["Fast Food", "Burger"];
        beforeSuggest = [
          "4bf58dd8d48988d16e941735",
          "44bf58dd8d48988d16c941735"
        ];
      } else {
        beforeSuggest = [
          "4bf58dd8d48988d156941735",
          "5ae9595eb77c77002c2f9f26",
          "4bf58dd8d48988d16e941735",
          "44bf58dd8d48988d16c941735"
        ];
      }
    } else {
      // beforeSuggest = ["Food"];
      beforeSuggest = ["4bf58dd8d48988d156941735", "5ae9595eb77c77002c2f9f26"];
    }
    print(beforeSuggest);
    List<VenueSearch> listCat = [];
    List<String> beforelist = [];

    if (beforeSuggest.length != 0) {
      for (int i = 0; i < beforeSuggest.length; i++) {
        final resultCat = await trending.getListCategory(beforeSuggest[i]);
        print(resultCat);
        if (resultCat != null || resultCat != []) {
          listCat = resultCat;
          for (int j = 0; j < listCat.length; j++) {
            String rList = listCat[j].name;
            beforelist = beforelist + [rList];
          }
        }
      }
    }

    if (suggestRes.length == 0) {
      suggestRes = beforelist;
    }

    return suggestRes;
  }
}
