import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class JsonData {
  List<dynamic>? _data;
  late File _file;
  static final JsonData _instance = JsonData._internal();
  factory JsonData() {
    return _instance;
  }
  JsonData._internal() {
    _file = File('lib/global/common/data.json');
    initData();
  }
  Future initData() async {
    String response = await _file.readAsString();
    final data = await json.decode(response);
    print("AAgayaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    _data = data;
  }

  Future getAllData() async {
    await initData();
    return _data;
  }
}
