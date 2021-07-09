import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/app_bar_title_p2.dart';
import 'package:mantoo/widget/main_message_list.dart';

class MainMessage extends StatefulWidget {
  final User user;
  const MainMessage({Key? key, required this.user}) : super(key: key);

  @override
  _MainMessageState createState() => _MainMessageState();
}

class _MainMessageState extends State<MainMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: AppBarTitleP2()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: MainMessageList(
            user: widget.user,
          ),
        ),
      ),
    );
  }
}
