// ignore_for_file: unused_import, unused_local_variable, avoid_print
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:load_runner/main.dart';
import 'package:load_runner/model/firebase_api.dart';
import 'dart:convert';
import 'dart:io';
import 'package:load_runner/model/global_data.dart';

const String urlDriver = 'https://loadrunner12.herokuapp.com/api/driver';
UploadTask? s;
Future getUrl(File image) async {
  UploadTask s =
      FirebaseApi.uploadFile('images/$image', await File(image.path))!;
  final snapshot = await s.whenComplete(() => {});
  final url = await snapshot.ref.getDownloadURL();
  return url;
}

Future regsiterDetails() async {
  var file1 = profilePicture_Global;
  var frontAadhaar = aadharCardPhotoFront_Global;
  var backAadhaar = aadharCardPhotoBack_Global;
  var drivingPhoto = drivingLicensePhoto_Global;
  var panPhoto = panCardPhoto_Global;
  var vaccineCertificate = VaccinationCertificate_Global;
  var rcPhoto = rcPhoto_Global;
  var insurancePhoto = insurancePhoto_Global;
  var vehiclePhoto = vehiclePhotoFront_Global;
  var vehiclePhotoBack = vehiclePhotoBack_Global;
  var passbookPhoto = passBookPhoto_Global;
  String? token = await firebaseMessaging.getToken();

  const url = urlDriver + '/register';
  Uri uri = Uri.parse(url);
  http.Response response;
  var map = <String, dynamic>{};

  if (vehiclePhoto != null) {
    map['Vehicle_Photo_Url'] = await getUrl(vehiclePhoto);
  }
  if (vehiclePhotoBack != null) {
    map['Vehicle_Back_Photo_Url'] = await getUrl(vehiclePhotoBack);
  }
  if (file1 != null) {
    map['Profile_Photo_Url'] = await getUrl(file1);
  }
  if (frontAadhaar != null) {
    map['Adhar_Front_Url'] = await getUrl(frontAadhaar);
  }
  if (backAadhaar != null) {
    map['Adhar_Back_Url'] = await getUrl(backAadhaar);
  }
  if (drivingPhoto != null) {
    map['Driving_Photo_Url'] = await getUrl(drivingPhoto);
  }
  if (panPhoto != null) {
    map['Pan_Photo_Url'] = await getUrl(panPhoto);
  }
  if (vaccineCertificate != null) {
    map["Vaccination_Certificate_Url"] = await getUrl(vaccineCertificate);
  }
  if (rcPhoto != null) {
    map['RC_Photo_Url'] = await getUrl(rcPhoto);
  }
  if (insurancePhoto != null) {
    map['Insurance_Photo_Url'] = await getUrl(insurancePhoto);
  }

  if (passbookPhoto != null) {
    map['Pasbook_Photo_Url'] = await getUrl(passbookPhoto);
  }

  map['firstname'] = firstName_Global!.trim();
  map['lastname'] = lastName_Global!.trim();
  map['Referral_No'] = referralNumber_Global!.trim();
  map['Phone_No'] = phoneNumber_Global!.trim();
  map['Emergency_No'] = emergencyNumber_Global!.trim();
  map['Aadhar_No'] = aadharNumber_Global!.trim();
  map['Driving_License_No'] = drivingLicenseNumber_Global!.trim();
  map['PAN_No'] = panCardNumber_Global!.trim();
  map['VehicleType'] = vehicle!.trim();
  map['online'] = "Online".trim();
  map['password'] = password_Global!.trim();
  map['city'] = city!.trim();
  map['locality'] = locality_Global!.trim();
  map['Vehicle_Number'] = vehicleNumber_Global!.trim();
  map['Vehicle_RC_Number'] = rcNumber_Global!.trim();
  map['Vehicle_Insurance_Number'] = insuranceNumber_Global!.trim();

  map['Insurance_Expiry_Date'] = insuranceExpiryDate_Global!.trim();
  map['Account_Number'] = accountNumber_Global!.trim();
  map['Bank_Name'] = bankName_Global!.trim();
  map['IFSC_CODE'] = ifscCode_Global!.trim();
  map['type'] = vehicleType!.trim();
  map['fcm_token'] = token;
  print("FCM token: $token");
  response = await http.post(
    uri,
    body: map,
  );
  return response;
}

Future<http.Response?> loginDetails(String phoneNumber, String password) async {
  String? token = await firebaseMessaging.getToken();
  print("FCM token: $token");
  const url = urlDriver + '/login';
  Uri uri = Uri.parse(url);
  http.Response response;
  try {
    var map = <String, dynamic>{};
    map['Phone_No'] = phoneNumber;
    map['password'] = password;
    map['fcm_token'] = token;
    http.Response response = await http.post(
      uri,
      body: map,
    );
    return response;
  } catch (e) {
    print(e);
  }
}
