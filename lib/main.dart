// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:load_runner/Local_Notification/local_notification.dart';
import 'package:load_runner/screens/home_pages/home_page.dart';
import 'package:load_runner/screens/home_pages/s2.dart';

import 'package:load_runner/screens/home_pages/waller_screen.dart';
import 'package:load_runner/screens/ride_pages/pickup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/registration_pages/signin_page.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

LocalNotification localNotification = LocalNotification();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  localNotification.initializeLocalNotificationSettings();
  _notificationHandler();
  var status = prefs.getString('status');
  var firstname = prefs.getString('firstname');
  var Phone_No = prefs.getString('Phone_No');
  var token2 = prefs.getString('token2');
  var lastname = prefs.getString('lastname');
  var _id = prefs.getString('_id');
  var Profile_Photo = prefs.getString('Profile_Photo');
  runApp(MaterialApp(
      home: _id == null
          ? SignInPage()
          : MapScreen(status, firstname, Phone_No, token2, lastname, _id,
              Profile_Photo)));
}

void _notificationHandler() {
  FirebaseMessaging.onMessage.listen((snapshot) async {
    //Calls when the app is in foreground and notification is received.
    localNotification.showNotification(snapshot.notification);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((snapshot) {
    //Calls when the notification is been clicked.
    // localNotification.notificationRoute(snapshot.data);
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
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
