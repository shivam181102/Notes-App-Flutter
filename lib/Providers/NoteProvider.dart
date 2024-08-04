import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Noteprovider with ChangeNotifier {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void setscaffoldKey(GlobalKey<ScaffoldState> value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey = value;
      log("provider: ${value.currentState}");
      notifyListeners();
    });
  }
}
