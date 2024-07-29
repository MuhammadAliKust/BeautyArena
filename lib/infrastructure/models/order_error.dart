// To parse this JSON data, do
//
//     final orderErrorModel = orderErrorModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OrderErrorModel orderErrorModelFromJson(String str) => OrderErrorModel.fromJson(json.decode(str));

String orderErrorModelToJson(OrderErrorModel data) => json.encode(data.toJson());

class OrderErrorModel {
  bool success;
  String message;
  List<String> errors;

  OrderErrorModel({
    required this.success,
    required this.message,
    required this.errors,
  });

  factory OrderErrorModel.fromJson(Map<String, dynamic> json) => OrderErrorModel(
    success: json["success"],
    message: json["message"],
    errors: List<String>.from(json["errors"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errors": List<dynamic>.from(errors.map((x) => x)),
  };
}
