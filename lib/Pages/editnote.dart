import 'dart:math';

import 'package:flutter/material.dart';

import 'package:notes/global/common/colorpalet.dart';

class Editnote extends StatefulWidget {
  const Editnote({super.key});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  Map<String, dynamic>? profile;
  late TextEditingController _titleControl;
  late TextEditingController _noteControl;

  @override
  void initState() {
    super.initState();
    _titleControl = TextEditingController();
    _noteControl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profile =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (profile != null) {
      print(profile!['id']);
      _titleControl.text = profile!['name'] ?? '';
      _noteControl.text = "${profile!['address']} ${profile!['age']}" ?? '';
    }
  }

  @override
  void dispose() {
    _titleControl.dispose();
    _noteControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark(),
      appBar: AppBar(
        backgroundColor: mid(),
        iconTheme: IconThemeData(color: light()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print(_noteControl.text);
            Navigator.pushNamedAndRemoveUntil(
                context, "home", (Route<dynamic> route) => false);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.push_pin),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.notification_add_outlined),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.archive_outlined),
          ),
          SizedBox(
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
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.add_box_outlined,
                    color: light(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.color_lens_outlined,
                    color: light(),
                  ),
                )
              ],
            ),
            Text(
              "Edited 11:47 am",
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
    );
  }
}
