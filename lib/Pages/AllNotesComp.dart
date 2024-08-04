import 'package:flutter/material.dart';
import 'package:notes/Database/SQFlite/noteslocaldatamanager.dart';
import 'package:notes/Pages/drawerComp.dart';
import 'package:notes/Pages/notecards.dart';
import 'package:notes/Pages/searchbar.dart';
import 'package:notes/global/common/colorpalet.dart';

class Allnotescomp extends StatefulWidget {
  Allnotescomp({
    super.key,
  });

  @override
  State<Allnotescomp> createState() => _AllnotescompState();
}

class _AllnotescompState extends State<Allnotescomp> {
  NotesLocalDataManager _notesLocalDataManager = NotesLocalDataManager();

  static bool viewStyle = true;
  void viewstyleChange() {
    setState(() {
      viewStyle = !viewStyle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      backgroundColor: dark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarComp(
            viewStyle: viewStyle,
            viewStyleChange: viewstyleChange,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Pinned",
              style: TextStyle(color: light),
            ),
          ),
          Expanded(
              child: NotesCardsDisplayComp(
            routeName: "home",
            viewStyle: viewStyle,
            dataFunction: _notesLocalDataManager.getPinData(),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Other",
              style: TextStyle(color: light),
            ),
          ),
          Expanded(
              flex: 1,
              child: NotesCardsDisplayComp(
                routeName: "home",
                viewStyle: viewStyle,
                dataFunction: _notesLocalDataManager.getData(),
              ))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: mid,
        shape: const AutomaticNotchedShape(
          ContinuousRectangleBorder(),
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(45)),
          ),
        ),
        notchMargin: 5.0, // Adjust the notch margin if needed
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.check_box_outlined,
                  color: light,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.brush,
                  color: light,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.mic_none,
                  color: light,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.image_outlined,
                  color: light,
                ),
                onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0), // Adjust the gap here
        child: FloatingActionButton(
          backgroundColor: mid,
          tooltip: 'Add New Note',
          onPressed: () {
            Navigator.pushNamed(context, 'editnote');
          },
          child: Icon(
            Icons.add,
            size: 50,
            color: light2,
            weight: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
