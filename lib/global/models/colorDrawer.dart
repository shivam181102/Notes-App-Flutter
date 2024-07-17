import 'package:flutter/material.dart';
import 'package:notes/global/common/colorpalet.dart';

class ColorClass {
  Color clo;
  bool selected;
  int id;
  void updateCol;
  ColorClass({
    required this.clo,
    this.selected = false,
    required this.id,
  });
}

class Colordrawer {
  final updateFun;
  List<ColorClass> list = [];
  Colordrawer({required this.updateFun});
  List<ColorClass> getColor() {
    list.add(ColorClass(clo: dark(), selected: true, id: 1));
    list.add(ColorClass(clo: Color.fromARGB(255, 118, 23, 45), id: 2));
    list.add(ColorClass(clo: Color.fromARGB(255, 105, 42, 24), id: 3));
    list.add(ColorClass(clo: Color.fromARGB(255, 122, 74, 3), id: 4));
    list.add(ColorClass(clo: Color.fromARGB(255, 38, 77, 59), id: 5));
    list.add(ColorClass(clo: Color.fromARGB(255, 0, 195, 94), id: 6));
    list.add(ColorClass(clo: Color.fromARGB(255, 42, 78, 135), id: 7));
    return list;
  }

  void updateSelected(id) {
    for (var element in list) {
      element.selected = false;
      if (element.id == id) {
        element.selected = true;
        updateFun(element.clo);
      }
    }
  }
}
