// To parse this JSON data, do
//
//     final relatedProductsModel = relatedProductsModelFromJson(jsonString);

import 'dart:convert';

import 'package:beauty_arena_app/infrastructure/models/dashboard.dart';

RelatedProductsModel relatedProductsModelFromJson(String str) => RelatedProductsModel.fromJson(json.decode(str));

String relatedProductsModelToJson(RelatedProductsModel data) => json.encode(data.toJson());

class RelatedProductsModel {
  bool? success;
  String? message;
  List<Product>? data;

  RelatedProductsModel({
    this.success,
    this.message,
    this.data,
  });

  factory RelatedProductsModel.fromJson(Map<String, dynamic> json) => RelatedProductsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

