// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/global/models/NotesModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesLocalDataManager {
  static final NotesLocalDataManager instance =
      NotesLocalDataManager._constructor();
  NotesLocalDataManager._constructor();
  factory NotesLocalDataManager() {
    return instance;
  }
  static Database? _db;
  bool? InternetConnectivityStatus;
  final String _NoteTableName = "Notes";
  final String _NotesIDColumnName = "id";
  final String _NotesTitleColumnName = "title";
  final String _NotesBodyColumnName = "body";
  final String _NotesFirestoreIDColumnName = "firestoreID";
  final String _NotesSyncedColumnName = "synced";
  final String _NotesDeletColumnName = "deleted";
  final String _NotesColorColumnName = "noteColor";
  final String _NotesUserPinColumnName = "isPin";
  final String _NotesUserArchiveColumnName = "isArchive";
  final String _NotesUserIDColumnName = "userId";
  final String _NotesEditedAtColumnName = "editedAt";

  Future<void> initConnectivity() async {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result[0] == ConnectivityResult.mobile ||
          result[0] == ConnectivityResult.wifi) {
        log("Network Connected now");
        InternetConnectivityStatus = true;
      } else {
        InternetConnectivityStatus = false;
        log("Network disconnected");
      }
    });
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
        $_NotesEditedAtColumnName INTEGER NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  Future<List<NotesModel>> getData() async {
    final db = await dataBase;
    final data = await db.query(_NoteTableName,
        where:
            '$_NotesDeletColumnName = ? AND $_NotesUserArchiveColumnName = ? AND $_NotesUserPinColumnName = ?',
        whereArgs: [0, 0, 0]);
    List<NotesModel> mapdata = data
        .map((e) => NotesModel(
            id: e[_NotesIDColumnName] as int,
            title: e[_NotesTitleColumnName] as String,
            body: e[_NotesBodyColumnName] as String,
            pin: e[_NotesUserPinColumnName] == 1,
            archive: e[_NotesUserArchiveColumnName] == 1,
            color: Color(e[_NotesColorColumnName] as int),
            editedAt: DateTime.fromMillisecondsSinceEpoch(
                e[_NotesEditedAtColumnName] as int)))
        .toList();

    return mapdata;
  }

  Future<List<NotesModel>> getPinData() async {
    final db = await dataBase;
    final data = await db.query(_NoteTableName,
        where:
            '$_NotesDeletColumnName = ? AND $_NotesUserArchiveColumnName = ? AND $_NotesUserPinColumnName = ?',
        whereArgs: [0, 0, 1]);
    List<NotesModel> mapdata = data
        .map((e) => NotesModel(
            id: e[_NotesIDColumnName] as int,
            title: e[_NotesTitleColumnName] as String,
            body: e[_NotesBodyColumnName] as String,
            pin: e[_NotesUserPinColumnName] == 1,
            archive: e[_NotesUserArchiveColumnName] == 1,
            color: Color(e[_NotesColorColumnName] as int),
            editedAt: DateTime.fromMillisecondsSinceEpoch(
                e[_NotesEditedAtColumnName] as int)))
        .toList();

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
        _NotesUserIDColumnName: FirebaseAuth.instance.currentUser?.uid
      });
    }
  }

  Future<void> updateNote(NotesModel note) async {
    final db = await dataBase;
    try {
      // log(note.archive.toString());
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
    } catch (e) {}
  }

  Future<void> deleteNote(int? id) async {
    final db = await dataBase;
    try {
      await db.update(
          _NoteTableName, {_NotesDeletColumnName: 1, _NotesSyncedColumnName: 0},
          where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }
}
