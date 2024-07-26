// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Database/SQFlite/noteslocaldatamanager.dart';
import 'package:notes/Database/firebase%20store/firestore.dart';
import 'package:notes/Pages/AddDrawer.dart';
import 'package:notes/Pages/ColorDrawer.dart';
import 'package:notes/global/common/ParseData.dart';
import 'package:notes/global/common/bottomdrawer.dart';

import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/models/NotesModel.dart';
import 'package:notes/global/models/colorDrawerModel.dart';

class Editnote extends StatefulWidget {
  const Editnote({super.key});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  FirebaseNotesDatamanager _firebaseNotesDatamanager =
      FirebaseNotesDatamanager();
  late NotesModel profile;
  late TextEditingController _titleControl;
  late TextEditingController _noteControl;
  JsonData datainit = JsonData();
  late Color backg = dark;

  late List<ColorClass> colorlist;
  @override
  void initState() {
    super.initState();

    _titleControl = TextEditingController();
    _noteControl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<dynamic, dynamic>) {
      final props = args as Map;
      profile = props['note'];
      _titleControl.text = profile.title ?? '';
      _noteControl.text = profile.body ?? '';
      backg = profile.color;
    } else {
      profile = new NotesModel(
          title: _titleControl.text, body: _noteControl.text, color: dark);
    }
  }

  NotesLocalDataManager _notesLocalDataManager = NotesLocalDataManager();
  void colorchange(Color tempcol) {
    setState(() {
      backg = tempcol;
      profile.color = tempcol;
    });
  }

  void _handleBackButtonPress() async {
    profile.title = _titleControl.text;
    profile.body = _noteControl.text;
    if (profile.id == null) {
      await _notesLocalDataManager.addNote(profile);
    } else {
      await _notesLocalDataManager.updateNote(profile);
      log('.........................................................');
    }

    Navigator.pushNamedAndRemoveUntil(
        context, "home", (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
    _titleControl.dispose();
    _noteControl.dispose();
    super.dispose();
  }

  String convertDate(DateTime curr) {
    return '${curr.toLocal().toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        _handleBackButtonPress();
        return;
      },
      child: Scaffold(
        backgroundColor: backg,
        appBar: AppBar(
          backgroundColor: mid,
          iconTheme: IconThemeData(color: light),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackButtonPress,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(0.0),
              child: IconButton(
                  onPressed: () {
                    profile.pin = !profile.pin;
                    setState(() {});
                  },
                  splashColor: light,
                  splashRadius: 40,
                  icon: Icon(
                      profile.pin ? Icons.push_pin : Icons.push_pin_outlined)),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: IconButton(
                splashRadius: 40,
                splashColor: light,
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  if (profile.id != null) {
                    await _notesLocalDataManager.deleteNote(profile.id);
                  }
                  Navigator.pushNamedAndRemoveUntil(
                      context, "home", (Route<dynamic> route) => false);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: IconButton(
                  onPressed: () {
                    profile.archive = !profile.archive;
                    setState(() {});
                  },
                  splashRadius: 40,
                  splashColor: light,
                  icon: Icon(profile.archive
                      ? Icons.archive
                      : Icons.archive_outlined)),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: mid,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            Bottomdrawer(height: 0, child: AddDrawer()),
                      );
                    },
                    icon: Icon(
                      Icons.add_box_outlined,
                      color: light,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Bottomdrawer(
                            height: 150,
                            child: Colordrawer(
                              updateColor: colorchange,
                            )),
                      );
                    },
                    icon: Icon(
                      Icons.color_lens_outlined,
                      color: light,
                    ),
                  )
                ],
              ),
              Text(
                "Edited ${profile?.editedAt != null ? convertDate(profile!.editedAt!) : " "}",
                style: TextStyle(color: light),
              ),
              Icon(
                Icons.more_vert,
                color: light,
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: _titleControl,
                cursorColor: light,
                style: TextStyle(
                    color: light, fontSize: 25, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(color: mid2, fontSize: 25),
                ),
                keyboardType: TextInputType.text,
              ),
              Expanded(
                child: TextField(
                  maxLines: null,
                  controller: _noteControl,
                  cursorColor: light,
                  style: TextStyle(color: light),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Note",
                    hintStyle: TextStyle(color: mid2, fontSize: 20),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
