// To parse this JSON data, do
//
//     final updatedUserModel = updatedUserModelFromJson(jsonString);

import 'dart:convert';

UpdatedUserModel updatedUserModelFromJson(String str) => UpdatedUserModel.fromJson(json.decode(str));

String updatedUserModelToJson(UpdatedUserModel data) => json.encode(data.toJson());

class UpdatedUserModel {
  UpdatedUserModel({
    this.id,
    this.name,
    this.image,
    this.customerGender,
    this.customerBirthday,
    this.customerMobile,
    this.customerGovernorate,
    this.customerCity,
  });

  int? id;
  String? name;
  String? image;
  String? customerGender;
  DateTime? customerBirthday;
  String? customerMobile;
  CustomerGovernorate? customerGovernorate;
  String? customerCity;

  factory UpdatedUserModel.fromJson(Map<String, dynamic> json) => UpdatedUserModel(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    customerGender: json["customer_gender"],
    customerBirthday: json["customer_birthday"] == null ? null : DateTime.parse(json["customer_birthday"]),
    customerMobile: json["customer_mobile"],
    customerGovernorate: json["customer_governorate"] == null ? null : CustomerGovernorate.fromJson(json["customer_governorate"]),
    customerCity: json["customer_city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "customer_gender": customerGender,
    "customer_birthday": "${customerBirthday!.year.toString().padLeft(4, '0')}-${customerBirthday!.month.toString().padLeft(2, '0')}-${customerBirthday!.day.toString().padLeft(2, '0')}",
    "customer_mobile": customerMobile,
    "customer_governorate": customerGovernorate?.toJson(),
    "customer_city": customerCity,
  };
}

class CustomerGovernorate {
  CustomerGovernorate({
    this.id,
    this.governorateName,
    this.governoratePrice,
  });

  int? id;
  String? governorateName;
  int? governoratePrice;

  factory CustomerGovernorate.fromJson(Map<String, dynamic> json) => CustomerGovernorate(
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
