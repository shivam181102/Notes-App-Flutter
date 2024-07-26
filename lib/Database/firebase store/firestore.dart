// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/global/common/toast.dart';

class FirebaseNotesDatamanager {
  static final FirebaseNotesDatamanager instance =
      FirebaseNotesDatamanager._constructor();
  FirebaseNotesDatamanager._constructor();
  factory FirebaseNotesDatamanager() {
    return instance;
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllNotes() {
    User? user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection("notes")
        .where("uid", isEqualTo: user?.uid)
        .snapshots();
  }

  Future deleteNote(String? id) async {
    try {
      if (id != null) {
        await FirebaseFirestore.instance.collection("notes").doc(id).delete();
        showToast(message: "Deleted Succesfully");
      }
    } catch (e) {}
  }

  Future updateNote(String title, String body, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("notes")
          .doc(id)
          .update({'title': title, 'body': body, 'edit': DateTime.now()});
    } catch (e) {
      print(e);
    }
  }

  Future insertNote(String? title, String? body) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      if (title != "" || body != '') {
        DocumentReference docref = await FirebaseFirestore.instance
            .collection('notes')
            .add({
          "title": title,
          "body": body,
          "edit": DateTime.now(),
          "uid": user!.uid
        });
      }
      showToast(message: "Note Saved");
    } catch (e) {
      print(e);
    }
  }
}
