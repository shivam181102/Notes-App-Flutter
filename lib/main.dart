import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/Pages/ArchiveComponent.dart';
import 'package:notes/Pages/OtpVerify.dart';
import 'package:notes/Pages/Register.dart';
import 'package:notes/Pages/editnote.dart';
import 'package:notes/Pages/homeComp.dart';
import 'package:notes/Pages/login.dart';
import 'package:notes/Providers/NoteProvider.dart';
import 'package:notes/Providers/SelectionProvider.dart';
import 'package:notes/features/app/splash_screen/splash_screen.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:provider/provider.dart';

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

  User? current;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Noteprovider(),),
        ChangeNotifierProvider(create: (context) => Selectionprovider(),)
      ],
      child: MaterialApp(
        initialRoute:'SplashScreen' ,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
                selectionColor: mid2, selectionHandleColor: mid2)),
      
        routes: {
          'SplashScreen': (context)=>SplashScreen(
          child: current != null ? const Homecomp() : Login(),
        ),
          'otpverify': (context) => Otpverify(),
          'login': (context) => Login(),
          'register': (context) => Register(),
          'home': (context) => const Homecomp(),
          'editnote': (context) =>  Editnote(),
          'archive': (context) => Archivecomponent(),
        },
      ),
    );
  }
}
