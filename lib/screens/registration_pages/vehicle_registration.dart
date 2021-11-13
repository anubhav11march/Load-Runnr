// ignore_for_file: prefer_const_constructors, avoid_print, unused_field, must_be_immutable

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load_runner/model/hexcolor.dart';
import 'package:load_runner/screens/registration_pages/bank_registration.dart';

import 'dart:io';
import 'package:load_runner/model/global_data.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({Key? key}) : super(key: key);

  @override
  _VehicleDetailsState createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final _vehicles = [
    "Motorcycle",
    "Scooter",
    "Three Wheeler(Ape)",
    "Tata Ace 7 feet",
    "Tata Ace 8 feet/Balereo",
    "Tata 407"
  ];
  final _type = [
    "open",
    "close",
    "Tarpaulin",
  ];

  String? _chosenVehicle = 'Motorcycle', _chosenType = 'open';
  TextEditingController rcNumber = TextEditingController();
  TextEditingController insuranceNumber = TextEditingController();
  TextEditingController insuranceExpiryDate = TextEditingController();
  TextEditingController vehicleNumber = TextEditingController();
  bool rcImageAdded = false,
      insuranceImageAdded = false,
      vehicleFrontImageAdded = false,
      vehicleBackImageAdded = false;

  File? rcImagePath,
      insuranceImagePath,
      vehicleFrontImagePath,
      changingValue,
      vehicleBackImagePath;
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              'Vehicle Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                                            labelText: 'Vehicle',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        isEmpty: _chosenVehicle == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _chosenVehicle,
                                            isDense: true,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _chosenVehicle = newValue;
                                                state.didChange(newValue);
                                              });
                                            },
                                            items:
                                                _vehicles.map((String value) {
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
                              child: SizedBox(
                                  width: double.infinity,
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16.0),
                                            labelText: 'Type',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5.0))),
                                        isEmpty: _chosenType == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _chosenType,
                                            isDense: true,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _chosenType = newValue;
                                                state.didChange(newValue);
                                              });
                                            },
                                            items: _type.map((String value) {
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
                                  labelText: 'Vehicle Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: vehicleNumber,
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
                                          child: vehicleFrontImagePath != null
                                              ? Stack(
                                                  children: [
                                                    Image(
                                                      image: Image.file(
                                                              vehicleFrontImagePath!)
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
                                                      Text('Vehicle Front'),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        onTap: () async {
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
                                                                vehicleFrontImagePath =
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
                                                              vehicleFrontImagePath =
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
                                            vehicleFrontImageAdded = true;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        child: SizedBox(
                                          child: vehicleBackImagePath != null
                                              ? Stack(
                                                  children: [
                                                    Image(
                                                      image: Image.file(
                                                              vehicleBackImagePath!)
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
                                                      Text('Vehicle Back'),
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
                                                                vehicleBackImagePath =
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
                                                              vehicleBackImagePath =
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
                                            vehicleBackImageAdded = true;
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
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
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
                                  labelText: 'Vehicle RC Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: rcNumber,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: DottedBorder(
                                color: Colors.black,
                                padding: EdgeInsets.all(10),
                                strokeWidth: 1,
                                child: GestureDetector(
                                  child: SizedBox(
                                    child: rcImagePath != null
                                        ? Stack(
                                            children: [
                                              Image(
                                                image: Image.file(rcImagePath!)
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
                                                      color: Color(0xfffd6206),
                                                    )),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            width: double.infinity,
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
                                                Text('Vehicle RC'),
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
                                                          rcImagePath =
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
                                                        rcImagePath =
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
                                      rcImageAdded = true;
                                    });
                                  },
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
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
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
                                  labelText: 'Vehicle Insurance Number',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: insuranceNumber,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: TextFormField(
                                onTap: () async {
                                  DateTime? date = DateTime.now();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));

                                  insuranceExpiryDate.text =
                                      date!.toIso8601String();
                                },
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
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color(0xff4a4a4a),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    letterSpacing: 1.2,
                                  ),
                                  labelText: 'Insurance Expiry Date',
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: insuranceExpiryDate,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: DottedBorder(
                                color: Colors.black,
                                padding: EdgeInsets.all(10),
                                strokeWidth: 1,
                                child: GestureDetector(
                                  child: SizedBox(
                                    child: insuranceImagePath != null
                                        ? Stack(
                                            children: [
                                              Image(
                                                image: Image.file(
                                                        insuranceImagePath!)
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
                                                      color: Color(0xfffd6206),
                                                    )),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            width: double.infinity,
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
                                                Text('Vehicle Insurance'),
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
                                                          insuranceImagePath =
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
                                                        insuranceImagePath =
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
                                      insuranceImageAdded = true;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      rcPhoto_Global = rcImagePath;
                      rcNumber_Global = rcNumber.text;
                      insuranceNumber_Global = insuranceNumber.text;
                      insuranceExpiryDate_Global = insuranceExpiryDate.text;
                      insurancePhoto_Global = insuranceImagePath;
                      vehiclePhotoFront_Global = vehicleFrontImagePath;
                      vehiclePhotoBack_Global = vehicleBackImagePath;
                      vehicleNumber_Global = vehicleNumber.text;
                      vehicle = _chosenVehicle;
                      vehicleType = _chosenType;
                      if (vehicleNumber.text == "") {
                        showAlert(context, "Enter Vehicle Number");
                      } else if (vehicleFrontImageAdded == false) {
                        showAlert(context, "Add Vehicle Front Image");
                      } else if (vehicleBackImageAdded == false) {
                        showAlert(context, "Add Vehicle Back Image");
                      } else if (rcNumber.text == "") {
                        showAlert(context, "Enter Rc Number");
                      } else if (rcImageAdded == false) {
                        showAlert(context, "Add RC Image");
                      } else if (insuranceNumber.text == "") {
                        showAlert(context, "Enter Insurance Number");
                      } else if (insuranceExpiryDate == false) {
                        showAlert(context, "Select Expiry Date");
                      } else if (insuranceImageAdded == false) {
                        showAlert(context, "Add Insurance Image");
                      } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => BankDetails(),
                        ),
                      );
                      }
                    },
                    child: Text(
                      'Register Vehicle',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
}
