import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotification {
  static Future<void> showNotification(RemoteMessage payload) async {
    // Parsing data notifikasi
    final dynamic data = jsonDecode(payload.data['data']);
    final dynamic notification = jsonDecode(payload.data['notification']);

    // Parsing ID Notifikasi
    final int idNotification = data['id'] != null ? int.parse(data['id']) : 1;

    // Daftar jenis notifikasi dari aplikasi.
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'BBD', 'Notification', 'All Notification is Here',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Menampilkan Notifikasi
    await flutterLocalNotificationsPlugin.show(idNotification,
        notification['title'], notification['body'], platformChannelSpecifics,
        payload: data['type']);
  }

  Future<void> notificationHandler(
      GlobalKey<NavigatorState> navigatorKey) async {
    // Pengaturan Notifikasi

    // AndroidInitializationSettings default value is 'app_icon'
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo_bbd_sm');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Handling notifikasi yang di tap oleh pengguna
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        // NavigatorNavigate().go(navigatorKey, payload);
      }
    });
  }
}
