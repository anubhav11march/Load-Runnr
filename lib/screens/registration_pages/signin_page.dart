import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load_runner/model/api.dart';
import 'package:load_runner/model/hexcolor.dart';
import 'package:load_runner/screens/home_pages/terms_privacy.dart';
import 'package:load_runner/screens/registration_pages/signup_page.dart';
import 'package:load_runner/screens/ride_pages/pickup_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  bool? _passwordVisible = false;
  bool validatePhone = false;
  bool validatePassword = false;
  bool _saving = false;
  String terms = "https://loadrunnr.in/terms-and-conditions.php";
  String privacy = "https://loadrunnr.in/privacy-policy.php";

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Color(0xfffd6204),
        ),
        inAsyncCall: _saving,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: Image.asset("assets/images/SignIn.png")),
              Center(
                  child: Text(
                "DELIVERY PARTNER",
                style: TextStyle(
                    color: Color(0xfffd6206),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xfffd6204)),
                            ),
                            errorText: validatePhone == true
                                ? 'Enter Phone Number'
                                : null,
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
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: TextField(
                          obscureText: !_passwordVisible!,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xfffd6204)),
                            ),
                            errorText: validatePassword == true
                                ? 'Enter Password'
                                : null,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible!
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible!;
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
                          controller: password,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15.0, 0, 10.0, 0),
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(50, 30),
                                      alignment: Alignment.centerLeft),
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (phoneNumber.text.isEmpty) {
                                      setState(() {
                                        validatePhone = true;
                                      });
                                    } else {
                                      setState(() {
                                        validatePhone = false;
                                      });
                                    }
                                    if (password.text.isEmpty) {
                                      validatePassword = true;
                                    } else {
                                      validatePassword = false;
                                    }
                                    if (phoneNumber.text.length != 10 &&
                                        phoneNumber.text.isNotEmpty) {
                                      buildErrorSnackbar(
                                          context, "Enter Valid Phone Number");
                                    }

                                    if (phoneNumber.text.isNotEmpty &&
                                        password.text.isNotEmpty &&
                                        phoneNumber.text.length == 10) {
                                      _submit();
                                      var response = await loginDetails(
                                          phoneNumber.text, password.text);
                                      if (response!.statusCode == 401) {
                                        print(response.statusCode);
                                        var body = jsonDecode(response.body);
                                        print(body);
                                        print("hello");
                                        print(body["status"]);
                                        if (body['status'] == "false") {
                                          setState(() {
                                            _saving = false;
                                          });
                                          buildErrorSnackbar(context,
                                              "Phone Number and Password Does Not Match");
                                        }
                                        if (body['errorCode'] ==
                                            "INVALID_LOGIN") {
                                          setState(() {
                                            _saving = false;
                                          });
                                          // var isPresent = SignUpPage().createState().checkPhone(phoneNumber.text);
                                          buildErrorSnackbar(context,
                                              "Phone Number Not Present! SignUp");
                                        }
                                      }
                                      if (response.statusCode == 200) {
                                        print(response.body);
                                        var body = jsonDecode(response.body);
                                        if (body['success'] == true) {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString(
                                              'status',
                                              body["driver"]["status"]
                                                  .toString());
                                          await prefs.setString(
                                              'firstname',
                                              body["driver"]["firstname"]
                                                  .toString());
                                          await prefs.setString(
                                              'Phone_No',
                                              body["driver"]["Phone_No"]
                                                  .toString());
                                          await prefs.setString('token2',
                                              body["token2"].toString());
                                          await prefs.setString(
                                              'lastname',
                                              body["driver"]["lastname"]
                                                  .toString());
                                          await prefs.setString('_id',
                                              body["driver"]["_id"].toString());
                                          await prefs.setString(
                                              'Profile_Photo',
                                              body["driver"]["Profile_Photo"]
                                                  .toString());

                                          setState(() {
                                            _saving = false;
                                          });

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      MapScreen(
                                                          body["driver"]
                                                                  ["status"]
                                                              .toString(),
                                                          body["driver"]
                                                                  ["firstname"]
                                                              .toString(),
                                                          body["driver"]
                                                                  ["Phone_No"]
                                                              .toString(),
                                                          body["token2"]
                                                              .toString(),
                                                          body["driver"]
                                                                  ["lastname"]
                                                              .toString(),
                                                          body["driver"]["_id"]
                                                              .toString(),
                                                          body["driver"][
                                                                  "Profile_Photo"]
                                                              .toString())));
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    primary: HexColor('#FD6204'),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            primary: HexColor('#FD6204'),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUpPage()));
                          },
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showAlert(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(text),
            ));
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

  void _submit() {
    setState(() {
      _saving = true;
    });
    print('submitting to backend...');
  }
}

// Future check(String text1,text2) async{
 //    var response = await loginDetails(
 //        phoneNumber.text, password.text);
 //    check( phoneNumber.text,password.text);
 //    if (response!.statusCode == 200) {
 //      print(response.body);
 //      var body =
 //      jsonDecode(response.body);
 //      print(body);
 //      print("hello");
 //      print(body["status"]);
 //      if (body['success'] == true) {
 //        print(body);
 //      }
 //    }
 //  }
// class CustomWidgets {
//   CustomWidgets._();
//   static buildErrorSnackbar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
//       content: Container(
//         color: Colors.black,
//         child: Text("Error"),
//       ),
//       backgroundColor: (Colors.white),
//       // action: SnackBarAction(
//       //   label: 'dismiss',
//       //   onPressed: () {
//       //   },
//       // ),
//     ));
//   }}