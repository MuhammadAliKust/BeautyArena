// To parse this JSON data, do
//
//     final offersModel = offersModelFromJson(jsonString);

import 'dart:convert';

import 'package:beauty_arena_app/infrastructure/models/categories.dart';

import 'dashboard.dart';

OffersModel offersModelFromJson(String str) => OffersModel.fromJson(json.decode(str));

String offersModelToJson(OffersModel data) => json.encode(data.toJson());

class OffersModel {
  OffersModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<Datum>? data;

  factory OffersModel.fromJson(Map<String, dynamic> json) => OffersModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.description,
    this.image,
    this.product,
    this.category,
    this.brand,
  });

  int? id;
  String? title;
  String? description;
  String? image;
  List<Product>? product;
  List<CategoriesModel>? category;
  List<dynamic>? brand;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    product: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((x) => Product.fromJson(x))),
    category: json["category"] == null ? [] : List<CategoriesModel>.from(json["category"]!.map((x) => CategoriesModel.fromJson(x))),
    brand: json["brand"] == null ? [] : List<dynamic>.from(json["brand"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "product": product == null ? [] : List<dynamic>.from(product!.map((x) => x.toJson())),
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x.toJson())),
    "brand": brand == null ? [] : List<dynamic>.from(brand!.map((x) => x)),
  };
}



