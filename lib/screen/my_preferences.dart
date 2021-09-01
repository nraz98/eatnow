import 'package:EatNow/model/user_preferences.dart';
import 'package:EatNow/providers/preferences_provider.dart';
import 'package:EatNow/screen/authenticate/auth.dart';
import 'package:EatNow/screen/main_drawer.dart';
import 'package:EatNow/screen/preferences_crud.dart';
import 'package:EatNow/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class MyPreferences extends StatefulWidget {
  @override
  _MyPreferencesState createState() => _MyPreferencesState();
}

class _MyPreferencesState extends State<MyPreferences> {
  final firestoreService = FirestoreService();
  User user;
  String defaultName = '';
  String defaultPreferences = '';

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
          defaultPreferences = datasnapshot.data()['defaultPreferences'];
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
    super.initState();
    getDefaultValue();
  }

  @override
  Widget build(BuildContext context) {
    final preferenceProvider = Provider.of<AddProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Preferences',
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
      body: StreamBuilder<List<Preferences>>(
          stream: preferenceProvider.preferencesData,
          builder: (context, snapshot) {
            return (snapshot?.data?.length == 0)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fastfood,
                          color: Colors.deepOrange,
                          size: 75,
                        ),
                        Text(
                          'No Preferences Found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.orange[300],
                                  gradient: LinearGradient(
                                      colors: [Colors.orange, Colors.amber],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.orange,
                                        blurRadius: 6,
                                        offset: Offset(0, 3)),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                top: 0,
                                child: CustomPaint(
                                  size: Size(100, 150),
                                ),
                              ),
                              Positioned.fill(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.black,
                                        size: 35,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "MY CURRENT PREFERENCES",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Avenir',
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            defaultName.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: 'Avenir',
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                              width: 200.0,
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.grey)),
                                                color: Colors.grey,
                                                child: Text(
                                                    'Go To My Restaurant',
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                onPressed: () async {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          '/my-restaurant');
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Expanded(
                          child: StreamBuilder<List<Preferences>>(
                              stream: preferenceProvider.preferencesData,
                              builder: (context, snapshot) {
                                return ListView.builder(
                                    itemCount: snapshot?.data?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Stack(
                                          children: <Widget>[
                                            (defaultPreferences ==
                                                    snapshot
                                                        .data[index].preferId)
                                                ? Container(
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      color: Colors.orange,
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.orange[700],
                                                            Colors.orange[200]
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors
                                                                .orange[200],
                                                            blurRadius: 12,
                                                            offset:
                                                                Offset(0, 9)),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      color: Colors.grey,
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.grey[850],
                                                            Colors.grey[400]
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 12,
                                                            offset:
                                                                Offset(0, 9)),
                                                      ],
                                                    ),
                                                  ),
                                            (defaultPreferences ==
                                                    snapshot
                                                        .data[index].preferId)
                                                ? Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    top: 0,
                                                    child: CustomPaint(
                                                        size: Size(130, 180),
                                                        painter:
                                                            CustomCardShapePainter(
                                                                16,
                                                                Colors.orange,
                                                                Colors.orange[
                                                                    200])),
                                                  )
                                                : Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    top: 0,
                                                    child: CustomPaint(
                                                        size: Size(130, 180),
                                                        painter:
                                                            CustomCardShapePainter(
                                                                16,
                                                                Colors.grey,
                                                                Colors.grey[
                                                                    400])),
                                                  ),
                                            Positioned.fill(
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddPreferences(
                                                                  preferences: snapshot
                                                                          .data[
                                                                      index])));
                                                },
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Icon(
                                                        Icons.fastfood,
                                                        color: (defaultPreferences ==
                                                                snapshot
                                                                    .data[index]
                                                                    .preferId)
                                                            ? Colors.white
                                                            : Colors.orange,
                                                        size: 35,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            snapshot.data[index]
                                                                    .preferName
                                                                    .toUpperCase() ??
                                                                "",
                                                            style: TextStyle(
                                                                color: (defaultPreferences ==
                                                                        snapshot
                                                                            .data[
                                                                                index]
                                                                            .preferId)
                                                                    ? Colors.grey[
                                                                        700]
                                                                    : Colors
                                                                        .orange,
                                                                fontFamily:
                                                                    'Avenir',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                    .perferFood ??
                                                                "",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Avenir',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                    .preferCulture ??
                                                                "",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Avenir',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          SizedBox(height: 7),
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .monetization_on,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              RatingBarIndicator(
                                                                rating: snapshot
                                                                    .data[index]
                                                                    .preferPrice
                                                                    .toDouble(),
                                                                itemBuilder: (context,
                                                                        index) =>
                                                                    Icon(
                                                                        Icons
                                                                            .attach_money,
                                                                        color: Colors
                                                                            .orange[900]),
                                                                itemCount: 4,
                                                                itemSize: 15.0,
                                                                direction: Axis
                                                                    .horizontal,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            snapshot.data[index]
                                                                .preferRating
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Avenir',
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          RatingBarIndicator(
                                                            rating: snapshot
                                                                .data[index]
                                                                .preferRating,
                                                            itemBuilder: (context,
                                                                    index) =>
                                                                Icon(Icons.star,
                                                                    color: Colors
                                                                            .orange[
                                                                        900]),
                                                            itemCount: 5,
                                                            itemSize: 15.0,
                                                            direction:
                                                                Axis.horizontal,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                    });
                              }))
                    ],
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPreferences()));
        },
      ),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
