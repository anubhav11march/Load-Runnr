// ignore_for_file: use_key_in_widget_constructors, must_call_super, avoid_unnecessary_containers, prefer_const_constructors, unused_import, avoid_print, sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:load_runner/invite_friends.dart';
import 'package:load_runner/order_screen.dart';
import 'package:load_runner/screens/home_pages/home_page.dart';
import 'package:load_runner/screens/home_pages/waller_screen.dart';
import 'package:load_runner/screens/registration_pages/signin_page.dart';
import 'package:load_runner/screens/ride_pages/wallet_page.dart';
import 'package:load_runner/screens/support_page.dart';
import 'package:location/location.dart';
import 'package:load_runner/screens/ride_pages/localWidgets/rolling_switch.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../earning_page.dart';

class MapScreen extends StatefulWidget {
  final String? status, name, number, token, lastname, id, profilePic;

  MapScreen(this.status, this.name, this.number, this.token, this.lastname,
      this.id, this.profilePic);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      playSound: true);
  BitmapDescriptor? myIcon;
  final Set<Marker> _markers = {};
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _message = '';
  late LocationData _currentPosition;
  late GoogleMapController mapController;
  Location location = Location();
  String? vehicleType, vehicleNumber;
  late GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);
  Timer? timer;
  double latitude = 0.0;
  int walletBalance = 0;
  double longitude = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Location _location = Location();

  void setcustomMarket() async {
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)), 'assets/images/locationP.png');
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
    setState(() {});
  }

  String? isStatus;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('A bg message just showed up :  ${message.messageId}');
  }

  late FirebaseMessaging messaging;

  Future<void> _messageHandler(RemoteMessage message) async {
    print('background message ${message.notification!.body}');
  }

  @override
  void initState() {
    isStatus = widget.status;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getStatus());
    getPayment();
    getDriverDetails();

    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print("Hello");
      print(value);
      print("Token");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    }); // getLocation();
    getLoc();
    setcustomMarket();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   _showBothDialogs();
    // });
  }

  bool sliderBool = false;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.status == "Pending") {
        _showCupertinoDialog(
            'Your Account is in Review will be approved within 24hrs');
      }
    });

    return Scaffold(
      key: _scaffoldKey,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.circular(50),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(widget.profilePic!),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Positioned(
                          top: 100,
                          left: 25,
                          child: Container(
                            height: 20,
                            width: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      color: Color(0xfffd6206), fontSize: 18),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Color(0xfffd6206),
                                  size: 15,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ))
                    ],
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name!.toUpperCase() +
                            "\ " +
                            widget.lastname!.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.id!.substring(0, 10) +
                            "\n" +
                            widget.id!.substring(11, widget.id!.length),
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        vehicleType != null ? vehicleType! : "",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        vehicleNumber != null ? vehicleNumber! : "",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xfffd6206),
              ),
            ),
            ListTile(
              leading: Icon(Icons.input, color: Color(0xfffd6206)),
              title: Text(
                'Home',
                style: TextStyle(color: Color(0xfffd6206)),
              ),
              onTap: () => {Navigator.pop(context)},
            ),
            ListTile(
              leading:
                  FaIcon(FontAwesomeIcons.cartPlus, color: Color(0xfffd6206)),
              title: Text(
                'Orders',
                style: TextStyle(color: Color(0xfffd6206)),
              ),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderScreen()))
              },
            ),
            ListTile(
              leading:
                  FaIcon(FontAwesomeIcons.moneyCheck, color: Color(0xfffd6206)),
              title: Text(
                'Earnings',
                style: TextStyle(color: Color(0xfffd6206)),
              ),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Earnings()))
              },
            ),
            ListTile(
              leading:
                  FaIcon(FontAwesomeIcons.wallet, color: Color(0xfffd6206)),
              title: Text(
                'Wallet',
                style: TextStyle(color: Color(0xfffd6206)),
              ),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Wallet2(
                              widget.name!,
                              widget.number!,
                              widget.token!,
                            ))).whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapScreen(
                              widget.status,
                              widget.name,
                              widget.number,
                              widget.token,
                              widget.lastname,
                              widget.id,
                              widget.profilePic)));
                });
              },
            ),
            ListTile(
              leading:
                  FaIcon(FontAwesomeIcons.trophy, color: Color(0xfffd6206)),
              title: Text(
                'Rewards',
                style: TextStyle(color: Color(0xfffd6206)),
              ),
              onTap: () => {
                // Navigator.push(
                //   context, new MaterialPageRoute(builder: (context) => Wallet2(widget.name!,widget.number!,widget.token!)))
              },
            ),
            ListTile(
              leading:
                  FaIcon(FontAwesomeIcons.shareAlt, color: Color(0xfffd6206)),
              title: Text(
                'Refer & Earn',
                style: TextStyle(color: Color(0xfffd6206)),
              ),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InviteFriends()))
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings,color:  Color(0xfffd6206)),
            //   title: Text('Pickup',style: TextStyle(
            //       color:  Color(0xfffd6206)
            //   ),),
            //   onTap: () => { Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => MyHomePageState()))},
            // ),
            // ListTile(
            //   leading: Icon(Icons.border_color),
            //   title: Text('Feedback'),
            //   onTap: () => {Navigator.of(context).pop()},
            // ),
            ListTile(
                leading: Icon(Icons.exit_to_app, color: Color(0xfffd6206)),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Color(0xfffd6206)),
                ),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  // prefs.setString('status', body["driver"]["status"].toString());
                  // prefs.setString('firstname', body["driver"]["firstname"].toString());
                  // prefs.setString('Phone_No', body["driver"]["Phone_No"].toString());
                  // prefs.setString('token2', body["token2"].toString());
                  // prefs.setString('lastname', body["driver"]["lastname"].toString());
                  // prefs.setString('_id', body["driver"]["_id"].toString());
                  // prefs.setString('Profile_Photo',     body["driver"]["Profile_Photo"].toString());
                  prefs.remove('status');
                  prefs.remove('Phone_No');
                  prefs.remove('firstname');
                  prefs.remove('token2');
                  prefs.remove('lastname');
                  prefs.remove('_id');
                  prefs.remove('Profile_Photo');

                  Navigator.of(context).pushAndRemoveUntil(
                    // the new route
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignInPage(),
                    ),

                    // this function should return true when we're done removing routes
                    // but because we want to remove all other screens, we make it
                    // always return false
                    (Route route) => false,
                  );
                }),
          ],
        ),
      ),
      // appBar: AppBar(
      //   title: Text("Map"),
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: SizedBox(
                        width: 50,
                        height: 30,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 5, top: 5, right: 5),
                              child: Column(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        color: Color.fromRGBO(253, 98, 4, 1)),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        color: Color.fromRGBO(253, 98, 4, 1)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Column(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        color: Color.fromRGBO(253, 98, 4, 1)),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        color: Color.fromRGBO(253, 98, 4, 1)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RollingSwitch.widget(
                      onChanged: (bool state) {
                        print('turned ${(state) ? 'on' : 'off'}');
                      },
                      rollingInfoRight: RollingWidgetInfo(
                        //icon: FlutterLogo(),
                        text: Text(
                          'ONLINE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        backgroundColor: Color.fromRGBO(253, 98, 4, 1),
                      ),
                      rollingInfoLeft: RollingWidgetInfo(
                        // icon: FlutterLogo(
                        //   style: FlutterLogoStyle.stacked,
                        // ),
                        backgroundColor: Color(0xff585454),
                        text: Text(
                          'OFFLINE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: 50,
                          height: 50,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Center(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SupportPage()));
                              },
                              child: Image.asset(
                                "assets/images/customer-service.png",
                                width: 27,
                                height: 27,
                              ),
                            )),
                          ),
                        ),
                        Text(
                          "SUPPORT",
                          style: TextStyle(fontSize: 8),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 740,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition, zoom: 15),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCupertinoDialog(String text) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('ALERT'),
            content: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('status');
                    prefs.remove('Phone_No');
                    prefs.remove('firstname');
                    prefs.remove('token2');
                    prefs.remove('lastname');
                    prefs.remove('_id');
                    prefs.remove('Profile_Photo');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => SignInPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text('LOGOUT')),
              // TextButton(
              //   onPressed: () {
              //     print('HelloWorld!');
              //   },
              //   child: Text('HelloWorld!'),
              // )
            ],
          );
        });
  }

  void _showCupertinoDialog1(String text) {
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('ALERT'),
            content: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, '/', (_) => false);
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Color(0xfffd6206)),
                  )),
            ],
          );
        });
  }

  void _showCupertinoDialog3(String text) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('ALERT'),
            content: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('status');
                    prefs.remove('Phone_No');
                    prefs.remove('firstname');
                    prefs.remove('token2');
                    prefs.remove('lastname');
                    prefs.remove('_id');
                    prefs.remove('Profile_Photo');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => Wallet2(
                                  widget.name.toString(),
                                  widget.number.toString(),
                                  widget.token.toString(),
                                )),
                        (Route<dynamic> route) => false);
                  },
                  child: Text('ADD MONEY')),
              // TextButton(
              //   onPressed: () {
              //     print('HelloWorld!');
              //   },
              //   child: Text('HelloWorld!'),
              // )
            ],
          );
        });
  }

  void _showCupertinoDialog2(String text) {
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('ALERT'),
            content: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Color(0xfffd6206)),
                  )),
              // TextButton(
              //   onPressed: () {
              //     print('HelloWorld!');
              //   },
              //   child: Text('HelloWorld!'),
              // )
            ],
          );
        });
  }

  drawerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId("1"),
          position: _initialcameraposition,
          icon: myIcon!,
        ));
      });
      print(myIcon.toString());
      DateTime now = DateTime.now();
    });
  }

  Future getDriverDetails() async {
    String url = "https://loadrunner12.herokuapp.com/api/payment/getBalance";
    try {
      var jsonResponse;
      var response = await http.get(
          Uri.parse(
              "https://loadrunner12.herokuapp.com/api/driver/vechile-info"),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Cookie': "token2=${widget.token}"
          });
      if (response.statusCode == 200) {
        print(response.body);
        jsonResponse = json.decode(response.body);
        setState(() {
          vehicleNumber = jsonResponse["Vehicle_Number"];
          vehicleType = jsonResponse["VehicleType"];
        });

        print("jsonResponse1");
        print(jsonResponse);
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      // print("Hello");
    }
  }

  Future getPayment() async {
    String url = "https://loadrunner12.herokuapp.com/api/payment/getBalance";
    try {
      var jsonResponse;
      var response = await http.get(
          Uri.parse(
              "https://loadrunner12.herokuapp.com/api/payment/getBalance"),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Cookie': "token2=${widget.token}"
          });
      if (response.statusCode == 200) {
        print("jsonResponse1");
        print(response.body);
        print("jsonResponse1");
        var cookies = response.headers['set-cookie'];
        if (cookies != null) {
          print(cookies);
        }
        jsonResponse = json.decode(response.body);
        if (jsonResponse['balance'] <= 10) {
          _showCupertinoDialog3("Recharge your wallet to accept orders");
        }
        setState(() {
          walletBalance = jsonResponse['balance'];
        });
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      // print("Hello");
    }
  }

  Future getStatus() async {
    try {
      var jsonResponse;
      final msg = jsonEncode({"Phone_No": widget.number});

      var response = await http.post(
          Uri.parse(
              "https://loadrunner12.herokuapp.com/api/checkApproved/driver/"),
          body: msg,
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (widget.status == "Pending") {
          if (jsonResponse["status"] == "Active") {
            Navigator.pop(context);
            _showCupertinoDialog1("Your Account Has Been Approved");
            Navigator.of(context, rootNavigator: true).pop();
            timer!.cancel();
            FirebaseMessaging.onMessage.listen((RemoteMessage event) {
              print("message recieved");
              print(event.notification!.body);
            });
          }
        }
      } else {
        return null;
      }
    } on TimeoutException catch (_) {}
  }

  Widget selT() {
    return Container();
  }

  _showBothDialogs() {
    _showCupertinoDialog(
        'Your Account is in Review will be approved within 24hrs');
    Future.delayed(Duration(seconds: 3), () {
      _showCupertinoDialog1("Your Account Has Been Approved");
    });
  }
}
