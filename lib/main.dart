import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:load_runner/Local_Notification/local_notification.dart';
import 'package:load_runner/screens/ride_pages/pickup_page.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/registration_pages/signin_page.dart';
import 'package:app_settings/app_settings.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

LocalNotification localNotification = LocalNotification();

late SharedPreferences globalSharedPref;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('whistlesound'));

const AndroidNotificationDetails firstNotificationAndroidSpecifics =
    AndroidNotificationDetails(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.',
  sound: RawResourceAndroidNotificationSound('whistlesound'),
  playSound: true,
  importance: Importance.high,
  priority: Priority.high,
);

const NotificationDetails firstNotificationPlatformSpecifics =
    NotificationDetails(android: firstNotificationAndroidSpecifics);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// await flutterLocalNotificationsPlugin
//   .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//   ?.createNotificationChannel(channel);

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
          android: AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.',
        sound: RawResourceAndroidNotificationSound('whistlesound'),
        playSound: true,
        importance: Importance.high,
        priority: Priority.high,
      )),
      payload: jsonEncode({"Data": "Got it."}));
 // localNotification.showNotification(message.notification);
  print('background message ${message.notification!.body}');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  globalSharedPref = await SharedPreferences.getInstance();
  Future.delayed(Duration(seconds: 5), () async {
    await localNotification.initializeLocalNotificationSettings();
  });

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  // _notificationHandler();
  FirebaseMessaging.onMessage.listen((event) async {
    localNotification.showNotification(event.notification);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((snapshot) {
    //Calls when the notification is been clicked.
    // localNotification.notificationRoute(snapshot.data);
    localNotification.showNotification(snapshot.notification);
  });
  var status = prefs.getString('status');
  var firstname = prefs.getString('firstname');
  var Phone_No = prefs.getString('Phone_No');
  var token2 = prefs.getString('token2');
  var lastname = prefs.getString('lastname');
  var _id = prefs.getString('_id');
  var Profile_Photo = prefs.getString('Profile_Photo');
  runApp(
    MaterialApp(
      home: _id == null
          ? SignInPage()
          : MapScreen(
              status,
              firstname,
              Phone_No,
              token2,
              lastname,
              _id,
              Profile_Photo,
            ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future NotificationPermissionMethod() async {
  PermissionStatus permissionStatus =
      await NotificationPermissions.requestNotificationPermissions(
          openSettings: true);
  if (permissionStatus.index == 1) {
    debugPrint("Granted");
  }
}

void _notificationHandler() {
  FirebaseMessaging.onMessage.listen((snapshot) async {
    //Calls when the app is in foreground and notification is received.
    localNotification.showNotification(snapshot.notification);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((snapshot) {
    //Calls when the notification is been clicked.
    // localNotification.notificationRoute(snapshot.data);
    //   localNotification.showNotification(snapshot.notification);
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
    // localNotification.showNotification(message.notification);
    return;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
    );
  }
}
