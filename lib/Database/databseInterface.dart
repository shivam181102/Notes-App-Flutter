import 'package:notes/global/models/NotesModel.dart';

abstract class Databseinterface {
  Future<void> addNote(NotesModel note);
  Future<void> updateNote(NotesModel note);
  Future<void> deleteNote(int? id);
  Future<List<NotesModel>> getData();
}
