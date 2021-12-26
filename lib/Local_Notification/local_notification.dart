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
        onDidReceiveLocalNotification: (i, j, k, l) async {
          return await true;
        });



const AndroidNotificationDetails firstNotificationAndroidSpecifics =
    AndroidNotificationDetails(
  "channel id",
  "channel name",
  "channel description",
  sound: RawResourceAndroidNotificationSound('whistlesound'),
  playSound: true,
  importance: Importance.high,
  priority: Priority.high,
);
const NotificationDetails firstNotificationPlatformSpecifics =
    NotificationDetails(android: firstNotificationAndroidSpecifics);

final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);

class LocalNotification {
  Future<void> initializeLocalNotificationSettings({bool changeNotification = false}) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  showNotification(RemoteNotification? _notification) async {
    await flutterLocalNotificationsPlugin.show(0, _notification!.title,
        _notification.body, firstNotificationPlatformSpecifics,
        payload: jsonEncode({"Data": "Got it."}));
  }
   show()async{
   await flutterLocalNotificationsPlugin.show(0, '',
        '', firstNotificationPlatformSpecifics,
        payload: jsonEncode({"Data": "Got it."}));
   }
  testNotification() async {
    await flutterLocalNotificationsPlugin.show(
        1, "Test", "Sound", firstNotificationPlatformSpecifics,
        payload: jsonEncode({"Data": "Got it."}));
  }
}
