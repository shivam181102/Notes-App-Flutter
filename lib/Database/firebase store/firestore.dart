// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:notes/global/models/NotesModel.dart';

class FirebaseNotesDatamanager {
  static final FirebaseNotesDatamanager instance =
      FirebaseNotesDatamanager._constructor();
  User? currentUser;
  final String _NoteCollectionName = "notes";
  final String _NotesTitleName = "title";
  final String _NotesBodyName = "body";
  final String _NotesDeletName = "deleted";
  final String _NotesColorName = "noteColor";
  final String _NotesUserPinName = "isPin";
  final String _NotesUserArchiveName = "isArchive";
  final String _NotesUserIDName = "userId";
  final String _NotesEditedAtName = "editedAt";
  FirebaseNotesDatamanager._constructor() {
    setCurrentUser();
  }
  factory FirebaseNotesDatamanager() {
    return instance;
  }
  Future<void> setCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllNotes() async {
    return FirebaseFirestore.instance
        .collection(_NoteCollectionName)
        .where(_NotesUserIDName, isEqualTo: currentUser?.uid)
        .get();
  }

  Future deleteNote(String? id) async {
    try {
      if (id != null) {
        await FirebaseFirestore.instance
            .collection(_NoteCollectionName)
            .doc(id)
            .update({_NotesDeletName: true});
      }
    } catch (e) {}
  }

  Future updateNote(NotesModel note, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection(_NoteCollectionName)
          .doc(id)
          .update({
        _NotesTitleName: note.title,
        _NotesBodyName: note.body,
        _NotesEditedAtName: DateTime.now().millisecondsSinceEpoch,
        _NotesColorName: note.color.value,
        _NotesUserPinName: note.pin,
        _NotesUserArchiveName: note.archive,
        _NotesUserIDName: currentUser?.uid,
        _NotesDeletName: false,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String?> insertNote(NotesModel note) async {
    try {
      DocumentReference docref =
          await FirebaseFirestore.instance.collection(_NoteCollectionName).add({
        _NotesTitleName: note.title,
        _NotesBodyName: note.body,
        _NotesEditedAtName: DateTime.now().millisecondsSinceEpoch,
        _NotesColorName: note.color.value,
        _NotesUserPinName: note.pin,
        _NotesUserArchiveName: note.archive,
        _NotesUserIDName: currentUser?.uid,
        _NotesDeletName: false,
      });
      return docref.id;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
