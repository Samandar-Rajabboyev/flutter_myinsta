import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';

class FileService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder_post = "post_images";
  static const folder_user = "user_images";

  static Future<String?> uploadUserImage(File _image) async {
    String? downloadUrl;
    String? uid = await Prefs.loadUserId();
    String? img_name = uid;
    Reference firebaseStorageRef = _storage.child(folder_user).child(img_name!);
    await firebaseStorageRef.putFile(_image).then((p0) async {
      if (p0.state == TaskState.success) {
        await firebaseStorageRef.getDownloadURL().then((url) {
          downloadUrl = url;
        });
      }
    });
    return downloadUrl;
  }

  static Future<String?> uploadPostImage(File _image) async {
    String? downloadUrl;
    String? uid = await Prefs.loadUserId();
    String img_name = "${uid}_${DateTime.now()}";
    Reference firebaseStorageRef = _storage.child(folder_post).child(img_name);
    firebaseStorageRef.putFile(_image).then((p0) async {
      if (p0.state == TaskState.success) {
        await firebaseStorageRef.getDownloadURL().then((url) {
          downloadUrl = url;
        });
      }
    });
    return downloadUrl;
  }
}
