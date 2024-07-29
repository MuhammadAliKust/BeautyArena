import 'package:flutter/cupertino.dart';

class ErrorString extends ChangeNotifier {
  String _error = "";

  void saveErrorString(String error) {
    _error = error;
    notifyListeners();
  }

  String getErrorString() => _error;
}
