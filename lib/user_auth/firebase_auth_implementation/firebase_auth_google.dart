  import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/global/common/toast.dart';

class FirebaseAuthGoogle {
  static signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignin = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignin.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushNamedAndRemoveUntil(
            context, 'home', (Route<dynamic> route) => false);
      }
    } catch (e) {
      showToast(message: "Some Error: $e");
     
      print("Some Error: $e");
    }
  }
}
