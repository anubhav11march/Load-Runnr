import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String groupKey = 'com.android.example.WORK_EMAIL';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: (i, j, k, l) {
          print("hello world");
          return;
        });

const AndroidNotificationDetails firstNotificationAndroidSpecifics =
    AndroidNotificationDetails('5', "Miscellaneous",
        sound: RawResourceAndroidNotificationSound('whistlesound'),
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: "Miscellaneous");
const NotificationDetails firstNotificationPlatformSpecifics =
    NotificationDetails(android: firstNotificationAndroidSpecifics);

final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);

class LocalNotification {
  Future<void> initializeLocalNotificationSettings() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  showNotification(RemoteNotification? _notification) async {
    await flutterLocalNotificationsPlugin.show(0, _notification!.title,
        _notification.body, firstNotificationPlatformSpecifics,
        payload: jsonEncode({"Data": "Got it."}));
  }

  testNotification() async {
    await flutterLocalNotificationsPlugin.show(
        0, "Test", "Sound", firstNotificationPlatformSpecifics,
        payload: jsonEncode({"Data": "Got it."}));
  }
}
