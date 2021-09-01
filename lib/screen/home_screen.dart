import 'package:EatNow/screen/authenticate/auth.dart';
import 'package:EatNow/screen/main_drawer.dart';
import 'package:EatNow/screen/shared/popup.dart';
import 'package:EatNow/services/geolocator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentWeather = '';
  int temperature = 0;
  String location = '';
  double lat = 0;
  double lng = 0;
  String time = DateFormat('HH:mm').format(DateTime.now());
  List<String> expectedMeal = ['null'];

  List<String> mealRule = ["Cannot get Data"];

  final homeScreenScaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();

  Future<void> getMenu() async {
    final geoService = GeoLocatorService();
    final center = await geoService.getLocation();

    setState(() {
      lat = center.latitude;
      lng = center.longitude;
    });
  }

  @override
  void initState() {
    getMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    return (lat == 0 && lng == 0)
        ? Popup()
        : Scaffold(
            key: homeScreenScaffoldKey,
            appBar: AppBar(
              title: Text(
                'EatNow!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            drawer: MainDrawer(),
            backgroundColor: Colors.grey[350],
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Flexible(
                    child: GridView.count(
                        childAspectRatio: 1.0,
                        padding: EdgeInsets.only(left: 9, right: 9),
                        crossAxisCount: 2,
                        crossAxisSpacing: 9,
                        mainAxisSpacing: 9,
                        children: myList.map((data) {
                          return RaisedButton(
                            color: Colors.grey[700],
                            child: ListTile(
                              title: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(
                                    data.img,
                                    size: 60,
                                    color: Colors.yellow[800],
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Center(
                                    child: Text(
                                      data.title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: Text(
                                      data.subtitle,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () async {
                              if (data.link == "/sign-in") {
                                await _auth.signout();
                              } else {
                                Navigator.of(context).pushNamed(data.link);
                              }
                            },
                          );
                        }).toList()))
              ],
            ),
          );
  }

  Items item1 = Items(
      title: "My Restaurant",
      subtitle: "Find Restaurant Based On Your Preferences",
      link: "/my-restaurant",
      img: Icons.fastfood);

  Items item2 = new Items(
    title: "Best Nearby",
    subtitle: "Restaurant Based On Your Best Nearby",
    link: "/best-nearby",
    img: Icons.my_location,
  );
  Items item3 = new Items(
    title: "Search Restaurant",
    subtitle: "Restaurant Based On Insert Location",
    link: "/search-restaurant",
    img: Icons.search,
  );

  Items item4 = new Items(
    title: "Find Restaurant",
    subtitle: "Find Restaurant or Food Near You",
    link: "/find-restaurant",
    img: Icons.restaurant,
  );
  Items item5 = new Items(
    title: "User Preferences",
    subtitle: "Set your preferences here!",
    link: "/my-preferences",
    img: Icons.account_box,
  );
  Items item6 = new Items(
    title: "Logout",
    subtitle: "Logout from the application",
    link: "/sign-in",
    img: Icons.exit_to_app,
  );
}

class Items {
  String title;
  String subtitle;
  IconData img;
  String link;
  Items({this.title, this.subtitle, this.link, this.img});
}
