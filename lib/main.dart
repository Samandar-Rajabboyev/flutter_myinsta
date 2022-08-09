import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/pages/home_page.dart';
import 'package:flutter_myinsta/pages/signin_page.dart';
import 'package:flutter_myinsta/pages/signup_page.dart';
import 'package:flutter_myinsta/pages/splash_page.dart';
import 'package:flutter_myinsta/services/prefs_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _callStartPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, stream) {
        if (stream.hasData) {
          Prefs.saveUserId(stream.data?.uid ?? '');
          return const SplashPage();
        } else {
          Prefs.removeUserId();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch, primarySwatch: Colors.deepOrange),
      home: _callStartPage(),
      routes: {
        SplashPage.id: (context) => const SplashPage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        HomePage.id: (context) => const HomePage(),
      },
    );
  }
}
