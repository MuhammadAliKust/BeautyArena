// To parse this JSON data, do
//
//     final discountModel = discountModelFromJson(jsonString);

import 'dart:convert';

DiscountModel discountModelFromJson(String str) => DiscountModel.fromJson(json.decode(str));

String discountModelToJson(DiscountModel data) => json.encode(data.toJson());

class DiscountModel {
  final bool? success;
  final String? message;
  final Data? data;

  DiscountModel({
    this.success,
    this.message,
    this.data,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final num? totalDiscount;
  final num? totalSales;
  final num? totalNetSales;
  final num? percentage;
  final List<ProductId>? productIds;

  Data({
    this.totalDiscount,
    this.totalSales,
    this.totalNetSales,
    this.percentage,
    this.productIds,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalDiscount: json["total_discount"],
    totalSales: json["total_sales"],
    totalNetSales: json["total_net_sales"],
    percentage: json["percentage"],
    productIds: json["product_ids"] == null ? [] : List<ProductId>.from(json["product_ids"]!.map((x) => ProductId.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_discount": totalDiscount,
    "total_sales": totalSales,
    "total_net_sales": totalNetSales,
    "percentage": percentage,
    "product_ids": productIds == null ? [] : List<dynamic>.from(productIds!.map((x) => x.toJson())),
  };
}

class ProductId {
  final String? id;
  final int? qty;

  ProductId({
    this.id,
    this.qty,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
    id: json["id"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "qty": qty,
  };
}
