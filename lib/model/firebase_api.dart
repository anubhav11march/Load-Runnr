import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi{
  static UploadTask? uploadFile(String destination, File data){
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      // print(file);
      return ref.putFile(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}