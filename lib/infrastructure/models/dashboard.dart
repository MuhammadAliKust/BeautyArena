// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
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
    this.lastestProduct,
    this.featuredProduct,
    this.categorySlider,
    this.poster,
    this.topSellingProduct,
    this.cuoponSlider,
  });

  List<Product>? lastestProduct;
  List<Product>? featuredProduct;
  List<CategorySlider>? categorySlider;
  List<Poster>? poster;
  List<Product>? topSellingProduct;
  List<CuoponSlider>? cuoponSlider;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lastestProduct: json["lastest_product"] == null
            ? []
            : List<Product>.from(
                json["lastest_product"]!.map((x) => Product.fromJson(x))),
        featuredProduct: json["featured_product"] == null
            ? []
            : List<Product>.from(
                json["featured_product"]!.map((x) => Product.fromJson(x))),
        categorySlider: json["category_slider"] == null
            ? []
            : List<CategorySlider>.from(json["category_slider"]!
                .map((x) => CategorySlider.fromJson(x))),
        poster: json["poster"] == null
            ? []
            : List<Poster>.from(json["poster"]!.map((x) => Poster.fromJson(x))),
        topSellingProduct: json["top_selling_product"] == null
            ? []
            : List<Product>.from(
                json["top_selling_product"]!.map((x) => Product.fromJson(x))),
        cuoponSlider: json["cuopon_slider"] == null
            ? []
            : List<CuoponSlider>.from(
                json["cuopon_slider"]!.map((x) => CuoponSlider.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lastest_product": lastestProduct == null
            ? []
            : List<dynamic>.from(lastestProduct!.map((x) => x.toJson())),
        "featured_product": featuredProduct == null
            ? []
            : List<dynamic>.from(featuredProduct!.map((x) => x.toJson())),
        "category_slider": categorySlider == null
            ? []
            : List<dynamic>.from(categorySlider!.map((x) => x.toJson())),
        "poster": poster == null
            ? []
            : List<dynamic>.from(poster!.map((x) => x.toJson())),
        "top_selling_product": topSellingProduct == null
            ? []
            : List<dynamic>.from(topSellingProduct!.map((x) => x.toJson())),
        "cuopon_slider": cuoponSlider == null
            ? []
            : List<dynamic>.from(cuoponSlider!.map((x) => x.toJson())),
      };
}

class CategorySlider {
  CategorySlider({
    this.id,
    this.name,
    this.image,
    this.productCount,
    this.children,
  });

  int? id;
  String? name;
  dynamic image;
  int? productCount;
  List<CategorySlider>? children;

  factory CategorySlider.fromJson(Map<String, dynamic> json) => CategorySlider(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        productCount: json["product_count"],
        children: json["children"] == null
            ? []
            : List<CategorySlider>.from(
                json["children"]!.map((x) => CategorySlider.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "product_count": productCount,
        "children": children == null
            ? []
            : List<dynamic>.from(children!.map((x) => x.toJson())),
      };
}

class CuoponSlider {
  CuoponSlider({
    this.id,
    this.name,
    this.code,
  });

  int? id;
  String? name;
  String? code;

  factory CuoponSlider.fromJson(Map<String, dynamic> json) => CuoponSlider(
        id: json["id"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
      };
}

class Product {
  Product({
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
    this.keywords,
    this.offer,
    this.favorite,
    this.salePrice,
    this.offer_percentage,
    this.outOfStock,
  });

  int? id;
  String? name;
  num? price;
  int? offer_percentage;
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
  List<Keyword>? keywords;
  int? offer;
  int? salePrice;
  int? favorite;
  int? outOfStock;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        description: json["description"],
        inventory: json["inventory"],
        status: json["status"],
        sku: json["sku"],
        type: json["type"],
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        crossSellingProducts: json["cross_selling_products"] == null
            ? []
            : List<Product>.from(json["cross_selling_products"]!
                .map((x) => Product.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<CategorySlider>.from(
                json["categories"]!.map((x) => CategorySlider.fromJson(x))),
        keywords: json["keywords"] == null
            ? []
            : List<Keyword>.from(
                json["keywords"]!.map((x) => Keyword.fromJson(x))),
        offer: json["offer"],
        salePrice: json["sale_price"],
    offer_percentage: json["offer_percentage"],
    favorite: json["favorite"],
    outOfStock: json["out_of_stock"],
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
        "brand": brand?.toJson(),
        "cross_selling_products": crossSellingProducts == null
            ? []
            : List<dynamic>.from(crossSellingProducts!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "keywords": keywords == null
            ? []
            : List<dynamic>.from(keywords!.map((x) => x.toJson())),
        "offer": offer,
        "sale_price": salePrice,
        "offer_percentage": offer_percentage,
        "favorite": favorite,
        "out_of_stock": outOfStock,
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

class Keyword {
  Keyword({
    this.id,
    this.value,
  });

  int? id;
  String? value;

  factory Keyword.fromJson(Map<String, dynamic> json) => Keyword(
        id: json["id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
      };
}

class Poster {
  Poster({
    this.id,
    this.title,
    this.image,
    this.category,
    this.product,
    this.type,
  });

  int? id;
  String? title;
  String? image;
  int? category;
  int? product;
  String? type;

  factory Poster.fromJson(Map<String, dynamic> json) => Poster(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        category: json["category"],
        product: json["product"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "category": category,
        "product": product,
        "type": type,
      };
}
