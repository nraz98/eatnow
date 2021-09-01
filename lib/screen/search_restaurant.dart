import 'dart:math';
import 'package:EatNow/model/place.dart';
import 'package:EatNow/screen/main_drawer.dart';
import 'package:EatNow/services/geolocator_service.dart';
import 'package:EatNow/services/places_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const kGoogleApiKey = "AIzaSyC7kc7T93DYQ8ZmV9aJaVu-mNs1HCOx6rk";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchRestaurant extends StatefulWidget {
  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<SearchRestaurant> {
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  Mode _mode = Mode.overlay;
  final _controller = TextEditingController();
  Position center;
  List<ListPlaces> places = [];
  bool isLoading = false;
  String errorMessage;
  final geoService = GeoLocatorService();
  double _lat = 0.0;
  double _lng = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: searchScaffoldKey,
        appBar: AppBar(
          title: Text(
            "Search Nearby Location",
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
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _controller,
                readOnly: true,
                onTap: () async {
                  Prediction p = await _handlePressButton();
                  if (p != null) {
                    final position = await getPositionSearch(p.placeId);
                    setState(() {
                      _controller.text = p.description;
                      _lat = position.latitude;
                      _lng = position.longitude;
                      print(_lat);
                      print(_lng);
                    });

                    getNearbyPlaces(position);
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Enter The Location',
                    border: OutlineInputBorder(),
                    filled: true,
                    errorStyle: TextStyle(fontSize: 15)),
              ),
              SizedBox(height: 20.0),
              (places.length == 0)
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.search,
                              color: Colors.deepOrange,
                              size: 118,
                            ),
                          ),
                          Center(
                            child: Text(
                              'No result found!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            return FutureProvider(
                              create: (context) => geoService.getDistance(
                                  _lat,
                                  _lng,
                                  places[index].geometry.location.lat,
                                  places[index].geometry.location.lng),
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
                                            (places[index].openingHours == true)
                                                ? Text(
                                                    'OPEN',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.green[600],
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    'CLOSED',
                                                    style: TextStyle(
                                                        color: Colors.red[800],
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            SizedBox(
                                              height: 3.0,
                                            ),
                                            Text(places[index].vicinity),
                                            SizedBox(
                                              height: 3.0,
                                            ),
                                            (places[index].rating != null)
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      RatingBarIndicator(
                                                        rating: places[index]
                                                            .rating,
                                                        itemBuilder: (context,
                                                                index) =>
                                                            Icon(Icons.star,
                                                                color: Colors
                                                                    .amber),
                                                        itemCount: 5,
                                                        itemSize: 10.0,
                                                        direction:
                                                            Axis.horizontal,
                                                      )
                                                    ],
                                                  )
                                                : Row(),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Consumer<double>(
                                              builder:
                                                  (context, meters, wiget) {
                                                return (meters != null)
                                                    ? Text('${(meters)} KM')
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
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      _launchMapsUrl(
                                          places[index].geometry.location.lat,
                                          places[index].geometry.location.lng);
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
            ],
          ),
        ));
  }

  Future<Prediction> _handlePressButton() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "en",
      components: [Component(Component.country, "my")],
    );

    return p;
  }

  Future<Position> getPositionSearch(String prediction) async {
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    final position = Position(latitude: lat, longitude: lng);

    return position;
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getNearbyPlaces(Position center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });
    final placesService = PlacesService();
    print(center);
    final result =
        await placesService.getListPlaces(center.latitude, center.longitude);

    setState(() {
      this.isLoading = false;
      if (result != null) {
        print(result);
        this.places = result;
      }
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
