import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Noteprovider with ChangeNotifier {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _gridViewFormat = true;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool get gridViewFormat => _gridViewFormat;

 void toggleGridViewFormat() {
    _gridViewFormat = !_gridViewFormat;
    
    notifyListeners();
  }
  void updateNotes() {
    notifyListeners();
  }

  void setscaffoldKey(GlobalKey<ScaffoldState> value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey = value;
      notifyListeners();
    });
  }
}
