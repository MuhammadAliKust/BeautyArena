// To parse this JSON data, do
//
//     final notificationTokenModel = notificationTokenModelFromJson(jsonString);

import 'dart:convert';

NotificationTokenModel notificationTokenModelFromJson(String str) => NotificationTokenModel.fromJson(json.decode(str));

String notificationTokenModelToJson(NotificationTokenModel data) => json.encode(data.toJson());

class NotificationTokenModel {
  NotificationTokenModel({
    this.deviceTokens,
  });

  String? deviceTokens;

  factory NotificationTokenModel.fromJson(Map<String, dynamic> json) => NotificationTokenModel(
    deviceTokens: json["deviceTokens"],
  );

  Map<String, dynamic> toJson() => {
    "deviceTokens": deviceTokens,
  };
}
