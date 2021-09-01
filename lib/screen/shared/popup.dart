import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupPreferences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: AlertDialog(
          title: Text(
            "You cannot use this function, please set your preferences!",
            style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w300,
                fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Icon(
            Icons.fastfood,
            color: Colors.orange,
            size: 75,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Set My Preferences',
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/my-preferences');
              },
            ),
          ],
        )));
  }
}

class Popup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: AlertDialog(
          title: Text(
            "Waiting for the location..., Please Make Sure Location is On!",
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          content: Icon(
            Icons.location_on,
            size: 40,
            color: Colors.orange,
          ),
        )));
  }
}
