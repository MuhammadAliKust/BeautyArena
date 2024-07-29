import 'package:flutter/cupertino.dart';
import '../infrastructure/models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;

  void saveUserDetails(UserModel? userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  UserModel? getUserDetails() => _userModel;

  void clearData(){
    _userModel = null;
    notifyListeners();
  }
}
