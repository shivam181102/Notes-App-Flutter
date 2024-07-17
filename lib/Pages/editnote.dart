// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/firebase%20store/firestore.dart';
import 'package:notes/global/common/ParseData.dart';
import 'package:notes/global/common/bottomdrawer.dart';

import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/models/colorDrawer.dart';

class Editnote extends StatefulWidget {
  const Editnote({super.key});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  Map? profile;
  late TextEditingController _titleControl;
  late TextEditingController _noteControl;
  JsonData datainit = JsonData();
  Color? backg = dark();
  @override
  void initState() {
    super.initState();
    _titleControl = TextEditingController();
    _noteControl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profile = ModalRoute.of(context)?.settings.arguments as Map?;
    if (profile != null) {
      _titleControl.text = profile!["title"] ?? '';
      _noteControl.text = "${profile!["body"]}" ?? '';
      // backg = profile!.notecol;
    }
  }

  void colorchange(Color tempcol) {
    setState(() {
      if (profile != null) {
        backg = tempcol;
        // profile!.notecol = tempcol;
      }
    });
  }

  void _handleBackButtonPress() async {
    String Ttitle = _titleControl.text;
    String Tbody = _noteControl.text;
    if (profile?['id'] == null) {
      await FirestoreClass.insertNote(Ttitle, Tbody);
    } else {
      await FirestoreClass.updateNote(Ttitle, Tbody, profile!['id']);
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

  String convertDate(Timestamp curr) {
    int seconds = curr.seconds;
    int nanoseconds = curr.nanoseconds;
    DateTime dt =
        DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
    dt = dt.add(Duration(microseconds: (nanoseconds / 1000).round()));

    // Format the DateTime object to a string
    return DateFormat('dd-MM-yy HH:mm').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    Colordrawer colordrawer = Colordrawer(updateFun: colorchange);
    final colorlist = colordrawer.getColor();
    // print(profile!['edit'].seconds);
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
          backgroundColor: mid(),
          iconTheme: IconThemeData(color: light()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackButtonPress,
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.push_pin),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await FirestoreClass.deleteNote(profile?['id']);
                  Navigator.pushNamedAndRemoveUntil(
                      context, "home", (Route<dynamic> route) => false);
                },
              ),
            ),
            const Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.archive_outlined),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: mid(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => addBox(context),
                    icon: Icon(
                      Icons.add_box_outlined,
                      color: light(),
                    ),
                  ),
                  IconButton(
                    onPressed: () => showBottomDrawer(
                        context,
                        150,
                        Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Colour",
                                  style:
                                      TextStyle(color: light(), fontSize: 25),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 50,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            width: 15,
                                          ),
                                      itemCount: colorlist.length,
                                      itemBuilder: (context, index) {
                                        final res = colorlist[index];
                                        return GestureDetector(
                                          onTap: () => colordrawer
                                              .updateSelected(res.id),
                                          child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: res.clo,
                                                  border: res.selected
                                                      ? Border.all(
                                                          color: light(),
                                                          width: 3)
                                                      : null,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: res.selected
                                                  ? Icon(
                                                      Icons.check,
                                                      color: light(),
                                                    )
                                                  : null),
                                        );
                                      }),
                                )
                              ],
                            ))),
                    icon: Icon(
                      Icons.color_lens_outlined,
                      color: light(),
                    ),
                  )
                ],
              ),
              Text(
                "Edited ${profile?['edit'] != null ? convertDate(profile!['edit']) : " "}",
                style: TextStyle(color: light()),
              ),
              Icon(
                Icons.more_vert,
                color: light(),
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
                cursorColor: light(),
                style: TextStyle(
                    color: light(), fontSize: 25, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(color: mid2(), fontSize: 25),
                ),
                keyboardType: TextInputType.text,
              ),
              Expanded(
                child: TextField(
                  maxLines: null,
                  controller: _noteControl,
                  cursorColor: light(),
                  style: TextStyle(color: light()),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Note",
                    hintStyle: TextStyle(color: mid2(), fontSize: 20),
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

  void addBox(BuildContext context) {
    return showBottomDrawer(
      context,
      280,
      Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.camera_alt_outlined,
              color: light(),
            ),
            title: Text(
              'Take photo',
              style: TextStyle(color: light()),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.image_outlined,
              color: light(),
            ),
            title: Text(
              'Add image',
              style: TextStyle(color: light()),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.brush_outlined,
              color: light(),
            ),
            title: Text(
              'Drawing',
              style: TextStyle(color: light()),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mic_none_outlined,
              color: light(),
            ),
            title: Text(
              'Recording',
              style: TextStyle(color: light()),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.check_box_outlined,
              color: light(),
            ),
            title: Text(
              'Tick boxes',
              style: TextStyle(color: light()),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
