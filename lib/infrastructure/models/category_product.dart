// To parse this JSON data, do
//
//     final categoryProductModel = categoryProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:beauty_arena_app/infrastructure/models/product.dart';

CategoryProductModel categoryProductModelFromJson(String str) =>
    CategoryProductModel.fromJson(json.decode(str));

String categoryProductModelToJson(CategoryProductModel data) =>
    json.encode(data.toJson());

class CategoryProductModel {
  final bool? success;
  final String? message;
  final Data? data;

  CategoryProductModel({
    this.success,
    this.message,
    this.data,
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) =>
      CategoryProductModel(
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
  final int? id;
  final String? name;
  final String? image;
  final List<Data>? children;
  final Products? products;

  Data({
    this.id,
    this.name,
    this.image,
    this.children,
    this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        children: json["children"] == null
            ? []
            : List<Data>.from(json["children"]!.map((x) => Data.fromJson(x))),
        products: json["products"] == null
            ? null
            : Products.fromJson(json["products"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "children": children == null
            ? []
            : List<dynamic>.from(children!.map((x) => x.toJson())),
        "products": products?.toJson(),
      };
}

class Products {
  final List<Datum>? data;
  final Links? links;
  final Meta? meta;

  Products({
    this.data,
    this.links,
    this.meta,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
      };
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final String? next;

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
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

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
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

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
