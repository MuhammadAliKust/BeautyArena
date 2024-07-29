// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'dashboard.dart';

List<CartModel> cartModelFromJson(String? str) =>
    List<CartModel>.from(json.decode(str!).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  String name;
  String id;
  String categoryID;
  String price;
  String image;
  String offer;
  int quantity;
  int totalQuantity;
  Product product;

  CartModel({
    required this.name,
    required this.id,
    required this.price,
    required this.image,
    required this.offer,
    required this.quantity,
    required this.totalQuantity,
    required this.product,
    required this.categoryID,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        name: json["name"],
        id: json["id"],
        price: json["price"],
        image: json["image"],
        offer: json["offer"],
        quantity: json["quantity"],
        totalQuantity: json["totalQuantity"],
    categoryID: json["categoryID"],
        product: json["product"] == null
            ? Product()
            : Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "price": price,
        "image": image,
        "offer": offer,
        "quantity": quantity,
        "totalQuantity": totalQuantity,
        "categoryID": categoryID,
        "product": product.toJson(),
      };
}
