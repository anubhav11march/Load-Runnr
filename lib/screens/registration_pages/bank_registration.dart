// ignore_for_file: prefer_const_constructors, avoid_print, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load_runner/model/api.dart';
import 'package:load_runner/model/hexcolor.dart';
import 'package:load_runner/screens/registration_pages/signin_page.dart';
import 'package:load_runner/screens/review_screen/review_screen.dart';
import 'package:load_runner/screens/ride_pages/pickup_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/global_data.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController ifscCode = TextEditingController();

  bool passBookImageAdded = false;
  bool _saving = false;
  late Timer _timer;

  File? passBookImagePath, changingValue;
  Future<File?> clickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return null;

      final imagePathTemporary = File(image.path);
      return imagePathTemporary;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      final imagePathTemporary = File(image.path);
      return imagePathTemporary;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Color(0xfffd6204),
        ),
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Bank Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
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
                            labelText: 'Account Number',
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.number,
                          controller: accountNumber,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
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
                            labelText: 'Bank Name',
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          controller: bankName,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
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
                            labelText: 'IFSC Code',
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          controller: ifscCode,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DottedBorder(
                              color: Colors.black,
                              padding: EdgeInsets.all(10),
                              strokeWidth: 1,
                              child: GestureDetector(
                                child: SizedBox(
                                  child: passBookImagePath != null
                                      ? Stack(
                                          children: [
                                            Image(
                                              image:
                                                  Image.file(passBookImagePath!)
                                                      .image,
                                              fit: BoxFit.fitWidth,
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      color: Colors.white),
                                                  child: Icon(
                                                    Icons.find_replace,
                                                    color: Color(0xfffd6206),
                                                  )),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(10),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: const [
                                              Icon(
                                                Icons.add_a_photo,
                                              ),
                                              Text('Bank Statement'),
                                            ],
                                          ),
                                        ),
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return SafeArea(
                                          child: Container(
                                            child: new Wrap(
                                              children: <Widget>[
                                                new ListTile(
                                                    leading: new Icon(
                                                        Icons.photo_library),
                                                    title: new Text(
                                                        'Photo Library'),
                                                    onTap: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      changingValue =
                                                          await pickImageFromGallery();
                                                      setState(() {
                                                        passBookImagePath =
                                                            changingValue;
                                                      });
                                                    }),
                                                new ListTile(
                                                  leading: new Icon(
                                                      Icons.photo_camera),
                                                  title: new Text('Camera'),
                                                  onTap: () async {
                                                    Navigator.of(context).pop();
                                                    changingValue =
                                                        await clickImage();
                                                    setState(() {
                                                      passBookImagePath =
                                                          changingValue;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });

                                  setState(() {
                                    passBookImageAdded = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () async {
                          bankName_Global = bankName.text;
                          accountNumber_Global = accountNumber.text;
                          ifscCode_Global = ifscCode.text;
                          passBookPhoto_Global = passBookImagePath;
                          if (accountNumber.text == "") {
                            showAlert(context, "Enter Account Number");
                          } else if (bankName.text == "") {
                            showAlert(context, "Enter Bank Name");
                          } else if (ifscCode.text == "") {
                            showAlert(context, "Enter IFSC Code");
                          } else if (passBookImageAdded == false) {
                            showAlert(context, "Add Passbook Image");
                          } else {
                            _submit();
                            _showCupertinoDialog2(
                                'Please wait while we upload your documents. It might take upto "4 minutes".');
                            var response = await regsiterDetails();
                            if (response.body != null) {
                              print(response);
                            }
                            print(response.statusCode);
                            print(response);
                            if (response.statusCode == 200) {
                              setState(() {
                                _saving = false;
                              });
                              final prefs =
                                  await SharedPreferences.getInstance();
                              var body = await jsonDecode(response.body);
                              if (body['success'] == true) {
                                await prefs.setString('status', "Pending");
                                await prefs.setString('firstname',
                                    body["driver"]["firstname"].toString());
                                await prefs.setString('Phone_No',
                                    body["driver"]["Phone_No"].toString());
                                await prefs.setString(
                                    'token2', body["token2"].toString());
                                await prefs.setString('lastname',
                                    body["driver"]["lastname"].toString());
                                await prefs.setString(
                                    '_id', body["driver"]["_id"].toString());
                                await prefs.setString('Profile_Photo',
                                    body["driver"]["Profile_Photo"].toString());
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                        "Pending",
                                        body['driver']["firstname"].toString(),
                                        body['driver']["Phone_No"].toString(),
                                        body['token2'].toString(),
                                        body["driver"]["lastname"].toString(),
                                        body["driver"]["_id"].toString(),
                                        body["driver"]["Profile_Photo"]
                                            .toString(),
                                      ),
                                    ),
                                    (Route<dynamic> route) => false);
                              }
                            }
                          }
                        },
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: HexColor('#FD6204'),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

  void _submit() {
    setState(() {
      _saving = true;
    });

    //Simulate a service call
    print('submitting to backend...');
    // new Future.delayed(new Duration(seconds: 15), () {
    //   setState(() {
    //     _saving = false;
    //   });
    // });
  }

  void _showCupertinoDialog2(String text) {
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Icon(Icons.cloud_upload),
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.7)),
              ),
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
}
