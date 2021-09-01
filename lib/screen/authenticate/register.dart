import 'package:EatNow/screen/authenticate/auth.dart';
import 'package:EatNow/screen/shared/loading.dart';

import 'package:EatNow/screen/shared/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toogleView;
  Register({this.toogleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return (loading == true)
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: 10,
                              left: 20.0,
                              right: 20.0,
                            ),
                            child: Image.asset('assets/images/Logo_EatNow.png'),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "REGISTER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.orange[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: Form(
                                key: _formKey,
                                child: Column(children: <Widget>[
                                  TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          hintText: 'Email'),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) => val.isEmpty
                                          ? 'Enter an E-mail'
                                          : null,
                                      onChanged: (val) {
                                        setState(() {
                                          email = val;
                                        });
                                      }),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'Password'),
                                    obscureText: true,
                                    validator: (val) => val.length < 8
                                        ? 'Enter a Password (8 characters at least)'
                                        : null,
                                    onChanged: (val) {
                                      setState(() {
                                        password = val;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  SizedBox(
                                      width: 300.0,
                                      child: RaisedButton(
                                        color: Colors.orange,
                                        child: Text('Register',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic result = await _auth
                                                .registerWithEmailPass(
                                                    email, password);
                                            if (result == false) {
                                              setState(() {
                                                error =
                                                    'Please enter a valid Email or Password';
                                                loading = false;
                                              });
                                            } else {
                                              Navigator.of(context)
                                                  .pushNamed('/');
                                            }
                                          }
                                        },
                                      )),
                                  SizedBox(height: 10.0),
                                  Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14.0),
                                  ),
                                  SizedBox(height: 60),
                                  Text(
                                    'Click the grey button to Sign In!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                      width: 300.0,
                                      child: RaisedButton(
                                        color: Colors.grey,
                                        child: Text('SIGN IN',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          widget.toogleView();
                                        },
                                      )),
                                ]))),
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }
}
