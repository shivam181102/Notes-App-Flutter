import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/global/common/toast.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? current = FirebaseAuth.instance.currentUser;
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String uname) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(current?.uid)
          .set({'email': email, 'uname': uname, "userID": current?.uid});
      await _auth.signOut();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      showToast(message: "Error: ${e.code}");
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log("hello");

      return credential.user;
    } on FirebaseAuthException catch (e) {
      showToast(message: "Error: ${e.code}");
    }
  }
}
