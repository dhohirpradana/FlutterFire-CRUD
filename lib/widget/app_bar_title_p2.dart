import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/res/custom_color.dart';

class AppBarTitleP2 extends StatefulWidget {
  @override
  _AppBarTitleP2State createState() => _AppBarTitleP2State();
}

class _AppBarTitleP2State extends State<AppBarTitleP2> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/firebase_logo.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'FlutterFire',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
        Text(
          " MANTOO",
          style: TextStyle(
            color: CustomColors.firebaseOrange,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
