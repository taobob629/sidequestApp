

import 'package:wy/model/safe_convert.dart';

class QrLoginInfoModel {
  // Yes
  final String gamingFree;
  // 0
  final int estimatedtime;
  // 0.00
  final String balance;
  // 0
  final int freetime;
  // 1686304017
  final int estimatedDatetime;
  // 5.01
  final String price;
  // 0.0% OFF
  final String discount;
  // CV-PS1-B
  final String device;

  QrLoginInfoModel({
    this.gamingFree = "",
    this.estimatedtime = 0,
    this.balance = "",
    this.freetime = 0,
    this.estimatedDatetime = 0,
    this.price = "",
    this.discount = "",
    this.device = "",
  });

  factory QrLoginInfoModel.fromJson(Map<String, dynamic>? json) => QrLoginInfoModel(
    gamingFree: asT<String>(json, 'gamingFree'),
    estimatedtime: asT<int>(json, 'estimatedtime'),
    balance: asT<String>(json, 'balance'),
    freetime: asT<int>(json, 'freetime'),
    estimatedDatetime: asT<int>(json, 'estimatedDatetime'),
    price: asT<String>(json, 'price'),
    discount: asT<String>(json, 'discount'),
    device: asT<String>(json, 'device'),
  );

  Map<String, dynamic> toJson() => {
    'gamingFree': gamingFree,
    'estimatedtime': estimatedtime,
    'balance': balance,
    'freetime': freetime,
    'estimatedDatetime': estimatedDatetime,
    'price': price,
    'discount': discount,
    'device': device,
  };
}

