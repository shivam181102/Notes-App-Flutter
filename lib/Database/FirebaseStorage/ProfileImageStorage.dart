import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notes/Database/firebase%20store/firestore.dart';

class Profileimagestorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseNotesDatamanager _firebaseNotesDatamanager =
      FirebaseNotesDatamanager();
  Future<String> _uploadProfile(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask upload = ref.putData(file);
    TaskSnapshot snapshot = await upload;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future saveProfile({required Uint8List file}) async {
    try {
      if (file != null) {
        String imgURL = await _uploadProfile(
            _firebaseNotesDatamanager.currentUser!.uid, file);
        await _firebaseFirestore
            .collection("Users")
            .doc(_firebaseNotesDatamanager.currentUser?.uid)
            .set({"Profileurl": imgURL}, SetOptions(merge: true));
      }
    } catch (e) {}
  }

  Future<String> getUrl() async {
    DocumentSnapshot snapshot = await _firebaseFirestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapshot.exists) {
      return await snapshot.get("Profileurl");
    } else {
      return '';
    }
  }
}
