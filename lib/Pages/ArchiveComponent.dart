import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Database/SQFlite/noteslocaldatamanager.dart';
import 'package:notes/Pages/notecards.dart';
import 'package:notes/Pages/searchbar.dart';
import 'package:notes/Providers/NoteProvider.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/common/drawerButton.dart';
import 'package:provider/provider.dart';

class Archivecomponent extends StatefulWidget {
  const Archivecomponent({
    super.key,
  });

  @override
  State<Archivecomponent> createState() => _ArchivecomponentState();
}

class _ArchivecomponentState extends State<Archivecomponent> {
  NotesLocalDataManager _notesLocalDataManager = NotesLocalDataManager();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      backgroundColor: dark,
      appBar: AppBar(
        backgroundColor: dark,
        leading: DrawerbuttonComp(),
        title: Text(
          "Archive",
          style: TextStyle(color: light),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.grid_view_outlined,
              color: light,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: NotesCardsDisplayComp(
            routeName: "archive",
            viewStyle: true,
            dataFunction: _notesLocalDataManager.getArchiveData(),
          )),
        ],
      ),
    );
  }
}
