// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  CityModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<Datum>? data;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum extends Equatable {
  Datum({
    this.id,
    this.governorateName,
    this.governoratePrice,
  });

  int? id;
  String? governorateName;
  int? governoratePrice;

  @override
  List<int> get props => [id!];

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        governorateName: json["governorate_name"],
        governoratePrice: json["governorate_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "governorate_name": governorateName,
        "governorate_price": governoratePrice,
      };
}
