
import 'package:wy/model/safe_convert.dart';
class CouponModel {
  static const int AVILABLE = 1;
  late int id = 0;
  late String name = "";
  late String description = "";
  late int type = 0;
  late String expireTime = "";
  late int _discount = 0;
  late String limitStore = "";
  late String productId = "0";
  late int freeTime = 0;
  late String couponCode = "";
  late String typeName = "";
  late String qrcode = "";
  late String unit = "";
  late int usedCount = 0;
  late int available = 0; //

  String get discount => unit == 'OFF' ? '$_discount%' :type==4?'£$_discount    ':'$_discount';

  @override
  String toString() {
    return 'CouponModel{id: $id, name: $name, description: $description, type: $type, expireTime: $expireTime, discount: $_discount, limitStore: $limitStore, productId: $productId, freeTime: $freeTime, couponCode: $couponCode, typeName: $typeName, qrcode: $qrcode, unit: $unit, usedCount: $usedCount}';
  }

  CouponModel();

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['coupon']['id'];
    name = json['coupon']['name'] == null ? "" : json['coupon']['name'];
    _discount = json['coupon']['discount'] == null ? 0 : json['coupon']['discount'];
    type = json['coupon']['type'];
    expireTime = json['coupon']['expireTime'] == null ? "" : json['coupon']['expireTime'].toString().substring(0, 10);
    description = json['coupon']['description'] == null ? "" : json['coupon']['description'];
    limitStore = json['coupon']['limitStore'] == null ? "" : json['coupon']['limitStore'];
    freeTime = json['coupon']['freeTime'] ?? 0;
    productId = json['coupon']['productId'] == null ? "0" : json['coupon']['productId'];
    couponCode = json['coupon']['code'] == null ? "" : json['coupon']['code'];
    typeName = json['type'] == null ? "" : json['type'];
    qrcode = json['qrcode'] == null ? "" : json['qrcode'];
    unit = json['unit'] == null ? "" : json['unit'];
    available = json['available'] == null ? "" : json['available'];
    usedCount = json['usedCount'] == null ? 0 : json['usedCount'];
  }
}


class ActivityDiscountModel {
  // 5.0
  final double total;
  // 0.00
  final String balance;
  // 5.0
  final String subtotal;
  // 0
  final String discount;

  ActivityDiscountModel({
    this.total = 0.0,
    this.balance = "",
    this.subtotal = "",
    this.discount = "",
  });

  factory ActivityDiscountModel.fromJson(Map<String, dynamic>? json) => ActivityDiscountModel(
    total: asT<double>(json, 'total'),
    balance: asT<String>(json, 'balance'),
    subtotal: asT<String>(json, 'subtotal'),
    discount: asT<String>(json, 'discount'),
  );

  Map<String, dynamic> toJson() => {
    'total': total,
    'balance': balance,
    'subtotal': subtotal,
    'discount': discount,
  };
}