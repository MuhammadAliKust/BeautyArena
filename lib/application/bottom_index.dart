import 'package:flutter/cupertino.dart';

class BottomIndexProvider extends ChangeNotifier {
  int _bottomIndex = 0;

  void saveBottomIndex(int index) {
    _bottomIndex = index;
    notifyListeners();
  }

  int getBottomIndex() => _bottomIndex;
}
