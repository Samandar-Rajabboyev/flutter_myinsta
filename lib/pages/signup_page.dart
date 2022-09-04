import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinsta/model/user_model.dart';
import 'package:flutter_myinsta/pages/signin_page.dart';
import 'package:flutter_myinsta/services/data_service.dart';

import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import '../services/utils_service.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'sign_up_page';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;

  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();

  // From Diyorbek Nizomiddinov to Everyone 06:15 AM
  dosign_up() async {
    String name = fullnameController.text.toString().trim();
    // String phone = phone_number_controller.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String code = cpasswordController.text.toString().trim();
    var emailVaidation = RegExp(r"^[A-z0-9.A-z0-9.!$%&'*+-/=?^_`{|}~]+@(g|e|G|E)mail+\.[A-z]+").hasMatch(email);
    var passwordVaidation = RegExp(r"^(?=.*[0-9])(?=.*[A-Z])(?=.*[.!#$@%&'*+/=?^_`{|}~-]).{8,}$").hasMatch(password);
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, name, email, password).then((value) => {
          print("checking"),
          check(value),
        });
  }

  check(dynamic value) async {
    if (value != null) {
      Navigator.pushNamed(context, HomePage.id);
    } else {
      Utils.fireToast("Ro'yxatdan o'tishda xatolik. Qayta urinib ko'ring.");
    }
    setState(() {
      isLoading = false;
    });
  }

  _doSignUp() async {
    String name = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = cpasswordController.text.toString().trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    if (cpassword != password) {
      Utils.fireToast("Password and confirm password does not match");
      return;
    }
    // email validation
    bool isEmail = Utils.emailValidation(email);
    if (!isEmail) {
      Utils.fireToast("invalid email");
      return;
    }
    // password validation
    bool isPassword = Utils.passwordValidation(cpassword);
    if (!isPassword) {
      Utils.fireToast("invalid password");
      return;
    }

    setState(() {
      isLoading = true;
    });
    print("ojkojkojkojkojkojojjkjokjok");
    UserModel user = UserModel(fullname: name, email: email, password: password);
    var value = await AuthService.signUpUser(context, name, email, password);
    _getFirebaseUser(user, value);
  }

  _getFirebaseUser(UserModel user, Map<String, User> map) async {
    setState(() {
      isLoading = false;
    });
    User? firebaseUser;
    print(map);
    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("ERROR_EMAIL_ALREADY_IN_USE")) Utils.fireToast("Email already in user");
      print(map);
      if (map.containsKey("ERROR")) Utils.fireToast("Try again later");
      return;
    }
    print("asda");
    firebaseUser = map["SUCCESS"];
    print("asda");
    if (firebaseUser == null) return;

    await Prefs.saveUserId(firebaseUser.uid);
    DataService.storeUser(user).then((value) {
      Navigator.pushReplacementNamed(context, HomePage.id);
    });
  }

  _callSignInPage() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
              Color.fromRGBO(252, 175, 69, 1),
              Color.fromRGBO(245, 96, 64, 1),
            ]),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Instagram",
                          style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: 'Billabong'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //#fullname
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white54.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: fullnameController,
                            decoration: const InputDecoration(
                              hintText: "Fullname",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 17.0, color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //#email
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white54.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 17.0, color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //#password
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white54.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 17.0, color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        //#cpassword
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white54.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            controller: cpasswordController,
                            decoration: const InputDecoration(
                              hintText: "Confirm Password",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 17.0, color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        //#signup
                        GestureDetector(
                          onTap: () => dosign_up(),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54.withOpacity(0.2), width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: _callSignInPage,
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
