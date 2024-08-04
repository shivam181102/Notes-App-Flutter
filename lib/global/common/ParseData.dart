import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteData {
  int id;
  String? title;
  String? body;
  Color notecol;
  NoteData(
      {this.title = " ",
      this.body = " ",
      required this.id,
      this.notecol = const Color.fromARGB(255, 31, 26, 22)});
  Map<String, dynamic> toJson() {
    return {"title": title, "body": body, "id": id};
  }
}

class JsonData {
  List<dynamic>? _data;
  List<dynamic>? data;
  // late File _file;
  static final JsonData _instance = JsonData._internal();
  factory JsonData() {
    return _instance;
  }
  JsonData._internal() {
    initData();
  }
  Future initData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('notesData');

    if (jsonString == null) {
      jsonString = await rootBundle.loadString('lib/global/common/data.json');
      await prefs.setString('notesData', jsonString);
    }

    data = await json.decode(jsonString);

    _data = data!
        .map((res) =>
            NoteData(title: res["title"], body: res["body"], id: res["id"]))
        .toList();
  }

  Future getAllData() async {
    if (_data == null) {
      await initData();
    }
    return _data;
  }

  void removeNote({int? id}) {
    if (id != null) {
      final personIndex = _data!.indexWhere((person) => person.id == id);
      _data!.removeAt(personIndex);
    }
  }

  void updateNote({int? id, String? title, String? body}) async {
    final personIndex = _data!.indexWhere((person) => person.id == id);
    if (personIndex != -1) {
      if (title != null) _data![personIndex].title = title;
      if (body != null) _data![personIndex].body = body;
    } else {
      int len = _data!.length + 1;
      if (title != "" || body != '') {
        NoteData f1 = NoteData(title: title, body: body, id: len);
        _data!.add(f1);
      }
    }
    Iterable temp = _data!.map((res) => res.toJson());
    List<dynamic> templist = temp.toList();
    String data2 = json.encode(templist);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notesData', data2);
  }
}
