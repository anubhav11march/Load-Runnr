import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:load_runner/screens/registration_pages/create_new_password_screen.dart';
import 'package:load_runner/screens/registration_pages/enter_otp_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController otp = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;

  bool _showCreateNewPassFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFFD6204),
        ),
        title: Text(
          "Number Verification",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // _topImage(),
                _forgotPasswordText(),
                SizedBox(
                  height: 20,
                ),
                _loginText(),
                SizedBox(
                  height: 40,
                ),
                _phoneNumberdWidget(),
                SizedBox(
                  height: 30,
                ),
                _otpWidget(),
                SizedBox(
                  height: 30,
                ),
                _loginButton(),
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
      padding: const EdgeInsets.only(left: 30.0, top: 50),
      child: RichText(
        text: TextSpan(
          text:
              "Forgot your password? Confirm your phone number to reset password",
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ),
    );
  }

  _loginText() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Text(
            'Forgot Password',
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        )
      ],
    );
  }

  _phoneNumberdWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 10, 10),
      child: TextField(
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfffd6204)),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              '+91',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
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
          labelText: 'Phone Number',
        ),
        style: TextStyle(
          color: Colors.black,
        ),
        keyboardType: TextInputType.number,
        controller: _phoneNumberController,
      ),
    );
  }

  _otpWidget() {
    return Visibility(
        visible: verificationId != null,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 10, 10),
          child: TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xfffd6204)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              labelStyle: TextStyle(
                color: Color(0xff4a4a4a),
                fontWeight: FontWeight.w600,
                fontSize: 15,
                letterSpacing: 1.2,
              ),
              labelText: 'Enter OTP',
            ),
            style: TextStyle(
              color: Colors.black,
            ),
            keyboardType: TextInputType.number,
            controller: otp,
          ),
        ));
  }

  _loginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: Color(0xFFFD6204),
                )),
            onPressed: () {
              getOtp();
            },
            color: Color(0xFFFD6204),
            textColor: Colors.white,
            child: Text(
              "Generate OTP",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getOtp() async {
    await _auth.verifyPhoneNumber(
      timeout: Duration(milliseconds: 59000),
      phoneNumber: "+91" + _phoneNumberController.text,
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          // isLoading = false;
        });
      },
      verificationFailed: (verificationFailed) async {
        setState(() {
          // isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verificationFailed.message!),
          ),
        );
      },
      codeSent: (verificationId, [resendingToken]) async {
        setState(() {
          // isLoading = false;
          // this.verificationId = verificationId;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreenForgotPassword(
                    phoneNumber: _phoneNumberController.text,
                    verificationId: verificationId.toString())));
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }
}
