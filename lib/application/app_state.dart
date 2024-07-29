import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../configurations/enums.dart';

class AppState with ChangeNotifier {
  AppCurrentState _status = AppCurrentState.IsFree;

  void stateStatus(AppCurrentState status, [bool callNotify = true]) {
    if (callNotify == true) {
      _status = status;
      notifyListeners();
    } else {
      _status = status;
    }
  }

  getStateStatus() => _status;
}
