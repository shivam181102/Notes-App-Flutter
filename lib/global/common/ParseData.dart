import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class NoteData {
  int id;
  String title;
  String body;
  NoteData({this.title = " ", this.body = " ", required this.id});
  Map<String, dynamic> toJson() {
    return {"title": title, "body": body, "id": id};
  }
}

class JsonData {
  List<dynamic>? _data;
  // late File _file;
  static final JsonData _instance = JsonData._internal();
  factory JsonData() {
    return _instance;
  }
  JsonData._internal() {
    initData();
  }
  Future initData() async {
    final response = await rootBundle.loadString('lib/global/common/data.json');
    final data = await json.decode(response);

    _data = data
        .map((res) =>
            NoteData(title: res["title"], body: res["body"], id: res["id"]))
        .toList();
  }

  Future getAllData() async {
    if (_data == null) {
      await initData();
      print("init.................................");
    }
    return _data;
  }

  void updatePerson({int? id, String title = '', String body = ''}) {
    final personIndex = _data!.indexWhere((person) => person.id == id);
    if (personIndex != -1) {
      if (title != null) _data![personIndex].title = title;
      if (body != null) _data![personIndex].body = body;
    } else {
      int len = _data!.length;
      NoteData(title: title, body: body, id: len);
    }
  }
}
