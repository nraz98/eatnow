import 'package:EatNow/model/user_data.dart';
import 'package:EatNow/screen/authenticate/authenticate.dart';
import 'package:EatNow/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
