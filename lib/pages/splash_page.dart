import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../services/prefs_service.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  static const String id = "splash_page";
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _initTime() {
    Timer(const Duration(seconds: 2), () {
      _callSignInPage();
    });
  }

  _callSignInPage() {
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _initNotification() {
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
    _firebaseMessaging.getNotificationSettings().asStream().listen((NotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print(token);
      Prefs.saveFCM(token!);
    });
  }

  @override
  initState() {
    super.initState();
    _initTime();
    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
            Color.fromRGBO(252, 175, 69, 1),
            Color.fromRGBO(245, 96, 64, 1),
          ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Expanded(
              child: Center(
                child: Text(
                  "Instagram",
                  style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: 'Billabong'),
                ),
              ),
            ),
            Text(
              "All rights reserved",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
