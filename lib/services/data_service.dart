import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';

import '../model/user_model.dart';

class DataService {
  static final _firestore = FirebaseFirestore.instance;

  static String folder_users = 'users';

  static Future storeUser(UserModel user) async {
    user.uid = await Prefs.loadUserId();
    return _firestore.collection(folder_users).doc(user.uid).set(user.toJson());
  }

  static Future<UserModel> loadUser() async {
    String? uid = await Prefs.loadUserId();
    var value = await _firestore.collection(folder_users).doc(uid).get();
    UserModel user = UserModel.fromJson(value.data()!);
    return user;
  }

  static Future updateUser(UserModel user) async {
    user.uid = await Prefs.loadUserId();
    return _firestore.collection(folder_users).doc(user.uid).update(user.toJson());
  }

  static Future<List<UserModel>> searchUsers(String keyword) async {
    List<UserModel> users = [];
    String? uid = await Prefs.loadUserId();

    var querySnapshot = await _firestore.collection(folder_users).orderBy("email").startAt([keyword]).get();

    querySnapshot.docs.forEach((result) {
      UserModel newUser = UserModel.fromJson(result.data());
      if (newUser.uid != uid) {
        users.add(newUser);
      }
    });
    return users;
  }
}
