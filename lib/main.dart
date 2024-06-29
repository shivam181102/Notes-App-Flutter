import 'package:flutter/material.dart';
import 'package:notes/Pages/OtpVerify.dart';
import 'package:notes/Pages/Register.dart';
import 'package:notes/Pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        'otpverify': (context) => Otpverify(),
        'login': (context) => Login(),
        'register': (context) => Register()
      },
    );
  }
}
