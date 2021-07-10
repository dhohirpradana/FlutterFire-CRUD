import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/pages/profile.dart';
import 'package:mantoo/res/custom_color.dart';

class AppBarTitle extends StatefulWidget {
  @override
  _AppBarTitleState createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        Row(
          children: [
            // IconButton(
            //   icon: Icon(
            //     Icons.message,
            //     color: CustomColors.firebaseOrange,
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //           builder: (context) => MainMessage(
            //                 user: user!,
            //               )
            //           // ProfilePage(
            //           //   user: user!,
            //           // ),
            //           ),
            //     );
            //   },
            // ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: CustomColors.firebaseOrange,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      user: user!,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
