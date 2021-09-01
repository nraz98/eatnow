import 'package:EatNow/model/place.dart';
import 'package:EatNow/model/user_data.dart';
import 'package:EatNow/providers/preferences_provider.dart';
import 'package:EatNow/providers/restaurant_state.dart';
import 'package:EatNow/screen/authenticate/auth.dart';
import 'package:EatNow/screen/authenticate/register.dart';
import 'package:EatNow/screen/authenticate/sign_in.dart';
import 'package:EatNow/screen/best_nearby.dart';
import 'package:EatNow/screen/find_restaurant2.dart';
import 'package:EatNow/screen/home_screen.dart';
import 'package:EatNow/screen/my_preferences.dart';
import 'package:EatNow/screen/preferences_crud.dart';
import 'package:EatNow/screen/search_restaurant.dart';
import 'package:EatNow/screen/trendinglist2.dart';
import 'package:EatNow/screen/wrapper.dart';
import 'package:EatNow/services/geolocator_service.dart';
import 'package:EatNow/services/places_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:EatNow/providers/restaurant_api.dart';

void main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placeService = PlacesService();
  final trendService = PlaceNearbyService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserData>.value(value: AuthService().user),
        Provider(create: (context) => RestaurantState()),
        Provider(create: (context) => RestaurantApi()),
        ChangeNotifierProvider(create: (context) => AddProvider()),
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(create: (context) {
          ImageConfiguration configuration =
              createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(
              configuration, 'assets/images/restaurant.png');
        }),
        ProxyProvider2<Position, BitmapDescriptor, Future<List<PlaceMain>>>(
          update: (context, position, icon, places) {
            return (position != null)
                ? placeService.getPlacesNearby(
                    position.latitude, position.longitude, icon)
                : null;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EatNow!',
        theme: ThemeData(
            primaryColor: Colors.orange, accentColor: Colors.blueGrey[700]),
        routes: {
          "/": (_) => Wrapper(),
          "/home-screen": (_) => HomeScreen(),
          "/best-nearby": (_) => SearchNearby(),
          "/search-restaurant": (_) => SearchRestaurant(),
          "/my-restaurant": (_) => TrendScreen(),
          "/find-restaurant": (_) => FindRestaurant32(),
          "/add-preferences": (_) => AddPreferences(),
          "/my-preferences": (_) => MyPreferences(),
          "/sign-in": (_) => SignIn(),
          "/register": (_) => Register(),
        },
      ),
    );
  }
}
