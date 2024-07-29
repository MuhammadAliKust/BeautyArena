// To parse this JSON data, do
//
//     final pageModel = pageModelFromJson(jsonString);

import 'dart:convert';

PageModel pageModelFromJson(String str) => PageModel.fromJson(json.decode(str));

String pageModelToJson(PageModel data) => json.encode(data.toJson());

class PageModel {
  bool? success;
  String? message;
  List<Datum>? data;

  PageModel({
    this.success,
    this.message,
    this.data,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? pageTitle;
  String? pageImage;
  String? page_content;

  Datum({
    this.id,
    this.pageTitle,
    this.pageImage,
    this.page_content,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    pageTitle: json["page_title"],
    pageImage: json["page_image"],
    page_content: json["page_content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "page_title": pageTitle,
    "page_image": pageImage,
    "page_content": page_content,
  };
}
