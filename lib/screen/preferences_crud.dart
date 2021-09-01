import 'package:EatNow/model/user_preferences.dart';
import 'package:EatNow/providers/preferences_provider.dart';
import 'package:EatNow/screen/authenticate/auth.dart';
import 'package:EatNow/screen/my_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPreferences extends StatefulWidget {
  final Preferences preferences;
  AddPreferences({this.preferences});
  @override
  _AddPreferenceState createState() => _AddPreferenceState();
}

class _AddPreferenceState extends State<AddPreferences> {
  final _crudKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String foodController,
      cultureController,
      defaultPreference,
      pFood,
      pCulture,
      myPrerferId;
  double ratingController;
  int priceController;
  String currentPriceLabel = 'Free';
  bool trendingController = false;
  bool weatherController = false;
  String defaultPreferences;
  String myRatingController;
  String name = '';
  String phone = '';
  bool error, sending, success;
  String msg;
  final List<int> price = [0, 1, 2, 3, 4];
  final List<double> rating = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7];
  final List<String> priceLabel = [
    'Free',
    'Inexpensive',
    'Moderate',
    'Expensive',
    'Very Expensive'
  ];
  List preferCulture = ['Local', 'Indian', 'Asian', 'Western', 'Anything'];
  List preferFood = [
    'Spicy',
    'Sour',
    'Bitter',
    'Anything',
  ];

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
          defaultPreference = datasnapshot.data()['defaultPreferences'];
          print(defaultPreference);
        });
      } else {
        setState(() {
          defaultPreference = null;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    sending = false;

    getDefaultValue();
    final preferencesProvider =
        Provider.of<AddProvider>(context, listen: false);
    if (widget.preferences != null) {
      nameController.text = widget.preferences.preferName;
      foodController = widget.preferences.perferFood;
      ratingController = widget.preferences.preferRating;
      priceController = widget.preferences.preferPrice;
      trendingController = widget.preferences.preferTrending;
      weatherController = widget.preferences.preferWeather;
      cultureController = widget.preferences.preferCulture;
      myPrerferId = widget.preferences.preferId;
      currentPriceLabel = priceLabel[priceController];
      preferencesProvider.loadAll(widget.preferences);
      myRatingController = ratingController.toStringAsFixed(1);
      ratingController = double.parse(myRatingController);

      for (int i = 0; i < preferFood.length; i++) {
        if (foodController == preferFood[i]) {
          pFood = preferFood[i];
        }
      }

      for (int i = 0; i < preferCulture.length; i++) {
        if (cultureController == preferCulture[i]) {
          pCulture = preferCulture[i];
        }
      }
    } else {
      preferencesProvider.loadAll(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final preferecesProvider = Provider.of<AddProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set My Preferences',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Form(
              key: _crudKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Preference Title",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0)),
                      ),
                      validator: (val) => val.isEmpty ? 'Enter a title' : null,
                      onChanged: (String value) {
                        preferecesProvider.changeName = value;
                      },
                      controller: nameController,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Text("Preference Food"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(19)),
                      child: DropdownButton(
                        hint: Text('Select the Options'),
                        dropdownColor: Colors.orange,
                        elevation: 4,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        isExpanded: true,
                        value: pFood,
                        style: TextStyle(color: Colors.black),
                        onChanged: (newValue) {
                          setState(() {
                            pFood = newValue;
                          });
                          preferecesProvider.changeFood = newValue;
                        },
                        items: preferFood.map((value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Text("Preference Food Culture"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(19)),
                      child: DropdownButton(
                        hint: Text('Select the Options'),
                        dropdownColor: Colors.orange,
                        elevation: 5,
                        icon: Icon(Icons.arrow_drop_down_circle),
                        isExpanded: true,
                        value: pCulture,
                        style: TextStyle(color: Colors.black),
                        onChanged: (newValue) {
                          setState(() {
                            pCulture = newValue;
                          });
                          preferecesProvider.changeCulture = newValue;
                        },
                        items: preferCulture.map((value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Text("Minimum Preference Rating Level"),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Slider(
                          value: (ratingController ?? 0),
                          activeColor: Colors.amber,
                          inactiveColor: Colors.orange,
                          min: 0.0,
                          max: 5.0,
                          divisions: 55,
                          label: "$ratingController",
                          onChanged: (val) {
                            setState(() {
                              myRatingController = val.toStringAsFixed(1);
                              ratingController =
                                  double.parse(myRatingController);
                            });
                            preferecesProvider.changeRating =
                                double.parse(myRatingController);
                          })),
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Text("Minimum Preference Price Level"),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Slider(
                          value: (priceController ?? 0).toDouble(),
                          activeColor: Colors.amber,
                          inactiveColor: Colors.orange,
                          min: 0,
                          max: 4,
                          divisions: 8,
                          label: "$currentPriceLabel",
                          onChanged: (val) {
                            setState(() {
                              priceController = val.round();
                              currentPriceLabel = priceLabel[priceController];
                            });
                            preferecesProvider.changePrice =
                                priceController.toInt();
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Trending restaurant',
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Switch(
                          value: trendingController,
                          activeColor: Colors.orange,
                          activeTrackColor: Colors.amber,
                          onChanged: (val) {
                            setState(() {
                              print('$val');
                              trendingController = val;
                            });
                            print('$val');
                            preferecesProvider.changeTrending = val;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Food Recommendation based on Weather',
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Switch(
                          value: weatherController,
                          activeColor: Colors.orange,
                          activeTrackColor: Colors.amber,
                          onChanged: (val) {
                            setState(() {
                              print('$val');
                              weatherController = val;
                            });
                            print('$val');
                            preferecesProvider.changeWeather = val;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      width: 300.0,
                      child: RaisedButton(
                        color: Colors.orange,
                        child: Text('Set Current Preference',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () async {
                          if (_crudKey.currentState.validate()) {
                            sending = true;
                            preferecesProvider.saveEntry();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyPreferences()));
                          }
                        },
                      )),
                  SizedBox(
                    width: 300.0,
                    child: (widget.preferences != null &&
                            myPrerferId != defaultPreference)
                        ? RaisedButton(
                            color: Colors.grey[700],
                            child: Text('Delete',
                                style: TextStyle(color: Colors.black)),
                            onPressed: () async {
                              preferecesProvider.removePreferences(
                                  widget.preferences.preferId,
                                  defaultPreference);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyPreferences()));
                            },
                          )
                        : Container(),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
