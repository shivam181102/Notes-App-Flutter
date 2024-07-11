// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:notes/Pages/drawerComp.dart';
import 'package:notes/Pages/notecards.dart';
import 'package:notes/Pages/searchbar.dart';
import 'package:notes/global/common/colorpalet.dart';

class Homecomp extends StatefulWidget {
  const Homecomp({super.key});

  @override
  State<Homecomp> createState() => _HomecompState();
}

class _HomecompState extends State<Homecomp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool viewStyle = true;
  int selectedIndex = 1;
  void setIndex(int num) {
    setState(() {
      selectedIndex = num;
    });
  }

  void viewstyleChange() {
    setState(() {
      viewStyle = !viewStyle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: dark(),
      body: Column(
        children: [
          SearchBarComp(
            scaffoldKey: _scaffoldKey,
            viewStyle: viewStyle,
            viewStyleChange: viewstyleChange,
          ),
          Expanded(
              child: Notecards(
            viewStyle: viewStyle,
          ))
        ],
      ),
      drawer: Drawercomp(
        selectedIndex: selectedIndex,
        setIndex: setIndex,
      ),
      bottomNavigationBar: BottomAppBar(
        color: mid(),
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
                  color: light(),
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.brush,
                  color: light(),
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.mic_none,
                  color: light(),
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.image_outlined,
                  color: light(),
                ),
                onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0), // Adjust the gap here
        child: FloatingActionButton(
          backgroundColor: mid(),
          tooltip: 'Add New Note',
          onPressed: () {
            Navigator.pushNamed(context, 'editnote');
          },
          child: Icon(
            Icons.add,
            size: 50,
            color: light2(),
            weight: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
