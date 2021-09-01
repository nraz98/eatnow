import 'package:EatNow/model/place.dart';
import 'package:EatNow/screen/main_drawer.dart';
import 'package:EatNow/screen/map_bestNearby.dart';
import 'package:EatNow/screen/shared/loading.dart';
import 'package:EatNow/screen/shared/popup.dart';
import 'package:EatNow/services/geolocator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchNearby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<PlaceMain>>>(context);
    final geoService = GeoLocatorService();

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Best Nearby",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            FlatButton.icon(
              label: Text(''),
              icon: Icon(Icons.home),
              onPressed: () async {
                Navigator.of(context).pushNamed('/home-screen');
              },
            )
          ],
        ),
        drawer: MainDrawer(),
        body: (currentPosition != null)
            ? Consumer<List<PlaceMain>>(
                builder: (_, places, __) {
                  return (places != null)
                      ? Column(
                          children: <Widget>[
                            Expanded(
                              child: (places.length > 0)
                                  ? ListView.builder(
                                      itemCount: places.length,
                                      itemBuilder: (context, index) {
                                        return FutureProvider(
                                          create: (context) =>
                                              geoService.getDistance(
                                                  currentPosition.latitude,
                                                  currentPosition.longitude,
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.orange,
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: new NetworkImage('https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&maxheight=100&key=AIzaSyC7kc7T93DYQ8ZmV9aJaVu-mNs1HCOx6rk&photoreference=' +
                                                                    places[index]
                                                                        .photos
                                                                        .first
                                                                        .photoReference)),
                                                          ))
                                                      : Container(
                                                          height: 100,
                                                          width: 100,
                                                          color: Colors
                                                              .orange[400],
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
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                            .green[
                                                                        900],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                'CLOSED',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .red[
                                                                        800],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                        SizedBox(
                                                          height: 3.0,
                                                        ),
                                                        Text(places[index]
                                                            .vicinity),
                                                        SizedBox(
                                                          height: 3.0,
                                                        ),
                                                        (places[index].rating !=
                                                                null)
                                                            ? Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  RatingBarIndicator(
                                                                    rating: places[
                                                                            index]
                                                                        .rating,
                                                                    itemBuilder: (context, index) => Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber),
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        10.0,
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
                                                          builder: (context,
                                                              meters, wiget) {
                                                            return (meters !=
                                                                    null)
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
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                            ),
                                          ),
                                        );
                                      })
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          ],
                        )
                      : Center(child: Loading());
                },
              )
            : Center(child: Popup()),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.map),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MapNearby()));
          },
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

  Image getImage(photoReference) {
    final response =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&maxheight=100&photoreference=$photoReference&key=$key';

    return Image.network(response);
  }
}
