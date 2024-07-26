import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/models/NotesModel.dart';

class Notesgridviewcomponent extends StatefulWidget {
  bool viewStyle;
  List<NotesModel> snapData;
  Notesgridviewcomponent(
      {super.key, required this.viewStyle, required this.snapData});

  @override
  State<Notesgridviewcomponent> createState() => _NotesgridviewcomponentState();
}

class _NotesgridviewcomponentState extends State<Notesgridviewcomponent> {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: widget.snapData.length,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.viewStyle ? 2 : 1),
        itemBuilder: (context, index) {
          // final profile = _data![index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'editnote',
                  arguments: {"note": widget.snapData[index] ?? null});
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.snapData[index].color,
                  border: Border.all(color: mid2, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                // height: (index + 1) * 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.snapData[index].title,
                      style: TextStyle(
                          color: light,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.snapData[index].body,
                      style: TextStyle(color: light),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
