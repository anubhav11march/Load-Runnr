// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_field, unused_import, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:load_runner/model/global_data.dart';
import 'package:load_runner/model/hexcolor.dart';
import 'package:load_runner/screens/home_pages/terms_privacy.dart';
import 'package:load_runner/screens/registration_pages/driver_registration.dart';
import 'package:relative_scale/relative_scale.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth? _auth;
  var errorMsg;
  bool isNotPresent = false;
  bool isLoading = false;
  String? verificationId;
  bool? _passwordVisible = false,
      _confirmPasswordVisible = false,
      _otpVisible = false;
  String terms = "https://loadrunnr.in/terms-and-conditions.php";
  String privacy = "https://loadrunnr.in/privacy-policy.php";
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool otpVerified = true, otpSend = true;
  bool? confirmNew = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> signInWithPhoneAuthCredential(
      AuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });

    try {
      final authCredential =
          await _auth!.signInWithCredential(phoneAuthCredential);
      setState(() {
        isLoading = false;
      });

      if (authCredential.user != null) {
        setState(() {
          otpVerified = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      print(FirebaseException);
      print("FirebaseException");
      print(_scaffoldKey);
      print(e);
      if (e.toString().contains("invalid.")) {
        buildErrorSnackbar(context, "OTP IS INVALID");
        // showAlert(context, "OTP IS INVALID");
      } else {
        buildErrorSnackbar(context, "OTP Is TimedOut");

        // showAlert(context, "OTP Is TimedOut");
      }
      // showAlert(context, e.toString());
      setState(() {
        isLoading = false;
      });
      if (_scaffoldKey.currentState != null) {
        _scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text(e.message!)));
        print(_scaffoldKey.currentState);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  bool isLoading1 = false;
  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, wdith, sy, sx) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Verification, For Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 100),
                      Text(
                        'Enter Phone Number and Verify with OTP',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                            labelText: 'Mobile Number',
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          controller: phoneNumber,
                        ),
                      ),
                      otpVerified
                          ? otpSend
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Center(
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (isLoading1) return;
                                          setState(() {
                                            isLoading1 = true;
                                          });

                                          checkPhone(phoneNumber.text);
                                          if (phoneNumber.text.length == 10 &&
                                              !confirmNew!) {
                                            await _auth!.verifyPhoneNumber(
                                              timeout:
                                                  Duration(milliseconds: 59000),
                                              phoneNumber:
                                                  "+91" + phoneNumber.text,
                                              verificationCompleted:
                                                  (phoneAuthCredential) async {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              },
                                              verificationFailed:
                                                  (verificationFailed) async {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                _scaffoldKey.currentState!
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        verificationFailed
                                                            .message!),
                                                  ),
                                                );
                                              },
                                              codeSent: (verificationId,
                                                  [resendingToken]) async {
                                                setState(() {
                                                  isLoading = false;
                                                  isLoading1 = false;
                                                  this.verificationId =
                                                      verificationId;
                                                });
                                              },
                                              codeAutoRetrievalTimeout:
                                                  (verificationId) async {},
                                            );
                                          }
                                          // setState(() {
                                          //   isLoading1 = false;
                                          // });
                                        },
                                        child: isLoading1
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                'Send OTP',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                        style: ElevatedButton.styleFrom(
                                          primary: HexColor('#FD6204'),
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 10),
                                      child: TextField(
                                        obscureText: !_otpVisible!,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xfffd6204)),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _otpVisible!
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _otpVisible = !_otpVisible!;
                                              });
                                            },
                                            iconSize: 30,
                                            color: Colors.black54,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          labelText: 'OTP',
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        keyboardType: TextInputType.number,
                                        controller: otp,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 20, 20, 20),
                                      child: Center(
                                        child: SizedBox(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (otp.text.isEmpty) {
                                                showAlert(context, "Enter Otp");
                                              } else {
                                                AuthCredential
                                                    phoneAuthCredential =
                                                    PhoneAuthProvider
                                                        .credential(
                                                            verificationId:
                                                                verificationId
                                                                    .toString(),
                                                            smsCode: otp.text);

                                                signInWithPhoneAuthCredential(
                                                    phoneAuthCredential);
                                              }
                                            },
                                            child: Text(
                                              'Verify OTP',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: HexColor('#FD6204'),
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'OTP Verification is successful',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      if (value.length < 6) {
                                        return 'Must be more than 6 charater';
                                      }
                                    },
                                    obscureText: !_passwordVisible!,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xfffd6204)),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible!
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible!;
                                          });
                                        },
                                        iconSize: 30,
                                        color: Colors.black54,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    controller: password,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      if (value.length < 6) {
                                        return 'Must be more than 6 charater';
                                      }
                                    },
                                    obscureText: !_confirmPasswordVisible!,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xfffd6204)),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _confirmPasswordVisible!
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _confirmPasswordVisible =
                                                !_confirmPasswordVisible!;
                                          });
                                        },
                                        iconSize: 30,
                                        color: Colors.black54,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    controller: confirmPassword,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Center(
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          password_Global = password.text;
                                          phoneNumber_Global = phoneNumber.text;
                                          if (password.text == "") {
                                            showAlert(
                                                context, "Password is empty");
                                          }
                                          if (password.text.length < 6 &&
                                              password.text.isNotEmpty) {
                                            showAlert(context,
                                                "Password length should be more than 6");
                                          }
                                          if (password.text !=
                                              confirmPassword.text) {
                                            buildErrorSnackbar(context,
                                                "Password and Confirm Password don't match");

                                            // showAlert(context, "Password and Confirm Password don't match");
                                          }
                                          if (password.text.length >= 6 &&
                                              password.text.isNotEmpty &&
                                              password.text ==
                                                  confirmPassword.text) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        DriverDetails()));
                                          }
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: HexColor('#FD6204'),
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontSize: sx(25),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: HexColor('#FD6204'),
                                fontSize: sx(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                      ),
                      Column(
                        children: [
                          Text(
                            "By Signing Up You Agree To Accept The",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => TermsAndPrivacy(
                                              terms, "Terms and Conditions")),
                                    );
                                  },
                                  child: Text(
                                    "Terms & Conditions",
                                    style: TextStyle(color: Color(0xfffd6206)),
                                  )),
                              Text("\ And\ "),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => TermsAndPrivacy(
                                              privacy, "Privacy and Policy")),
                                    );
                                  },
                                  child: Text("Privacy Policy",
                                      style:
                                          TextStyle(color: Color(0xfffd6206))))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void showAlert(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(text),
            ));
  }

  Future checkPhone(String Number) async {
    print(Number);
    String url = "https://loadrunner12.herokuapp.com/api/checkNumber";
    var jsonResponse;
    final msg = jsonEncode({"Phone_no": Number});
    var response = await http.get(Uri.parse(url + "/" + Number), headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
    });
    if (Number.length != 10) {
      buildErrorSnackbar(context, "Enter Valid Number");
    }
    if (response.statusCode == 409 && Number.length == 10) {
      jsonResponse = json.decode(response.body);
      print(confirmNew);
      if (jsonResponse['status'] == true) {
        setState(() {
          otpSend = true;
          isLoading = false;
        });
        buildErrorSnackbar(context, "Number Already Present");
      }
    }
    if (response.statusCode == 200 && Number.length == 10) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['status'] == false) {
          // }
          setState(() {
            confirmNew = true;
            isNotPresent = true;
          });
          setState(() {
            otpSend = false;
            isLoading = true;
          });
        }

        if (jsonResponse['error'] != null) {
          showAlert(context, jsonResponse['error']);
        }
        if (jsonResponse['data'] != null) {
          showAlert(context, "success");
        }
      }
    }
    return isNotPresent;

    // else {
    //   errorMsg = response.body;
    //   print("The error message is: ${response.body}");
    // }
  }

  buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      elevation: 0,
      width: 200,
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
        height: 40,
        child: Center(
            child: Text(
          message,
          textAlign: TextAlign.center,
        )),
      ),
      backgroundColor: (Colors.white.withOpacity(0)),
      // action: SnackBarAction(
      //   label: 'dismiss',
      //   onPressed: () {
      //   },
      // ),
    ));
  }
}
