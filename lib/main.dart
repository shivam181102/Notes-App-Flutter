import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/Pages/OtpVerify.dart';
import 'package:notes/Pages/Register.dart';
import 'package:notes/Pages/editnote.dart';
import 'package:notes/Pages/homeComp.dart';
import 'package:notes/Pages/login.dart';
import 'package:notes/features/app/splash_screen/splash_screen.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/global/common/colorpalet.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  User? current;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
              selectionColor: mid2, selectionHandleColor: mid2)),
      home: SplashScreen(
        child: current != null ? const Homecomp() : Login(),
      ),
      routes: {
        'otpverify': (context) => Otpverify(),
        'login': (context) => Login(),
        'register': (context) => Register(),
        'home': (context) => const Homecomp(),
        'editnote': (context) => const Editnote(),
      },
    );
  }
}
