// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:mantoo/pages/add_item.dart';
// import 'package:mantoo/res/custom_color.dart';
// import 'package:mantoo/widget/app_bar_title.dart';
// import 'package:mantoo/widget/item_list.dart';
// import 'package:http/http.dart' as http;

// class DashboardScreen extends StatefulWidget {
//   final User uid;

//   const DashboardScreen({Key? key, required this.uid}) : super(key: key);
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   late String? _token;
//   // // Crude counter to make messages unique
//   int _messageCount = 0;

//   /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
//   String constructFCMPayload(String token) {
//     _messageCount++;
//     return jsonEncode({
//       'token': token,
//       'data': {
//         'via': 'FlutterFire Cloud Messaging!!!',
//         'count': _messageCount.toString(),
//       },
//       'notification': {
//         'title': 'Hello FlutterFire!',
//         'body': 'This notification (#$_messageCount) was created via FCM!',
//       },
//     });
//   }

//   getToken() async {
//     _token = await FirebaseMessaging.instance.getToken();
//   }

//   void initialized() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//   }

//   // @override
//   void initState() {
//     initialized();
//     // getToken();
//     // FirebaseMessaging.instance
//     //     .getInitialMessage()
//     //     .then((RemoteMessage? message) {
//     //   if (message != null) {
//     //     Navigator.pushNamed(context, '/message',
//     //         arguments: RemoteMessage(data: message.data));
//     //   }
//     // });
//     // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     //   RemoteNotification? notification = message.notification;
//     //   AndroidNotification? android = message.notification?.android;
//     //   if (notification != null && android != null) {
//     //     flutterLocalNotificationsPlugin.show(
//     //         notification.hashCode,
//     //         notification.title,
//     //         notification.body,
//     //         NotificationDetails(
//     //           android: AndroidNotificationDetails(
//     //             channel!.id,
//     //             channel!.name,
//     //             channel!.description,
//     //             //      one that already exists in example app.
//     //             icon: 'launch_background',
//     //           ),
//     //         ));
//     //   }
//     // });
//     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     //   print('A new onMessageOpenedApp event was published!');
//     //   Navigator.pushNamed(context, '/message',
//     //       arguments: RemoteMessage(data: message.data));
//     // });
//     super.initState();
//   }

//   Future<void> sendPushMessage() async {
//     if (_token == null) {
//       print('Unable to send FCM message, no token exists.');
//       return;
//     }

//     try {
//       await http.post(
//         Uri.parse('https://api.rnfirebase.io/messaging/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: constructFCMPayload(_token!),
//       );
//       print('FCM request for device sent!');
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> onActionSelected(String value) async {
//     switch (value) {
//       case 'subscribe':
//         {
//           print(
//               'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
//           await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
//           print(
//               'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
//         }
//         break;
//       case 'unsubscribe':
//         {
//           print(
//               'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
//           await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
//           print(
//               'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
//         }
//         break;
//       case 'get_apns_token':
//         {
//           if (defaultTargetPlatform == TargetPlatform.iOS ||
//               defaultTargetPlatform == TargetPlatform.macOS) {
//             print('FlutterFire Messaging Example: Getting APNs token...');
//             String? token = await FirebaseMessaging.instance.getAPNSToken();
//             print('FlutterFire Messaging Example: Got APNs token: $token');
//           } else {
//             print(
//                 'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
//           }
//         }
//         break;
//       default:
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.firebaseNavy,
//       appBar: AppBar(
//           elevation: 0,
//           backgroundColor: CustomColors.firebaseNavy,
//           title: AppBarTitle()),
//       // floatingActionButton: Builder(
//       //   builder: (context) => FloatingActionButton(
//       //     onPressed: sendPushMessage,
//       //     backgroundColor: Colors.white,
//       //     child: const Icon(Icons.send),
//       //   ),
//       // ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => AddItem(
//                 uid: widget.uid,
//               ),
//             ),
//           );
//         },
//         backgroundColor: CustomColors.firebaseOrange,
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 32,
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             bottom: 20.0,
//           ),
//           child:
//               // Column(
//               //   children: [
//               // MetaCard('Permissions', Permissions('pesan','')),
//               // MetaCard('FCM Token', TokenMonitor((token) {
//               //   _token = token;
//               //   return token == null
//               //       ? const CircularProgressIndicator()
//               //       : Text(token, style: const TextStyle(fontSize: 12));
//               // })),
//               // MetaCard('Message Stream', MessageList()),
//               ItemList(),
//           //   ],
//           // ),
//         ),
//       ),
//     );
//   }
// }

// /// UI Widget for displaying metadata.
// class MetaCard extends StatelessWidget {
//   final String _title;
//   final Widget _children;

//   // ignore: public_member_api_docs
//   MetaCard(this._title, this._children);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
//         child: Card(
//             child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(children: [
//                   Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child:
//                           Text(_title, style: const TextStyle(fontSize: 18))),
//                   _children,
//                 ]))));
//   }
// }
