// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String? str) =>
    UserModel.fromJson(json.decode(str!));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  Data({
    this.token,
    this.customer,
  });

  String? token;
  Customer? customer;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        customer: json["user"] == null
            ? null
            : Customer.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": customer?.toJson(),
      };
}

class Customer {
  Customer({
    this.id,
    this.name,
    this.image,
    this.customerGender,
    this.customerBirthday,
    this.customerMobile,
    this.customerGovernorate,
    this.customerCity,
    this.vip_card_number,
  });

  int? id;
  String? name;
  String? image;
  String? customerGender;
  DateTime? customerBirthday;
  String? customerMobile;
  CustomerGovernorate? customerGovernorate;
  String? customerCity;
  String? vip_card_number;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        customerGender: json["customer_gender"],
        customerBirthday: json["customer_birthday"] == null
            ? null
            : DateTime.parse(json["customer_birthday"]),
        customerMobile: json["customer_mobile"],
        customerGovernorate: json["customer_governorate"] == null
            ? null
            : CustomerGovernorate.fromJson(json["customer_governorate"]),
        customerCity: json["customer_city"],
    vip_card_number: json["vip_card_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "customer_gender": customerGender,
        "customer_birthday":
            "${customerBirthday!.year.toString().padLeft(4, '0')}-${customerBirthday!.month.toString().padLeft(2, '0')}-${customerBirthday!.day.toString().padLeft(2, '0')}",
        "customer_mobile": customerMobile,
        "customer_governorate": customerGovernorate?.toJson(),
        "customer_city": customerCity,
        "vip_card_number": vip_card_number,
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

  factory CustomerGovernorate.fromJson(Map<String, dynamic> json) =>
      CustomerGovernorate(
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
