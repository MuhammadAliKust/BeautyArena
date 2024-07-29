// To parse this JSON data, do
//
//     final deleteModel = deleteModelFromJson(jsonString);

import 'dart:convert';

DeleteModel deleteModelFromJson(String str) => DeleteModel.fromJson(json.decode(str));

String deleteModelToJson(DeleteModel data) => json.encode(data.toJson());

class DeleteModel {
  DeleteModel({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory DeleteModel.fromJson(Map<String, dynamic> json) => DeleteModel(
    success: json["success"],
    message: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": message,
  };
}
