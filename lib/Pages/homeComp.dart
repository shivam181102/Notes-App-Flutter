// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Database/SQFlite/noteslocaldatamanager.dart';
import 'package:notes/Database/firebase%20store/firestore.dart';
import 'package:notes/Pages/AllNotesComp.dart';
import 'package:notes/Pages/ArchiveComponent.dart';
import 'package:notes/Pages/drawerComp.dart';
import 'package:notes/Providers/NoteProvider.dart';

import 'package:notes/global/common/colorpalet.dart';
import 'package:provider/provider.dart';

class Homecomp extends StatefulWidget {
  const Homecomp({super.key});

  @override
  State<Homecomp> createState() => _HomecompState();
}

class _HomecompState extends State<Homecomp> {
  static Widget? _selectedScreen  ;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseNotesDatamanager _firebaseNotesDatamanager =
      FirebaseNotesDatamanager();

  static int selectedIndex = 1;
  void setIndex(int num) {
    switch (num) {
      case 3:
        _selectedScreen =  Archivecomponent();
        break;
      default:
        _selectedScreen = Allnotescomp();
    }
    setState(() {
      selectedIndex = num;
    });
  }

  @override
  void initState() {
    _firebaseNotesDatamanager.setCurrentUser();
    final noteProvider = Provider.of<Noteprovider>(context, listen: false);
    super.initState();
    noteProvider.setscaffoldKey(_scaffoldKey);
    setIndex(selectedIndex);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: true,
      backgroundColor: dark,
      body: _selectedScreen,
      drawer: Drawercomp(
        selectedIndex: selectedIndex,
        setIndex: setIndex,
      ),
    );
  }
}
