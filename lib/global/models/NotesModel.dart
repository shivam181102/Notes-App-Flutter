import 'package:flutter/material.dart';

class NotesModel {
  int? id , deletedtime;
  String title;
  String body;
  Color color;
  DateTime? editedAt;
  bool pin, archive, deleted;

  NotesModel(
      {this.id,
      required this.title,
      required this.body,
      required this.color,
      this.editedAt,
      this.archive = false,
      this.pin = false,
      this.deleted = false,
      this.deletedtime});
}
