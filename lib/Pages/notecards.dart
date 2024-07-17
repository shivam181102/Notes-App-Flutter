import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/firebase%20store/firestore.dart';
import 'package:notes/global/common/ParseData.dart';
import 'package:notes/global/common/colorpalet.dart';

class Notecards extends StatefulWidget {
  bool viewStyle;
  Notecards({super.key, required this.viewStyle});

  @override
  State<Notecards> createState() => _NotecardsState();
}

class _NotecardsState extends State<Notecards> {
  List<dynamic>? _data;
  @override
  void initState() {
    super.initState();
    loadJson();
  }

  JsonData datainit = JsonData();

  Future<void> loadJson() async {
    List<dynamic>? data = await datainit.getAllData();

    setState(() {
      _data = data;
    });
  }

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: FirestoreClass.getAllNotes(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: light()),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: light(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Data Found",
                style: TextStyle(color: light()),
              ),
            );
          }
          if (snapshot != null && snapshot.data != null) {
            return gridview(snapshot);
          }
          return Text("KNHVJHVKJBKJBJKBJKBK");
        },
      ),
    );
  }

  MasonryGridView gridview(AsyncSnapshot<QuerySnapshot<Object?>> snapData) {
    return MasonryGridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: snapData.data!.docs.length,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.viewStyle ? 2 : 1),
        itemBuilder: (context, index) {
          final profile = _data?[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'editnote', arguments: {
                'title': snapData.data!.docs[index]["title"],
                'body': snapData.data!.docs[index]['body'],
                'id': snapData.data!.docs[index].id,
                'edit': snapData.data!.docs[index]['edit']
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: profile.notecol,
                  border: Border.all(color: mid2(), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                // height: (index + 1) * 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapData.data!.docs[index]["title"],
                      style: TextStyle(
                          color: light(),
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      snapData.data!.docs[index]["body"],
                      style: TextStyle(color: light()),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
