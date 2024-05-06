import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/model/safe_convert.dart';

var orderStatusMap = {
  -4: 'Overdue'.tr,
  -3: 'Rejected'.tr,
  -2: 'Completed'.tr,
  -1: 'Cancelled'.tr,
  0: 'Pending'.tr,
  1: 'Paid'.tr,
  2: 'Accepted'.tr,
  3: 'Refund Pending'.tr,
  4: 'Refund Rejected'.tr,
  5: 'Refunded'.tr,
  6: 'Refund Dispute'.tr,
  7: 'Refund Rejected'.tr,
  8: 'Refunded'.tr,
  9: 'Ongoing'.tr
};

class ServiceListModel {
  // Hour
  final String unit;

  // 1
  final int amount;

  // Naraka:Bladepoint
  final String gameName;

  // 72
  final int price;

  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1670965620058.jpg
  final String icon;

  // Dec 23,2022 11:20 AM
  final String time;
  final int addtime;

  // 24
  final int id;

  // -2
  final int status;

  Color statusColor() {
    switch (status) {
      case -2:
        return Color(0xff4BE72C);
      case -1:
        return Colors.red;
      case 0:
      case 3:
        return Color(0xffFFC916);
      default:
        return Color(0xff9EB4C3);
    }
  }

  ServiceListModel({
    this.unit = "",
    this.amount = 0,
    this.gameName = "",
    this.price = 0,
    this.icon = "",
    this.time = "",
    this.id = 0,
    this.status = 0,
    this.addtime=0,
  });

  factory ServiceListModel.fromJson(Map<String, dynamic>? json) => ServiceListModel(
        unit: asT<String>(json, 'unit'),
        amount: asT<int>(json, 'amount'),
        gameName: asT<String>(json, 'gameName'),
        price: asT<int>(json, 'price'),
        icon: asT<String>(json, 'icon'),
        time: asT<String>(json, 'time'),
        id: asT<int>(json, 'id'),
        status: asT<int>(json, 'status'),
        addtime: asT<int>(json, 'addtime'),
      );

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'amount': amount,
        'gameName': gameName,
        'price': price,
        'icon': icon,
        'time': time,
         'addtime': addtime,
        'id': id,
        'status': status,
      };
}
