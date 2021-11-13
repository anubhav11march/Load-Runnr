// ignore_for_file: prefer_const_constructors, avoid_print, must_be_immutable

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:load_runner/model/firebase_api.dart';
import 'package:load_runner/model/hexcolor.dart';
import 'package:relative_scale/relative_scale.dart';
import 'dart:io';
import 'package:load_runner/screens/registration_pages/vehicle_registration.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/global_data.dart';

class DriverDetails extends StatefulWidget {
  const DriverDetails({Key? key}) : super(key: key);

  @override
  _DriverDetailsState createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  TextEditingController locality = TextEditingController();
  TextEditingController referralNumber = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController alternateNumber = TextEditingController();
  TextEditingController emergencyNumber = TextEditingController();
  TextEditingController aadharNumber = TextEditingController();
  TextEditingController drivingLicenseNumber = TextEditingController();
  TextEditingController panCardNumber = TextEditingController();
  bool profileImageAdded = false,
      aadharCardFrontImageAdded = false,
      aadharCardBackImageAdded = false,
      panCardImageAdded = false,
      drivingLicenseImageAdded = false,
      vaccineCertificateAdded = false;
  var errorMsg;
  String? isChoose;
  bool isLoading = false;
  bool? confirmNew;
  bool isPresent = false;
  bool _saving = false;
  bool isCameraSelected = false, isGallerySelected = false;
  File? profileImagePath,
      aadharCardFrontImagePath,
      aadharCardBackImagePath,
      drivingLicenseImagePath,
      panCardImagePath,
      changingValue,
      vaccineImagePath;

  final _city = [
    'Bangalore',
    'Mysore',
  ];
  String? _chosenCity = 'Bangalore';

  // _imgFromCamera(final _imageGet) async {
  //   final image = await ImagePicker().pickImage(
  //       source: ImageSource.camera
  //   );
  //
  //   setState(() {
  //     _image = image;
  //   });
  // }
  //
  // _imgFromGallery() async {
  //   File image = await  ImagePicker.pickImage(
  //       source: ImageSource.gallery, imageQuality: 50
  //   );
  //
  //   setState(() {
  //     _image = image;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, wdith, sy, sx) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Basic Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      child: SizedBox(
                                        child: profileImagePath != null
                                            ? CircleAvatar(
                                                backgroundImage: Image.file(
                                                        profileImagePath!)
                                                    .image,
                                                minRadius: 50,
                                                maxRadius: 50,
                                              )
                                            : CircleAvatar(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.add_a_photo,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      height: 1,
                                                    ),
                                                    Text(
                                                      'Profile Photo',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: Colors.white,
                                                minRadius: 50,
                                                maxRadius: 50,
                                              ),
                                      ),
                                      onTap: () {
                                        // _showPicker(context);
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return SafeArea(
                                                child: Container(
                                                  child: new Wrap(
                                                    children: <Widget>[
                                                      new ListTile(
                                                          leading: new Icon(Icons
                                                              .photo_library),
                                                          title: new Text(
                                                              'Photo Library'),
                                                          onTap: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            changingValue =
                                                                await pickImageFromGallery();
                                                            setState(() {
                                                              profileImagePath =
                                                                  changingValue;
                                                            });
                                                          }),
                                                      new ListTile(
                                                        leading: new Icon(
                                                            Icons.photo_camera),
                                                        title:
                                                            new Text('Camera'),
                                                        onTap: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          changingValue =
                                                              await clickImage();
                                                          setState(() {
                                                            profileImagePath =
                                                                changingValue;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.orange,
                                                ),
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
                                              labelText:
                                                  'Referral Number(Optional)',
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: referralNumber,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == "") {
                                                return 'Please enter name';
                                              }
                                            },
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.orange,
                                                ),
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
                                              labelText: 'First Name',
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            keyboardType: TextInputType.text,
                                            controller: firstName,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.orange,
                                                ),
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
                                              labelText: 'Last Name',
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            keyboardType: TextInputType.text,
                                            controller: lastName,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
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
                                  labelText: 'Alternate Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.number,
                                controller: alternateNumber,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
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
                                  labelText: 'Emgergency Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.number,
                                controller: emergencyNumber,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16.0),
                                            labelText: 'City',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        isEmpty: _chosenCity == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _chosenCity,
                                            isDense: true,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _chosenCity = newValue;
                                                state.didChange(newValue);
                                              });
                                            },
                                            items: _city.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
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
                                  labelText: 'Add Locality',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: locality,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aadhar Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                                  labelText: 'Aadhar Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 12,
                                controller: aadharNumber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DottedBorder(
                                color: Colors.black,
                                padding: EdgeInsets.all(10),
                                strokeWidth: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        child: SizedBox(
                                          child: aadharCardFrontImagePath !=
                                                  null
                                              ? Stack(
                                                  children: [
                                                    Image(
                                                      image: Image.file(
                                                              aadharCardFrontImagePath!)
                                                          .image,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              color:
                                                                  Colors.white),
                                                          child: Icon(
                                                            Icons.find_replace,
                                                            color: Color(
                                                                0xfffd6206),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  padding: EdgeInsets.all(10),
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
                                                      Text('Aadhar Front'),
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
                                                            leading: new Icon(Icons
                                                                .photo_library),
                                                            title: new Text(
                                                                'Photo Library'),
                                                            onTap: () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              changingValue =
                                                                  await pickImageFromGallery();
                                                              setState(() {
                                                                aadharCardFrontImagePath =
                                                                    changingValue;
                                                              });
                                                            }),
                                                        new ListTile(
                                                          leading: new Icon(Icons
                                                              .photo_camera),
                                                          title: new Text(
                                                              'Camera'),
                                                          onTap: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            changingValue =
                                                                await clickImage();
                                                            setState(() {
                                                              aadharCardFrontImagePath =
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
                                            aadharCardFrontImageAdded = true;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        child: SizedBox(
                                          child: aadharCardBackImagePath != null
                                              ? Stack(
                                                  children: [
                                                    Image(
                                                      image: Image.file(
                                                              aadharCardBackImagePath!)
                                                          .image,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              color:
                                                                  Colors.white),
                                                          child: Icon(
                                                            Icons.find_replace,
                                                            color: Color(
                                                                0xfffd6206),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  padding: EdgeInsets.all(10),
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
                                                      Text('Aadhar Back'),
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
                                                            leading: new Icon(Icons
                                                                .photo_library),
                                                            title: new Text(
                                                                'Photo Library'),
                                                            onTap: () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              changingValue =
                                                                  await pickImageFromGallery();
                                                              setState(() {
                                                                aadharCardBackImagePath =
                                                                    changingValue;
                                                              });
                                                            }),
                                                        new ListTile(
                                                          leading: new Icon(Icons
                                                              .photo_camera),
                                                          title: new Text(
                                                              'Camera'),
                                                          onTap: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            changingValue =
                                                                await clickImage();
                                                            setState(() {
                                                              aadharCardBackImagePath =
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
                                            aadharCardBackImageAdded = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Driving License Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                                  labelText: 'Driving License Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: drivingLicenseNumber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DottedBorder(
                                color: Colors.black,
                                padding: EdgeInsets.all(10),
                                strokeWidth: 1,
                                child: Center(
                                  child: GestureDetector(
                                    child: SizedBox(
                                      child: drivingLicenseImagePath != null
                                          ? Stack(
                                              children: [
                                                Image(
                                                  image: Image.file(
                                                          drivingLicenseImagePath!)
                                                      .image,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          color: Colors.white),
                                                      child: Icon(
                                                        Icons.find_replace,
                                                        color:
                                                            Color(0xfffd6206),
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
                                                  Text('Driving License'),
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
                                                        leading: new Icon(Icons
                                                            .photo_library),
                                                        title: new Text(
                                                            'Photo Library'),
                                                        onTap: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          changingValue =
                                                              await pickImageFromGallery();
                                                          setState(() {
                                                            drivingLicenseImagePath =
                                                                changingValue;
                                                          });
                                                        }),
                                                    new ListTile(
                                                      leading: new Icon(
                                                          Icons.photo_camera),
                                                      title: new Text('Camera'),
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        changingValue =
                                                            await clickImage();
                                                        setState(() {
                                                          drivingLicenseImagePath =
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
                                        drivingLicenseImageAdded = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PAN Card Details (Optional)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                                  labelText: 'PAN Card Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: panCardNumber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DottedBorder(
                                color: Colors.black,
                                padding: EdgeInsets.all(10),
                                strokeWidth: 1,
                                child: Center(
                                  child: GestureDetector(
                                    child: SizedBox(
                                      child: panCardImagePath != null
                                          ? Stack(
                                              children: [
                                                Image(
                                                  image: Image.file(
                                                          panCardImagePath!)
                                                      .image,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          color: Colors.white),
                                                      child: Icon(
                                                        Icons.find_replace,
                                                        color:
                                                            Color(0xfffd6206),
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
                                                  Text('PAN Card'),
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
                                                        leading: new Icon(Icons
                                                            .photo_library),
                                                        title: new Text(
                                                            'Photo Library'),
                                                        onTap: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          changingValue =
                                                              await pickImageFromGallery();
                                                          setState(() {
                                                            panCardImagePath =
                                                                changingValue;
                                                          });
                                                        }),
                                                    new ListTile(
                                                      leading: new Icon(
                                                          Icons.photo_camera),
                                                      title: new Text('Camera'),
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        changingValue =
                                                            await clickImage();
                                                        setState(() {
                                                          panCardImagePath =
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
                                        panCardImageAdded = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vaccination  Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //   child: TextFormField(
                            //     decoration: InputDecoration(
                            //       focusedBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(
                            //           color: Colors.orange,
                            //         ),
                            //       ),
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(10),
                            //           borderSide: BorderSide(
                            //             color: Colors.black54,
                            //             width: 2,
                            //             style: BorderStyle.solid,
                            //           )),
                            //       labelStyle: TextStyle(
                            //         color: Color(0xff4a4a4a),
                            //         fontWeight: FontWeight.w600,
                            //         fontSize: 15,
                            //         letterSpacing: 1.2,
                            //       ),
                            //       labelText: 'Driving License Number',
                            //     ),
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //     ),
                            //     keyboardType: TextInputType.text,
                            //     controller: drivingLicenseNumber,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DottedBorder(
                                color: Colors.black,
                                padding: EdgeInsets.all(10),
                                strokeWidth: 1,
                                child: Center(
                                  child: GestureDetector(
                                    child: SizedBox(
                                      child: vaccineImagePath != null
                                          ? Stack(
                                              children: [
                                                Image(
                                                  image: Image.file(
                                                          vaccineImagePath!)
                                                      .image,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          color: Colors.white),
                                                      child: Icon(
                                                        Icons.find_replace,
                                                        color:
                                                            Color(0xfffd6206),
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
                                                  Text('Vaccine Certificate'),
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
                                                        leading: new Icon(Icons
                                                            .photo_library),
                                                        title: new Text(
                                                            'Photo Library'),
                                                        onTap: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          changingValue =
                                                              await pickImageFromGallery();
                                                          setState(() {
                                                            vaccineImagePath =
                                                                changingValue;
                                                          });
                                                        }),
                                                    new ListTile(
                                                      leading: new Icon(
                                                          Icons.photo_camera),
                                                      title: new Text('Camera'),
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        changingValue =
                                                            await clickImage();
                                                        setState(() {
                                                          vaccineImagePath =
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
                                        drivingLicenseImageAdded = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                fontSize: sx(20),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: HexColor('#FD6204'),
                                  fontSize: sx(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                aadharNumber_Global = aadharNumber.text;
                                referralNumber_Global = referralNumber.text;
                                firstName_Global = firstName.text;
                                lastName_Global = lastName.text;
                                alternateNumber_Global = alternateNumber.text;
                                emergencyNumber_Global = emergencyNumber.text;
                                drivingLicenseNumber_Global =
                                    drivingLicenseNumber.text;
                                panCardNumber_Global = panCardNumber.text;
                                profilePicture_Global = profileImagePath;
                                aadharCardPhotoFront_Global =
                                    aadharCardFrontImagePath;
                                aadharCardPhotoBack_Global =
                                    aadharCardBackImagePath;
                                drivingLicensePhoto_Global =
                                    drivingLicenseImagePath;
                                panCardPhoto_Global = panCardImagePath;
                                VaccinationCertificate_Global =
                                    vaccineImagePath;
                                city = _chosenCity;
                                locality_Global = locality.text;
                                if (firstName.text == "") {
                                  showAlert(context, "Enter First name");
                                } else if (lastName.text == "") {
                                  showAlert(context, "Enter Last Name");
                                } else if (alternateNumber.text == "") {
                                  showAlert(context, "Enter Alternate number");
                                } else if (emergencyNumber.text == "") {
                                  showAlert(context, "Enter Emergency number");
                                } else if (locality.text == "") {
                                  showAlert(context, "Enter Locality");
                                } else if (aadharNumber.text == "") {
                                  showAlert(context, "Enter Aadhaar Number");
                                } else if (aadharNumber.text.length != 12) {
                                  showAlert(
                                      context, "Enter Valid Aadhaar Number");
                                } else if (aadharCardFrontImageAdded == false) {
                                  showAlert(context, "Add Aadhaar Front Image");
                                } else if (aadharCardBackImageAdded == false) {
                                  showAlert(context, "Add Aadhaar Back Image");
                                } else if (drivingLicenseNumber.text == "") {
                                  showAlert(
                                      context, "Add Driving License Number");
                                } else if (drivingLicenseNumber.text.length !=
                                    16) {
                                  showAlert(
                                      context, "Enter Valid Licence Number");
                                } else if (drivingLicenseImageAdded == false) {
                                  showAlert(
                                      context, "Add Driving License Image");
                                } else if (profileImagePath == null) {
                                  showAlert(context, "Add Profile Image");
                                } else if (vaccineImagePath == null) {
                                  showAlert(context, "Add Vaccine Certificate");
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              VehicleDetails()));
                                }
                              },
                              child: Text(
                                'Save Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: sx(20),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: HexColor('#FD6204'),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showAlert(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(text),
            ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        setState(() {
                          isCameraSelected = true;
                          isChoose = "Library";
                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      setState(() {
                        isChoose = "Camera";
                      });
                      isCameraSelected = true;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future checkDetails(String adhaar, license, pan) async {
    String url = "https://loadrunner12.herokuapp.com/api/alldriversDetails";
    var jsonResponse;
    final msg =
        jsonEncode({"Adhar_no": adhaar, "License_no": license, "Pan_no": pan});
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(confirmNew);
      if (jsonResponse['status'] == true) {
        setState(() {
          isLoading = false;
        });
        showAlert(context, "Number Already Present");
      }
    }
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['status'] == false) {
          // }
          setState(() {
            confirmNew = true;
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
  }

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
}
