// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/Database/databseInterface.dart';
import 'package:notes/Database/firebase%20store/firestore.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/models/NotesModel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesLocalDataManager implements Databseinterface {
  static final NotesLocalDataManager instance =
      NotesLocalDataManager._constructor();
  NotesLocalDataManager._constructor();

  factory NotesLocalDataManager() {
    return instance;
  }
  static Database? _db;
  bool InternetConnectivityStatus = false;
  final String _NoteTableName = "Notes";
  final String _NotesIDColumnName = "id";
  final String _NotesTitleColumnName = "title";
  final String _NotesBodyColumnName = "body";
  final String _NotesFirestoreIDColumnName = "firestoreID";
  final String _NotesSyncedColumnName = "synced";
  final String _NotesDeletColumnName = "deleted";
  final String _NotesDeletTimeColumnName = "deletedtime";
  final String _NotesDeletPermanentColumnName = "deletedPermanent";
  final String _NotesColorColumnName = "noteColor";
  final String _NotesUserPinColumnName = "isPin";
  final String _NotesUserArchiveColumnName = "isArchive";
  final String _NotesUserIDColumnName = "userId";
  final String _NotesEditedAtColumnName = "editedAt";
  int count = 0;
  FirebaseNotesDatamanager _firebaseNotesDatamanager =
      FirebaseNotesDatamanager();
  Future<void> initConnectivity() async {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result[0] == ConnectivityResult.mobile ||
          result[0] == ConnectivityResult.wifi) {
        log("Network Connected now");

        if (InternetConnectivityStatus == false) {
          synchDBwithFireBase();
        }
        InternetConnectivityStatus = true;
      } else {
        InternetConnectivityStatus = false;
        log("Network disconnected");
      }
    });
  }

  // Delete After 7 days
  Future<void> deleteAfterSevenDays() async {
    final db = await dataBase;
    final now = DateTime.now();
    final sevendays = now.subtract(Duration(days: 1)).millisecondsSinceEpoch;
    await db.delete(_NoteTableName, where: "$_NotesDeletTimeColumnName < ?" , whereArgs: [sevendays]);
    
  }
  Future synchDBwithFireBase() async {
    final db = await dataBase;

    // New Created Notes
    final newCreatedData = await db.query(_NoteTableName,
        where: "$_NotesFirestoreIDColumnName IS NULL");
    final notemodalList = await convertToNoteModel(newCreatedData);
    for (var i = 0; i < notemodalList.length; i++) {
      NotesModel element = notemodalList[i];
      String? fid = await _firebaseNotesDatamanager.insertNote(element);
      await db.update(_NoteTableName,
          {_NotesFirestoreIDColumnName: fid, _NotesSyncedColumnName: 1},
          where: 'id = ?', whereArgs: [element.id]);
    }
    // Permanent Deleted
    final parmanentDeleteData = await db.query(_NoteTableName, columns: [_NotesIDColumnName, _NotesFirestoreIDColumnName],
        where: "$_NotesDeletPermanentColumnName = ? AND $_NotesSyncedColumnName = ?", whereArgs: [1,0]);
      
    for (var i = 0; i < parmanentDeleteData.length; i++) {
      Map element = parmanentDeleteData[i];
      await _firebaseNotesDatamanager.parmanentdeleteNote(element['firestoreID'] as String);
      await db.delete(_NoteTableName,
          where: 'id = ?', whereArgs: [element["id"]]);
    }


    // Updated Notes
    final updateedNotes =
        await db.query(_NoteTableName, where: "$_NotesSyncedColumnName = 0");
    final notemodalList2 = convertToNoteModel(updateedNotes);
    for (var element in notemodalList2) {
      final fid = await db
          .query(_NoteTableName, where: 'id = ?', whereArgs: [element.id]);
      _firebaseNotesDatamanager.updateNote(
          element, fid[0][_NotesFirestoreIDColumnName] as String);
    }
    updateLocalDBFromFirebase();
  }

  Future<void> updateLocalDBFromFirebase() async {
    final db = await dataBase;

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firebaseNotesDatamanager.getAllNotes();
    for (var doc in snapshot.docs) {
      var firebaseNote = doc.data();
      var firestoreId = doc.id;

      final localNote = await db.query(
        _NoteTableName,
        where: "$_NotesFirestoreIDColumnName = ?",
        whereArgs: [firestoreId],
      );
      try {
        if (localNote.isNotEmpty) {
          await db.update(
            _NoteTableName,
            {
              _NotesUserIDColumnName: firebaseNote['userId'],
              _NotesTitleColumnName: firebaseNote['title'],
              _NotesBodyColumnName: firebaseNote['body'],
              _NotesColorColumnName: firebaseNote['noteColor'] ?? dark.value,
              _NotesFirestoreIDColumnName: firestoreId,
              _NotesSyncedColumnName: 1,
              _NotesDeletTimeColumnName : firebaseNote['deletedtime']?? 0,
              _NotesDeletColumnName: firebaseNote['deleted'] ? 1 : 0,
              _NotesUserPinColumnName: firebaseNote['isPin'] ? 1 : 0,
              _NotesUserArchiveColumnName: firebaseNote['isArchive'] ? 1 : 0,
              _NotesEditedAtColumnName: firebaseNote['editedAt'],
            },
            where: '$_NotesIDColumnName = ?',
            whereArgs: [localNote[0][_NotesIDColumnName]],
          );
        } else {
          await db.insert(
            _NoteTableName,
            {
              _NotesUserIDColumnName: firebaseNote['userId'],
              _NotesTitleColumnName: firebaseNote['title'],
              _NotesBodyColumnName: firebaseNote['body'],
              _NotesColorColumnName: firebaseNote['noteColor'] ?? dark.value,
              _NotesFirestoreIDColumnName: firestoreId,
              _NotesSyncedColumnName: 1,
              _NotesDeletColumnName: firebaseNote['deleted'] ? 1 : 0,
              _NotesUserPinColumnName: firebaseNote['isPin'] ? 1 : 0,
              _NotesUserArchiveColumnName: firebaseNote['isArchive'] ? 1 : 0,
              _NotesEditedAtColumnName: firebaseNote['editedAt'],
            },
          );
        }
      } catch (e) {
        log('Error updating local database: $e');
      }
    }
    
  }

  Future<Database> get dataBase async {
    if (_db != null) {
      return _db!;
    }
    _db = await _getDataBase();
    return _db!;
  }

  Future<Database> _getDataBase() async {
    final dbDirpath = await getDatabasesPath();
    final dbPath = join(dbDirpath, "master_db.db");
    final database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_NoteTableName (
        $_NotesIDColumnName INTEGER PRIMARY KEY,
        $_NotesUserIDColumnName TEXT ,
        $_NotesTitleColumnName TEXT ,
        $_NotesBodyColumnName TEXT,
        $_NotesColorColumnName INTEGER,
        $_NotesFirestoreIDColumnName TEXT,
        $_NotesSyncedColumnName INTEGER DEFAULT 0,
        $_NotesDeletColumnName INTEGER DEFAULT 0,
        $_NotesUserPinColumnName INTEGER DEFAULT 0,
        $_NotesUserArchiveColumnName INTEGER DEFAULT 0,
        $_NotesDeletPermanentColumnName INTEGER DEFAULT 0,
        $_NotesEditedAtColumnName INTEGER NOT NULL,
        $_NotesDeletTimeColumnName INTEGER
        )
        ''');
      },
    );
    return database;
  }

  Future<List<NotesModel>> getData() async {
    final db = await dataBase;
    final temp = await db.query(_NoteTableName);
    final data = await db.query(_NoteTableName,
        where:
            '$_NotesDeletColumnName = ? AND $_NotesUserArchiveColumnName = ? AND $_NotesUserPinColumnName = ? AND $_NotesUserIDColumnName = ?',
        whereArgs: [0, 0, 0, _firebaseNotesDatamanager.currentUser?.uid]);
        log("Data Received ..............................");
        print(data);
        log("..............................");
        print(temp);
    List<NotesModel> mapdata = convertToNoteModel(data);
    return mapdata;
  }

  Future<List<NotesModel>> getPinData() async {
    final db = await dataBase;
    final data = await db.query(_NoteTableName,
        where:
            '$_NotesDeletColumnName = ? AND $_NotesUserArchiveColumnName = ? AND $_NotesUserPinColumnName = ? AND $_NotesUserIDColumnName = ?',
        whereArgs: [0, 0, 1, _firebaseNotesDatamanager.currentUser?.uid]);
    List<NotesModel> mapdata = convertToNoteModel(data);

    return mapdata;
  }

  Future<List<NotesModel>> getArchiveData() async {
    final db = await dataBase;
    final data = await db.query(_NoteTableName,
        where:
            '$_NotesDeletColumnName = ? AND $_NotesUserArchiveColumnName = ? AND $_NotesUserIDColumnName = ?',
        whereArgs: [0, 1, _firebaseNotesDatamanager.currentUser?.uid]);
    List<NotesModel> mapdata = convertToNoteModel(data);

    return mapdata;
  }
  Future<List<NotesModel>> getDeletedData() async {
    final db = await dataBase;
    final data = await db.query(_NoteTableName,
        where:
            '$_NotesDeletColumnName = ?  AND $_NotesUserIDColumnName = ? AND $_NotesDeletPermanentColumnName = ?',
        whereArgs: [1,  _firebaseNotesDatamanager.currentUser?.uid, 0]);
        
    List<NotesModel> mapdata = convertToNoteModel(data);

    return mapdata;
  }

  Future<void> addNote(NotesModel note) async {
    final db = await dataBase;
    if (note.title != '' || note.body != "") {
      final id = await db.insert(_NoteTableName, {
        _NotesTitleColumnName: note.title,
        _NotesBodyColumnName: note.body,
        _NotesEditedAtColumnName: DateTime.now().millisecondsSinceEpoch,
        _NotesUserPinColumnName: note.pin ? 1 : 0,
        _NotesUserArchiveColumnName: note.archive ? 1 : 0,
        _NotesColorColumnName: note.color.value,
        _NotesUserIDColumnName: _firebaseNotesDatamanager.currentUser?.uid,
      });
      final data =
          await db.query(_NoteTableName, where: 'id = ?', whereArgs: [id]);
      if (InternetConnectivityStatus == true) {
        String? fid = await _firebaseNotesDatamanager.insertNote(note);
        await db.update(_NoteTableName,
            {_NotesFirestoreIDColumnName: fid, _NotesSyncedColumnName: 1},
            where: 'id = ?', whereArgs: [id]);
      }
    }
  }

  Future<void> updateNote(NotesModel note) async {
    final db = await dataBase;
    try {
      await db.update(
          _NoteTableName,
          {
            _NotesTitleColumnName: note.title,
            _NotesBodyColumnName: note.body,
            _NotesEditedAtColumnName: DateTime.now().millisecondsSinceEpoch,
            _NotesUserPinColumnName: note.pin ? 1 : 0,
            _NotesUserArchiveColumnName: note.archive ? 1 : 0,
            _NotesColorColumnName: note.color.value,
            _NotesSyncedColumnName: 0
          },
          where: 'id = ?',
          whereArgs: [note.id]);
      if (InternetConnectivityStatus == true) {


        final fid = await db
            .query(_NoteTableName, where: 'id = ?', whereArgs: [note.id]);


        _firebaseNotesDatamanager.updateNote(
            note, fid[0][_NotesFirestoreIDColumnName] as String);

            
        await db.update(_NoteTableName, {_NotesSyncedColumnName: 1},
            where: 'id = ?', whereArgs: [note.id]);
      }
    } catch (e) {}
  }

  Future<void> deleteNote(int? id) async {
    final db = await dataBase;
    try {
      await db.update(
          _NoteTableName, {_NotesDeletColumnName: 1, _NotesSyncedColumnName: 0, _NotesDeletTimeColumnName : DateTime.now().millisecondsSinceEpoch},
          where: 'id = ?', whereArgs: [id]);
      if (InternetConnectivityStatus == true) {
        final fid =
            await db.query(_NoteTableName, where: 'id = ?', whereArgs: [id]);
        _firebaseNotesDatamanager
            .deleteNote(fid[0][_NotesFirestoreIDColumnName] as String, fid[0][_NotesDeletTimeColumnName] as int);
        await db.update(_NoteTableName, {_NotesSyncedColumnName: 1},
            where: 'id = ?', whereArgs: [id]);
      }
    } catch (e) {}
  }
  Future<void> parmanentdeleteNote(List<NotesModel> list) async {
    final db = await dataBase;
    try {
      for (var element in list) {
        
      await db.update(
          _NoteTableName, {_NotesDeletPermanentColumnName: 1, _NotesSyncedColumnName: 0},
          where: 'id = ?', whereArgs: [element.id]);
      if (InternetConnectivityStatus == true) {
        final fid =
            await db.query(_NoteTableName, where: 'id = ?', whereArgs: [element.id]);
        _firebaseNotesDatamanager
            .parmanentdeleteNote(fid[0][_NotesFirestoreIDColumnName] as String);
        await db.delete(_NoteTableName,
            where: 'id = ?', whereArgs: [element.id]);
      }}
    } catch (e) {
      print(e.toString());
    }
  }

  List<NotesModel> convertToNoteModel(List<Map<String, Object?>> data) {
    return data
        .map((e) => NotesModel(
            id: e[_NotesIDColumnName] as int,
            title: e[_NotesTitleColumnName] as String,
            body: e[_NotesBodyColumnName] as String,
            pin: e[_NotesUserPinColumnName] == 1,
            archive: e[_NotesUserArchiveColumnName] == 1,
            color: Color(e[_NotesColorColumnName] as int),
            deleted: e[_NotesDeletColumnName] == 1,
            deletedtime: e[_NotesDeletTimeColumnName] != null? e[_NotesDeletTimeColumnName] as int: 0,
            editedAt: DateTime.fromMillisecondsSinceEpoch(
                e[_NotesEditedAtColumnName] as int)))
        .toList();
  }
}
/**                     
//  *                                            
 * 
 *                                  
 *        
 */