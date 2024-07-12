import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/common/toast.dart';
import 'package:notes/user_auth/firebase_auth_implementation/firebase_auth_google.dart';
import 'package:notes/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  bool loader = false;
  bool spiner = false;
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };
  }

  FirebaseAuthServices _auth = FirebaseAuthServices();
  @override
  Widget build(BuildContext context) {
    void _login() {
      final Map<String, dynamic> data = toJson();
      print("User Login is $data");
    }

    const borders = OutlineInputBorder(
        borderSide:
            BorderSide(width: 10, color: Color.fromARGB(255, 47, 36, 30)),
        borderRadius: BorderRadius.all(Radius.circular(10)));
    return Scaffold(
      backgroundColor: dark(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        backgroundColor: dark(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Email Address",
                      style: TextStyle(
                          color: light2(),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 9,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ]),
                    child: TextField(
                      controller: emailController,
                      cursorColor: mid2(),
                      style: TextStyle(color: light()),
                      decoration: InputDecoration(
                          fillColor: mid(),
                          filled: true,
                          hintText: "Enter Email Address",
                          hintStyle: TextStyle(color: light()),
                          enabledBorder: borders,
                          focusedBorder: borders),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          color: light2(),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 9,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ]),
                    child: TextField(
                      style: TextStyle(color: light()),
                      controller: passwordController,
                      cursorColor: mid2(),
                      decoration: InputDecoration(
                          fillColor: mid(),
                          filled: true,
                          hintText: "Enter Password",
                          hintStyle: TextStyle(color: light()),
                          enabledBorder: borders,
                          focusedBorder: borders),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ButtonStyle(
                        // elevation: const WidgetStatePropertyAll(10),
                        shadowColor: const WidgetStatePropertyAll(
                            Color.fromARGB(112, 255, 255, 255)),
                        backgroundColor: WidgetStateProperty.all(mid()),
                        fixedSize: const WidgetStatePropertyAll(
                            Size(double.maxFinite, 45))),
                    child: loader
                        ? CircularProgressIndicator(
                            color: light(),
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                                color: light(),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        spiner = true;
                      });
                      await FirebaseAuthGoogle.signInWithGoogle(context);
                      setState(() {
                        spiner = false;
                      });
                    },
                    style: ButtonStyle(
                        // elevation: const WidgetStatePropertyAll(10),
                        shadowColor: const WidgetStatePropertyAll(
                            Color.fromARGB(112, 255, 255, 255)),
                        backgroundColor: WidgetStateProperty.all(mid()),
                        fixedSize: const WidgetStatePropertyAll(
                            Size(double.maxFinite, 45))),
                    child: spiner
                        ? CircularProgressIndicator(
                            color: light(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: light2(),
                              ),
                              Text(
                                "  SignIn with Google",
                                style: TextStyle(
                                    color: light2(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: const Text(
                          "Forgot\nPassword",
                          style: TextStyle(color: Colors.white60, fontSize: 15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, 'register'),
                        child: const Text(
                          "Don't have Account?\nRegister",
                          style: TextStyle(color: Colors.white60, fontSize: 15),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _signIn() async {
    setState(() {
      loader = true;
    });
    String password = passwordController.text;
    String email = emailController.text;
    final user = await _auth.signInWithEmailAndPassword(email, password);
    setState(() {
      loader = false;
    });
    if (user != null) {
      showToast(message: "Successful ");
      Navigator.pushNamedAndRemoveUntil(
          context, 'home', (Route<dynamic> route) => false);
    } else {
      print("Error: ");
    }
  }
}
