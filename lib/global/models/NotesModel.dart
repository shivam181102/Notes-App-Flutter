import 'package:flutter/material.dart';

class NotesModel {
  int? id;
  String title;
  String body;
  Color color;
  DateTime? editedAt;
  bool pin, archive;

  NotesModel(
      {this.id,
      required this.title,
      required this.body,
      required this.color,
      this.editedAt,
      this.archive = false,
      this.pin = false});
}
