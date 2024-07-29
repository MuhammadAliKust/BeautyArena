// To parse this JSON data, do
//
//     final singleProductModel = singleProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:beauty_arena_app/infrastructure/models/dashboard.dart';

SingleProductModel singleProductModelFromJson(String str) => SingleProductModel.fromJson(json.decode(str));

String singleProductModelToJson(SingleProductModel data) => json.encode(data.toJson());

class SingleProductModel {
  bool? success;
  String? message;
  Product? data;

  SingleProductModel({
    this.success,
    this.message,
    this.data,
  });

  factory SingleProductModel.fromJson(Map<String, dynamic> json) => SingleProductModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Product.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}