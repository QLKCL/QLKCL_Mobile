// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

import 'package:qlkcl/networking/api_helper.dart';
import 'package:qlkcl/utils/constant.dart';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  Notification({
    required this.notification,
    required this.isRead,
  });

  final NotificationClass notification;
  final bool isRead;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        notification: NotificationClass.fromJson(json["notification"]),
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "notification": notification.toJson(),
        "is_read": isRead,
      };
}

class NotificationClass {
  NotificationClass({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.image,
    required this.url,
    required this.type,
    required this.createdAt,
  });

  final int id;
  final CreatedBy createdBy;
  final String title;
  final String description;
  final dynamic image;
  final dynamic url;
  final String type;
  final DateTime createdAt;

  factory NotificationClass.fromJson(Map<String, dynamic> json) =>
      NotificationClass(
        id: json["id"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        title: json["title"],
        description: json["description"],
        image: json["image"],
        url: json["url"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy.toJson(),
        "title": title,
        "description": description,
        "image": image,
        "url": url,
        "type": type,
        "created_at": createdAt.toIso8601String(),
      };
}

class CreatedBy {
  CreatedBy({
    required this.code,
    required this.fullName,
  });

  final String code;
  final String fullName;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        code: json["code"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "full_name": fullName,
      };
}

Future<dynamic> fetchUserNotification({id}) async {
  ApiHelper api = ApiHelper();
  final response =
      await api.getHTTP(Constant.getUserNotification + '?id=' + id);
  return response["data"];
}

Future<dynamic> fetchUserNotificationList({data}) async {
  ApiHelper api = ApiHelper();
  final response = await api.postHTTP(Constant.filterUserNotification, data);
  return response != null && response['data'] != null
      ? response['data']['content']
      : null;
}
