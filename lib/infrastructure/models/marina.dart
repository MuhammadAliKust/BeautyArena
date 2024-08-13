// To parse this JSON data, do
//
//     final marinaModel = marinaModelFromJson(jsonString);

import 'dart:convert';

import 'dashboard.dart';

MarinaModel marinaModelFromJson(String str) => MarinaModel.fromJson(json.decode(str));

String marinaModelToJson(MarinaModel data) => json.encode(data.toJson());

class MarinaModel {
  final List<Datum>? data;

  MarinaModel({
    this.data,
  });

  factory MarinaModel.fromJson(Map<String, dynamic> json) => MarinaModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final String? image;
  final List<Category>? categories;
  final List<Product>? products;

  Datum({
    this.image,
    this.categories,
    this.products,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    image: json["image"],
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Category {
  final int? id;
  final String? name;
  final String? image;
  final List<Category>? children;

  Category({
    this.id,
    this.name,
    this.image,
    this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    children: json["children"] == null ? [] : List<Category>.from(json["children"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}

// class Product {
//   final int? id;
//   final String? name;
//   final int? price;
//   final int? offer;
//   final int? offerPercentage;
//   final int? salePrice;
//   final String? image;
//   final int? outOfStock;
//   final List<String>? images;
//   final String? description;
//   final int? inventory;
//   final String? status;
//   final String? availabilityStatus;
//   final String? sku;
//   final String? type;
//   final String? genderLabel;
//   final int? favorite;
//   final Brand? brand;
//   final List<Category>? categories;
//   final List<Keyword>? keywords;
//
//   Product({
//     this.id,
//     this.name,
//     this.price,
//     this.offer,
//     this.offerPercentage,
//     this.salePrice,
//     this.image,
//     this.outOfStock,
//     this.images,
//     this.description,
//     this.inventory,
//     this.status,
//     this.availabilityStatus,
//     this.sku,
//     this.type,
//     this.genderLabel,
//     this.favorite,
//     this.brand,
//     this.categories,
//     this.keywords,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json["id"],
//     name: json["name"],
//     price: json["price"],
//     offer: json["offer"],
//     offerPercentage: json["offer_percentage"],
//     salePrice: json["sale_price"],
//     image: json["image"],
//     outOfStock: json["out_of_stock"],
//     images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
//     description: json["description"],
//     inventory: json["inventory"],
//     status: json["status"],
//     availabilityStatus: json["availability_status"],
//     sku: json["sku"],
//     type: json["type"],
//     genderLabel: json["gender_label"],
//     favorite: json["favorite"],
//     brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
//     categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
//     keywords: json["keywords"] == null ? [] : List<Keyword>.from(json["keywords"]!.map((x) => Keyword.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "price": price,
//     "offer": offer,
//     "offer_percentage": offerPercentage,
//     "sale_price": salePrice,
//     "image": image,
//     "out_of_stock": outOfStock,
//     "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
//     "description": description,
//     "inventory": inventory,
//     "status": status,
//     "availability_status": availabilityStatus,
//     "sku": sku,
//     "type": type,
//     "gender_label": genderLabel,
//     "favorite": favorite,
//     "brand": brand?.toJson(),
//     "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
//     "keywords": keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x.toJson())),
//   };
// }

class Brand {
  final int? id;
  final String? title;
  final dynamic description;
  final dynamic image;

  Brand({
    this.id,
    this.title,
    this.description,
    this.image,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
  };
}

class Keyword {
  final int? id;
  final String? value;

  Keyword({
    this.id,
    this.value,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) => Keyword(
    id: json["id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
  };
}
