import 'package:EatNow/screen/authenticate/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  User user;

  Future<void> getUserData() async {
    final AuthService _auth = AuthService();
    User userData = await _auth.getCurrentUser();
    setState(() {
      user = userData;
    });
  }

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.orange,
            child: Center(
                child: Column(
              children: <Widget>[
                Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/people.png')))),
                user == null
                    ? Text('')
                    : Text(
                        '${user.email}',
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
              ],
            )),
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text(
              'My Restaurant',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/my-restaurant');
            },
          ),
          ListTile(
            leading: Icon(Icons.my_location),
            title: Text(
              'Best Nearby',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/best-nearby');
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text(
              'Search Nearby Location',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/search-restaurant');
            },
          ),
          ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(
                'Find Restaurant',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/find-restaurant');
              }),
          ListTile(
              leading: Icon(Icons.account_box),
              title: Text(
                'User Preferences',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/my-preferences');
              }),
          ListTile(
              title: RaisedButton(
                  color: Colors.grey,
                  onPressed: () async {
                    await _auth.signout();
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 18),
                  )))
        ]),
      ),
    );
  }
}
