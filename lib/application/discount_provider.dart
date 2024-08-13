import 'package:flutter/cupertino.dart';

class DiscountProvider extends ChangeNotifier {
  bool _showDiscount = true;

  void saveDiscountProvider(bool val) {
    _showDiscount = val;
    notifyListeners();
  }

  bool getDiscountProvider() => _showDiscount;
}
