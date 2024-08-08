import 'package:flutter/material.dart';
import 'package:notes/global/models/NotesModel.dart';

class Selectionprovider with ChangeNotifier {
  List<NotesModel> _selectedNotes = [];

  List<NotesModel> get selectedNotes => _selectedNotes;

  void addSelected(NotesModel note){
    _selectedNotes.add(note);
    notifyListeners();
  }
  void removeSelected(NotesModel note){
    _selectedNotes.remove(note);
    notifyListeners();
  }
}