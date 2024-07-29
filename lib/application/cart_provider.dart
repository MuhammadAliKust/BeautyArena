import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/models/cart.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _cartList = [];

  void setCartList(List<CartModel> list) {
    _cartList = list;
    notifyListeners();
  }

  void addItem(CartModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool flag = false;
    _cartList.map((e) {
      if (e.id == model.id) {
        flag = true;
      }
    }).toList();
    if (!flag) {
      _cartList.add(model);
      prefs.setString('CART_DATA', cartModelToJson(_cartList));
      notifyListeners();
    } else {
      increment(model.id);
    }
  }

  int getItemQuantity(String id) {
    int quantity = 0;
    _cartList.map((e) {
      if (e.id == id) {
        quantity = e.quantity;
      }
    }).toList();

    return quantity;
  }

  void removeItem(String id)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartList.removeWhere((e) {
      return e.id == id;
    });
    prefs.setString('CART_DATA', cartModelToJson(_cartList));
    notifyListeners();
  }

  void increment(String id)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartList.map((e) {
      if (e.id == id) {
        e.quantity++;
      }
    }).toList();

    prefs.setString('CART_DATA', cartModelToJson(_cartList));
    notifyListeners();
  }

  void decrement(String id)async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartList.map((e) {
      if (e.id == id) {
        if (e.quantity == 1) {
          removeItem(id);
        } else {
          e.quantity--;
        }
      }
    }).toList();

    prefs.setString('CART_DATA', cartModelToJson(_cartList));
    notifyListeners();
  }

  int getSubTotal() {
    num total = 0;
    _cartList.map((e) {
      // print(e.price.toString() + "Price");
      // print(e.quantity.toString() + " Quantity");
      total += num.parse(e.price.toString().trim()) * e.quantity;
    }).toList();
    return total.toInt();
  }

  List<CartModel> get cartItems => _cartList;

  void emptyCart() {
    _cartList.clear();
    notifyListeners();
  }
}
