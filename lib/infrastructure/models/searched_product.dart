// To parse this JSON data, do
//
//     final searchedProductModel = searchedProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:beauty_arena_app/infrastructure/models/dashboard.dart';

SearchedProductModel searchedProductModelFromJson(String str) => SearchedProductModel.fromJson(json.decode(str));

String searchedProductModelToJson(SearchedProductModel data) => json.encode(data.toJson());

class SearchedProductModel {
  bool? success;
  String? message;
  Data? data;

  SearchedProductModel({
    this.success,
    this.message,
    this.data,
  });

  factory SearchedProductModel.fromJson(Map<String, dynamic> json) => SearchedProductModel(
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
  List<Datum>? data;
  Links? links;
  Meta? meta;

  Data({
    this.data,
    this.links,
    this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class Datum {
  int? id;
  String? name;
  num? price;
  int? offer;
  int? offerPercentage;
  int? salePrice;
  String? image;
  int? outOfStock;
  List<String>? images;
  String? description;
  int? inventory;
  String? status;
  dynamic availabilityStatus;
  String? sku;
  String? type;
  String? genderLabel;
  dynamic favorite;
  Brand? brand;
  List<CategorySlider>? categories;
  List<dynamic>? keywords;

  Datum({
    this.id,
    this.name,
    this.price,
    this.offer,
    this.offerPercentage,
    this.salePrice,
    this.image,
    this.outOfStock,
    this.images,
    this.description,
    this.inventory,
    this.status,
    this.availabilityStatus,
    this.sku,
    this.type,
    this.genderLabel,
    this.favorite,
    this.brand,
    this.categories,
    this.keywords,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    offer: json["offer"],
    offerPercentage: json["offer_percentage"],
    salePrice: json["sale_price"],
    image: json["image"],
    outOfStock: json["out_of_stock"],
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    description: json["description"],
    inventory: json["inventory"],
    status: json["status"],
    availabilityStatus: json["availability_status"],
    sku: json["sku"],
    type: json["type"],
    genderLabel: json["gender_label"],
    favorite: json["favorite"],
    brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
    categories: json["categories"] == null ? [] : List<CategorySlider>.from(json["categories"]!.map((x) => CategorySlider.fromJson(x))),
    keywords: json["keywords"] == null ? [] : List<dynamic>.from(json["keywords"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "offer": offer,
    "offer_percentage": offerPercentage,
    "sale_price": salePrice,
    "image": image,
    "out_of_stock": outOfStock,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "description": description,
    "inventory": inventory,
    "status": status,
    "availability_status": availabilityStatus,
    "sku": sku,
    "type": type,
    "gender_label": genderLabel,
    "favorite": favorite,
    "brand": brand?.toJson(),
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "keywords": keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
  };
}


class Category {
  int? id;
  String? name;
  String? image;
  List<Category>? children;

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

class Links {
  String? first;
  String? last;
  dynamic prev;
  String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  String? perPage;
  int? to;
  int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
