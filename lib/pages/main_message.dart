import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mantoo/pages/message.dart';
import 'package:mantoo/res/custom_color.dart';
import 'package:mantoo/widget/app_bar_title.dart';
import 'package:mantoo/widget/main_message_list.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainMessage extends StatefulWidget {
  final User user;
  const MainMessage({Key? key, required this.user}) : super(key: key);

  @override
  _MainMessageState createState() => _MainMessageState();
}

class _MainMessageState extends State<MainMessage> {
  oneSignal() {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.
      var notification = result.notification.additionalData!;
      print('jumlah data: ' + notification.toString());
      final uid = notification['uid'];
      final uName = notification['uName'];
      final urId = notification['urId'];
      final urName = notification['urName'];
      final externalId = notification['externalId'];
      // final action = result.action!.actionId;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MessageScreen(
            user: uid,
            name: uName,
            receiverId: urId,
            receiverName: urName,
            externalId: externalId,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: AppBarTitle()),
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
