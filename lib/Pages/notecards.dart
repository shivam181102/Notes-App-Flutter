// ignore_for_file: unnecessary_null_comparison, must_be_immutable
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:notes/Database/SQFlite/noteslocaldatamanager.dart';
import 'package:notes/Database/firebase%20store/firestore.dart';
import 'package:notes/Pages/NotesGridviewComponent.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/models/NotesModel.dart';

class NotesCardsDisplayComp extends StatefulWidget {
  bool viewStyle;
  Future<List<NotesModel>> dataFunction;
  NotesCardsDisplayComp(
      {super.key, required this.viewStyle, required this.dataFunction});

  @override
  State<NotesCardsDisplayComp> createState() => _NotesCardsDisplayCompState();
}

class _NotesCardsDisplayCompState extends State<NotesCardsDisplayComp> {
  NotesLocalDataManager _notesLocalDataManager = NotesLocalDataManager();

  @override
  void initState() {
    setinternet();
    super.initState();
  }

  void setinternet() async {
    await _notesLocalDataManager.initConnectivity();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.dataFunction,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: light),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: light,
            ),
          );
        }
        if (snapshot.data?.length == 0) {
          return Center(
            child: Text(
              "No Data Found",
              style: TextStyle(color: light),
            ),
          );
        }
        if (snapshot.hasData &&
            snapshot.data != null &&
            !snapshot.data!.isEmpty) {
          final data = snapshot.data!;

          return Notesgridviewcomponent(
              viewStyle: widget.viewStyle, snapData: data);
        }
        return Text("KNHVJHVKJBKJBJKBJKBK");
      },
    );
  }
}
