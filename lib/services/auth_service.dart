import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';

import '../pages/signin_page.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<Map<String, User?>> signInUser(BuildContext context, String email, String password) async {
    Map<String, User?> map = {};

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User firebaseUser = _auth.currentUser!;
      if (kDebugMode) {
        print(firebaseUser.toString());
      }
      map.addAll({"SUCCESS": firebaseUser});
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      map.addAll({"ERROR": null});
    }
    return map;
  }

  static Future<Map<String, User?>> signUpUser(BuildContext context, String name, String email, String password) async {
    Map<String, User?> map = {};
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      map.addAll({"SUCCESS": user});
    } catch (error) {
      switch (error) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          map.addAll({"ERROR_EMAIL_ALREADY_IN_USE": null});
          break;
        default:
          map.addAll({"ERROR": null});
      }
    }
    return map;
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }
}
