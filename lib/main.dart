// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:load_runner/screens/home_pages/home_page.dart';
import 'package:load_runner/screens/home_pages/s2.dart';

import 'package:load_runner/screens/home_pages/waller_screen.dart';
import 'package:load_runner/screens/ride_pages/pickup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/registration_pages/signin_page.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString('status', body["driver"]["status"].toString());
  // prefs.setString('firstname', body["driver"]["firstname"].toString());
  // prefs.setString('Phone_No', body["driver"]["Phone_No"].toString());
  // prefs.setString('token2', body["token2"].toString());
  // prefs.setString('lastname', body["driver"]["lastname"].toString());
  // prefs.setString('_id', body["driver"]["_id"].toString());
  // prefs.setString('Profile_Photo',     body["driver"]["Profile_Photo"].toString());
  var status = prefs.getString('status');
  var firstname = prefs.getString('firstname');
  var Phone_No = prefs.getString('Phone_No');
  var token2 = prefs.getString('token2');
  var lastname = prefs.getString('lastname');
  var _id = prefs.getString('_id');
  var Profile_Photo = prefs.getString('Profile_Photo');
  runApp(MaterialApp(
      home: Phone_No == null
          ? SignInPage()
          : MapScreen(status, firstname, Phone_No, token2, lastname, _id,
              Profile_Photo)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
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
