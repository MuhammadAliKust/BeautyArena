// To parse this JSON data, do
//
//     final orderResponseModel = orderResponseModelFromJson(jsonString);

import 'dart:convert';

OrderResponseModel orderResponseModelFromJson(String str) => OrderResponseModel.fromJson(json.decode(str));

String orderResponseModelToJson(OrderResponseModel data) => json.encode(data.toJson());

class OrderResponseModel {
  bool? success;
  String? message;
  Data? data;

  OrderResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) => OrderResponseModel(
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
  String? id;
  String? url;
  String? authorizationUrl;

  Data({
    this.id,
    this.url,
    this.authorizationUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    url: json["url"],
    authorizationUrl: json["authorization_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "authorization_url": authorizationUrl,
  };
}
