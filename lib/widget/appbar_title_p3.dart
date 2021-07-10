import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/res/custom_color.dart';

class AppBarTitleP3 extends StatefulWidget {
  final String nama;

  const AppBarTitleP3({Key? key, required this.nama}) : super(key: key);
  @override
  _AppBarTitleP3State createState() => _AppBarTitleP3State();
}

class _AppBarTitleP3State extends State<AppBarTitleP3> {
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
          widget.nama,
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
