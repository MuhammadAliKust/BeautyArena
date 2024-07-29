// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'dashboard.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
    this.data,
    this.links,
    this.meta,
  });

  List<Datum>? data;
  Links? links;
  Meta? meta;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      links: json["links"] == null ? null : Links.fromJson(json["links"]),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.price,
    this.image,
    this.images,
    this.description,
    this.inventory,
    this.status,
    this.sku,
    this.type,
    this.brand,
    this.crossSellingProducts,
    this.categories,
    // this.keywords,
    this.offer,
    this.salePrice,
    this.favorite,
    this.outOfStock,
  });

  int? id;
  String? name;
  num? price;
  String? image;
  List<String>? images;
  String? description;
  int? inventory;
  String? status;
  String? sku;
  String? type;
  Brand? brand;
  List<Product>? crossSellingProducts;
  List<CategorySlider>? categories;

  // List<Keyword>? keywords;
  int? offer;
  int? salePrice;
  int? favorite;
  int? outOfStock;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        favorite: json["favorite"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        description: json["description"],
        inventory: json["inventory"],
        status: json["status"],
        sku: json["sku"],
        type: json["type"],
        outOfStock: json["out_of_stock"],
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        crossSellingProducts: json["cross_selling_products"] == null
            ? []
            : List<Product>.from(json["cross_selling_products"]!
                .map((x) => Product.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<CategorySlider>.from(
                json["categories"]!.map((x) => CategorySlider.fromJson(x))),
        offer: json["offer"],
        salePrice: json["sale_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "description": description,
        "inventory": inventory,
        "status": status,
        "sku": sku,
        "type": type,
        "out_of_stock": outOfStock,
        "brand": brand?.toJson(),
        "cross_selling_products": crossSellingProducts == null
            ? []
            : List<dynamic>.from(crossSellingProducts!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "offer": offer,
        "sale_price": salePrice,
        "favorite": favorite,
      };
}

class Brand {
  Brand({
    this.id,
    this.title,
    this.description,
    this.image,
  });

  int? id;
  String? title;
  dynamic description;
  String? image;

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

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  dynamic prev;
  String? next;

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
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    // this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;

  // List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        // links: json["links"] == null
        //     ? []
        //     : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: int.parse(json["per_page"].toString()),

        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        // "links": links == null
        //     ? []
        //     : List<dynamic>.from(links!.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

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
