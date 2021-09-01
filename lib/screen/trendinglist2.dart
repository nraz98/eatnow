import 'package:EatNow/model/place.dart';
import 'package:EatNow/screen/authenticate/auth.dart';
import 'package:EatNow/screen/main_drawer.dart';
import 'package:EatNow/screen/shared/loading.dart';
import 'package:EatNow/screen/shared/popup.dart';
import 'package:EatNow/services/database.dart';
import 'package:EatNow/services/geolocator_service.dart';
import 'package:EatNow/services/places_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TrendScreen extends StatefulWidget {
  @override
  _TrendScreenState createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen> {
  List<ListPlaces> places = [];
  double lat = 0.0;
  double lng = 0.0;
  final geoService = GeoLocatorService();
  final firestoreService = FirestoreService();
  User user;
  String defaultName;
  double defaultRating;
  int defaultPrice;

  Future<void> getMenu() async {
    ListPlaces bPlaces;
    final geoService2 = GeoLocatorService();
    final center = await geoService2.getLocation();
    final placeTrend = PlaceNearbyService();
    List<ListPlaces> result =
        await placeTrend.getTrendDetails(center.latitude, center.longitude);

    for (int i = 0; i < result.length; i++) {
      setState(() {
        if (result[i].rating >= defaultRating &&
            result[i].priceLevel >= defaultPrice) {
          bPlaces = result[i];
          places = places + [bPlaces];
        } else {
          this.places = places;
        }
        lat = center.latitude;
        lng = center.longitude;
      });
    }
  }

  Future<void> getDefaultValue() async {
    final AuthService _auth = AuthService();
    User userData = await _auth.getCurrentUser();
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('UserData')
        .doc(userData.uid)
        .collection('default')
        .doc('myDefaultValue');

    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          defaultName = datasnapshot.data()['defaultName'];
          defaultRating = datasnapshot.data()['defaultRating'];
          defaultPrice = datasnapshot.data()['defaultPrice'];
        });
      } else {
        setState(() {
          defaultName = '';
        });
      }
    });
  }

  @override
  void initState() {
    getDefaultValue();
    getMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (defaultName != '')
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "My Restaurant",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.home),
                  label: Text(''),
                  onPressed: () async {
                    Navigator.of(context).pushNamed('/home-screen');
                  },
                )
              ],
            ),
            drawer: MainDrawer(),
            body: (lat != 0 && lng != 0)
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        (places.length > 0)
                            ? Expanded(
                                child: ListView.builder(
                                    itemCount: places.length,
                                    itemBuilder: (context, index) {
                                      return FutureProvider(
                                        create: (context) =>
                                            geoService.getDistance(
                                                lat,
                                                lng,
                                                places[index]
                                                    .geometry
                                                    .location
                                                    .lat,
                                                places[index]
                                                    .geometry
                                                    .location
                                                    .lng),
                                        child: Card(
                                            child: ListTile(
                                          subtitle: Row(
                                            children: [
                                              (places[index].photos != null)
                                                  ? Ink(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: new NetworkImage(
                                                                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&maxheight=100&key=AIzaSyC7kc7T93DYQ8ZmV9aJaVu-mNs1HCOx6rk&photoreference=' +
                                                                    places[index]
                                                                        .photos
                                                                        .first
                                                                        .photoReference)),
                                                      ))
                                                  : Container(
                                                      height: 100,
                                                      width: 100,
                                                      color: Colors.orange[400],
                                                      child: Icon(
                                                        Icons.restaurant,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                  child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(places[index]
                                                        .name
                                                        .toUpperCase()),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    (places[index]
                                                                .openingHours ==
                                                            true)
                                                        ? Text(
                                                            'OPEN',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : Text(
                                                            'CLOSED',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    Text(
                                                        places[index].vicinity),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    (places[index].priceLevel !=
                                                            0)
                                                        ? RatingBarIndicator(
                                                            rating:
                                                                places[index]
                                                                    .priceLevel
                                                                    .toDouble(),
                                                            itemBuilder: (context,
                                                                    index) =>
                                                                Icon(
                                                                    Icons
                                                                        .attach_money,
                                                                    color: Colors
                                                                        .amber),
                                                            itemCount: 4,
                                                            itemSize: 15.0,
                                                            direction:
                                                                Axis.horizontal,
                                                          )
                                                        : Row(),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    (places[index].rating !=
                                                            0.0)
                                                        ? Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              RatingBarIndicator(
                                                                rating: places[
                                                                        index]
                                                                    .rating
                                                                    .toDouble(),
                                                                itemBuilder: (context,
                                                                        index) =>
                                                                    Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber),
                                                                itemCount: 5,
                                                                itemSize: 10.0,
                                                                direction: Axis
                                                                    .horizontal,
                                                              )
                                                            ],
                                                          )
                                                        : Row(),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Consumer<double>(
                                                      builder: (context, meters,
                                                          wiget) {
                                                        return (meters != null)
                                                            ? Text(
                                                                '${(meters)} KM')
                                                            : Container();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(Icons.directions),
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () {
                                              _launchMapsUrl(
                                                  places[index]
                                                      .geometry
                                                      .location
                                                      .lat,
                                                  places[index]
                                                      .geometry
                                                      .location
                                                      .lng);
                                            },
                                          ),
                                        )),
                                      );
                                    }),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.deepOrange,
                                      size: 118,
                                    ),
                                    Text(
                                      'No result found!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                        width: 300.0,
                                        height: 40.0,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.grey)),
                                          color: Colors.grey,
                                          child: Text('Edit My Preferences',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pushNamed('/my-preferences');
                                          },
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                        width: 300.0,
                                        height: 40.0,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: Colors.orange)),
                                          color: Colors.orange,
                                          child: Text('Best Nearby',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            Navigator.of(context)
                                                .pushNamed('/best-nearby');
                                          },
                                        )),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  )
                : Loading(),
          )
        : PopupPreferences();
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
