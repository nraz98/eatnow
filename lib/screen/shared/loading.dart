import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitPouringHourglass(
              color: Colors.orange,
              size: 70.0,
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Please wait for a while...",
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
          ],
        )));
  }
}
