import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:load_runner/screens/registration_pages/create_new_password_screen.dart';
import 'package:otp_text_field/otp_text_field.dart';

class OTPScreenForgotPassword extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const OTPScreenForgotPassword(
      {Key? key, required this.phoneNumber, required this.verificationId})
      : super(key: key);

  @override
  _OTPScreenForgotPasswordState createState() =>
      _OTPScreenForgotPasswordState();
}

class _OTPScreenForgotPasswordState extends State<OTPScreenForgotPassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _enteredOTP = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFFD6204),
        ),
        title: Text(
          "Back",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20),
                  child: RichText(
                    text: TextSpan(
                      text: "Enter ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'OTP',
                          style: TextStyle(
                            color: Color(0xFFFD6204),
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: ' Sent To',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  )),
              Text(
                "+91${widget.phoneNumber}",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  onCompleted: (pin) {
                    _verifyOTP(pin);
                  },
                  onChanged: (otp) {
                    _enteredOTP = otp;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't Get OTP?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _getOtp();
                    },
                    child: Text(
                      " Resend",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFD6204),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: loginButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _verifyOTP(String otp) async {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);
    signInWithPhoneAuthCredential(phoneAuthCredential);
    return "OK";
  }

  Future<void> signInWithPhoneAuthCredential(
      AuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Enter Correct OTP"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Correct OTP"),
        ),
      );
    }
  }

  Widget loginButton() {
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
              ),
            ),
            onPressed: () {
              _verifyOTP(_enteredOTP);
            },
            color: Color(0xFFFD6204),
            textColor: Colors.white,
            child: Text(
              "NEXT",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getOtp() async {
    await _auth.verifyPhoneNumber(
      timeout: Duration(milliseconds: 59000),
      phoneNumber: "+91" + widget.phoneNumber,
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
        setState(() {});
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }
}
