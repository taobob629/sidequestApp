import 'package:flutter/material.dart';

class NotificationModel {
  late int id;
  late String title;
  late String body;
  late String time;

  NotificationModel();

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    time = json['time'];
  }
}