import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:load_runner/screens/registration_pages/signin_page.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  const CreateNewPasswordScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _topImage(),
                _forgotPasswordText(),
                SizedBox(
                  height: 20,
                ),
                _resetPasswordText(),
                SizedBox(
                  height: 40,
                ),
                _newPasswordField(),
                SizedBox(
                  height: 30,
                ),
                _confirmPasswordField(),
                SizedBox(
                  height: 30,
                ),
                _resetPasswordWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topImage() {
    return Image(
      image: AssetImage(
        "assets/images/AppIcon.jpeg",
      ),
      height: 200,
      width: 500,
    );
  }

  _forgotPasswordText() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10),
      child: ListTile(
        leading: Icon(
          Icons.check,
          color: Colors.green,
        ),
        contentPadding: EdgeInsets.all(0),
        title: Text(
          "OTP has been verified, Please Create Password.",
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ),
    );
  }

  _resetPasswordText() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'Reset Password',
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        )
      ],
    );
  }

  _newPasswordField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TextField(
        obscureText: _newPasswordVisible,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfffd6204)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              !_newPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _newPasswordVisible = !_newPasswordVisible;
              });
            },
            iconSize: 30,
            color: Colors.black54,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2,
                style: BorderStyle.solid,
              )),
          labelStyle: TextStyle(
            color: Color(0xff4a4a4a),
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
          labelText: 'Password',
        ),
        style: TextStyle(
          color: Colors.black,
        ),
        keyboardType: TextInputType.text,
        controller: _newPassword,
      ),
    );
  }

  _confirmPasswordField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TextField(
        obscureText: _confirmPasswordVisible,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfffd6204)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              !_confirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
            iconSize: 30,
            color: Colors.black54,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2,
                style: BorderStyle.solid,
              )),
          labelStyle: TextStyle(
            color: Color(0xff4a4a4a),
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
          labelText: 'Confirm Password',
        ),
        style: TextStyle(
          color: Colors.black,
        ),
        keyboardType: TextInputType.text,
        controller: _confirmPassword,
      ),
    );
  }

  _resetPasswordWidget() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.pinkAccent)),
            onPressed: () async {
              if (_newPassword.text != "" && _confirmPassword.text != "") {
                if (_newPassword.text == _confirmPassword.text) {
                  _resetPasswordMethod();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Password does not match"),
                    ),
                  );
                }
              }
            },
            color: Color(0xFFFD6204),
            textColor: Colors.white,
            child: Text(
              "Reset Password",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _resetPasswordMethod() async {
    String api = "http://3.110.215.131:4000/api/driver/updatePassword";

    http.Response _response = await http.post(Uri.parse(api),
        body: json.encode(
            {"password": _newPassword.text, "Phone_No": widget.phoneNumber}),
        headers: {
          "Content-Type": "application/json",
        });
    var jsonResponse = json.decode(_response.body);
    if (_response.statusCode == 200 || _response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse["message"]),
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SignInPage(),
            ),
            (Route<dynamic> route) => false);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse["message"]),
        ),
      );
    }
  }

  void showInSnackBar(String value) {}
}
