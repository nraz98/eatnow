import 'package:EatNow/model/venue_search.dart';
import 'package:EatNow/providers/restaurant_state.dart';

import 'package:EatNow/screen/find_filter.dart';
import 'package:EatNow/screen/main_drawer.dart';
import 'package:EatNow/screen/shared/loading.dart';
import 'package:EatNow/services/geolocator_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FindRestaurant32 extends StatefulWidget {
  FindRestaurant32({Key key}) : super(key: key);

  @override
  _FindRestaurantState createState() => _FindRestaurantState();
}

class _FindRestaurantState extends State<FindRestaurant32> {
  // List _restaurants;
  final geoService = GeoLocatorService();
  String query;
  double lat = 0.0;
  double lng = 0.0;
  int l;

  List<VenueSearch> places = [];
  final _restaurantKey = GlobalKey<FormState>();
  var _autoValidate = false;

  Future<List<VenueSearch>> searchRestaurants(
      String query, SearchOptions options) async {
    print(options.categories);
    final center = await geoService.getLocation();
    final lat = center.latitude.toString();
    final lng = center.longitude.toString();
    //  final String cat = '4d4b7105d754a06374d81259';
    final String clientId = 'D2RR3T3YXZIZCBUABPHZ1HF5EASPODCNO4RFWPLFTGTX1ZMY';
    final String secretId = 'RGA04SE1LRXFQVABDAA0BA4UAN2PHSZ0DCM1S4XIHKZQDK0L';

    String baseUrl = 'https://api.foursquare.com/v2/venues/search';
    String request =
        '$baseUrl?client_id=$clientId&client_secret=$secretId&v=20191128';

    // if (_filters.toJson() != null) {}
    final response = await Dio().get(request, queryParameters: {
      'query': query,
      'll': lat + ',' + lng,
      ...(options != null ? options.toJson() : {}),
    });

    var jsonResults = response.data['response']['venues'] as List;

    return jsonResults
        .map((trending) => VenueSearch.fromJson(trending))
        .toList();
  }

  Future<void> getMenu() async {
    final geoService2 = GeoLocatorService();
    final center = await geoService2.getLocation();
    setState(() {
      lat = center.latitude;
      lng = center.longitude;
    });
  }

  bool isLoading = false;
  String errorMessage;

  void getTrendingSearch(String query, SearchOptions options) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final result = await searchRestaurants(query, options);

    setState(() {
      this.isLoading = false;
      if (result != null) {
        this.places = result;
        Loading();
      } else
        print("Sucuess");
    });
  }

  @override
  void initState() {
    getMenu();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RestaurantState>(context);
    return (isLoading == true)
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Find Food/Restaurant",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchFilters()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.tune),
                  ),
                )
              ],
            ),
            drawer: MainDrawer(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                          key: _restaurantKey,
                          autovalidate: _autoValidate,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'Enter Search',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    errorStyle: TextStyle(fontSize: 15)),
                                onChanged: (value) {
                                  setState(() {
                                    query = value;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a search restaurant/food';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: RawMaterialButton(
                                    onPressed: () {
                                      final isValid = _restaurantKey
                                          .currentState
                                          .validate();

                                      if (isValid) {
                                        setState(() {
                                          Loading();
                                        });
                                        getTrendingSearch(
                                            query, state.searchOptions);

                                        FocusManager.instance.primaryFocus
                                            .unfocus();
                                      } else {
                                        setState(() {
                                          _autoValidate = true;
                                        });
                                      }
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    fillColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          'Search',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ))),
                              )
                            ],
                          ))),
                  (query == null)
                      ? Expanded(
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
                                      lat,
                                      lng,
                                      places[index].location.lat,
                                      places[index].location.lng),
                                  child: Card(
                                    child: ListTile(
                                      subtitle: Row(
                                        children: [
                                          Container(
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
                                                SizedBox(
                                                  height: 3.0,
                                                ),
                                                Text(places[index]
                                                    .location
                                                    .formattedAddress
                                                    .join(', ')),
                                                SizedBox(
                                                  height: 3.0,
                                                ),
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
                                              places[index].location.lat,
                                              places[index].location.lng);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }))
                ],
              ),
            ),
          );
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

class FindRestaurantForm extends StatefulWidget {
  FindRestaurantForm({this.onSearch});
  final void Function(String search) onSearch;
  @override
  _FindRestaurantFormState createState() => _FindRestaurantFormState();
}

// // class Restaurant {
// //   final String id;
// //   final String name;
// //   final String address;
// //   final String locality;
// //   final String rating;
// //   final int reviews;
// //   final String thumbnails;

// //   Restaurant._({
// //     this.id,
// //     this.name,
// //     this.address,
// //     this.locality,
// //     this.rating,
// //     this.reviews,
// //     this.thumbnails,
// //   });
// //   factory Restaurant(Map json) => Restaurant._(
// //       id: json['restaurant']['id'],
// //       name: json['restaurant']['name'],
// //       address: json['restaurant']['location']['address'],
// //       locality: json['restaurant']['location']['locality'],
// //       rating: json['restaurant']['user_rating']['aggregate_rating']?.toString(),
// //       reviews: json['restaurant']['all_reviews_count'],
// //       thumbnails:
// //           json['restaurant']['featured_image'] ?? json['restaurant']['thumb']);
// // }

// class RestaurantItem extends StatelessWidget {
//   final VenueSearch restaurants;
//   RestaurantItem(this.restaurants);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: Card(
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Row(
//           children: [
//          Container(
//                     height: 100,
//                     width: 100,
//                     color: Colors.grey,
//                     child: Icon(
//                       Icons.restaurant,
//                       size: 30,
//                       color: Colors.white,
//                     ),
//                   ),
//             Flexible(
//                 child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     restaurants.name,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 7),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         color: Colors.redAccent,
//                         size: 15,
//                       ),
//                       SizedBox(width: 5),
//                       Text(restaurants.location.crossStreet),
//                     ],
//                   ),

//                 ],
//               ),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }

class _FindRestaurantFormState extends State<FindRestaurantForm> {
  final _restaurantKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _search;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _restaurantKey,
            autovalidate: _autoValidate,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Enter Search',
                      border: OutlineInputBorder(),
                      filled: true,
                      errorStyle: TextStyle(fontSize: 15)),
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a search restaurant/food';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300.00,
                  child: RawMaterialButton(
                      onPressed: () {
                        final isValid = _restaurantKey.currentState.validate();

                        if (isValid) {
                          widget.onSearch(_search);
                          FocusManager.instance.primaryFocus.unfocus();
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
                      fillColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ))),
                )
              ],
            )));
  }
}
