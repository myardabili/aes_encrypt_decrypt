import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final storageRef = FirebaseStorage.instance
          .ref(destination); //Here the destination of the file is passed.

      return storageRef.putFile(file); // The file to be uploaded is passed.
    } on FirebaseException catch (e) {
      return null; // If any errors occur uploading is cancelled.
    }
  }
}
