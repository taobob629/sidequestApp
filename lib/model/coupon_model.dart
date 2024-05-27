import 'package:sq_hub_app/model/safe_convert.dart';

class CouponOurModel {
  late int gaming = 0;
  late int product = 0;
  late int event = 0;
  late List<CouponsListModel> coupons = [];

  CouponOurModel({
    required this.gaming,
    required this.product,
    required this.coupons,
    required this.event,
  });

  factory CouponOurModel.fromJson(Map<String, dynamic> json) => CouponOurModel(
        gaming: json["gaming"],
        product: json["product"],
        coupons: json["coupons"] == null
            ? []
            : List<CouponsListModel>.from(
                json["coupons"]!.map((x) => CouponsListModel.fromJson(x))),
        event: json["event"],
      );
}

class CouponsListModel {
  late int id = 0;
  late String typeName = "";
  late String unit = "";
  late CouponModel couponModel;

  CouponsListModel();

  CouponsListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeName = json['type'] == null ? "" : json['type'];
    unit = json['unit'] == null ? "" : json['unit'];
    couponModel = json["coupon"] == null
        ? CouponModel()
        : CouponModel.fromJson(json["coupon"], unit: unit);
  }
}

class CouponModel {
  static const int AVILABLE = 1;
  late int id = 0;
  late String name = "";
  late String description = "";
  late int type = 0;
  late String expireTime = "";
  late String unit = "";
  late int _discount = 0;
  late String limitStore = "";
  late String productId = "0";
  late int freeTime = 0;
  late String couponCode = "";
  late String qrcode = "";
  late int usedCount = 0;
  late int available = 0; //
  late List<String> stores = []; //

  String get discount => unit == 'OFF'
      ? '$_discount%'
      : type == 4
          ? '£$_discount    '
          : '$_discount';

  @override
  String toString() {
    return 'CouponModel{id: $id, name: $name, description: $description, type: $type, expireTime: $expireTime, discount: $_discount, limitStore: $limitStore, productId: $productId, freeTime: $freeTime, couponCode: $couponCode, qrcode: $qrcode, unit: $unit, usedCount: $usedCount}';
  }

  CouponModel();

  CouponModel.fromJson(
    Map<String, dynamic> json, {
    String unit = '',
    bool needHourMinSec = false,
  }) {
    this.unit = unit;
    id = json['id'];
    name = json['name'] == null ? "" : json['name'];
    _discount = json['discount'] == null ? 0 : json['discount'];
    type = json['type'];
    if (needHourMinSec) {
      expireTime =
          json['expireTime'] == null ? "" : json['expireTime'].toString();
    } else {
      expireTime = json['expireTime'] == null
          ? ""
          : json['expireTime'].toString().substring(0, 10);
    }
    description = json['description'] == null ? "" : json['description'];
    limitStore = json['limitStore'] == null ? "" : json['limitStore'];
    freeTime = json['freeTime'] ?? 0;
    productId = json['productId'] == null ? "0" : json['productId'];
    couponCode = json['code'] == null ? "" : json['code'];
    qrcode = json['qrcode'] == null ? "" : json['qrcode'];
    available = json['available'] == null ? 0 : json['available'];
    stores = json["stores"] == null
        ? []
        : List<String>.from(json["stores"]!.map((x) => x));
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

  factory ActivityDiscountModel.fromJson(Map<String, dynamic>? json) =>
      ActivityDiscountModel(
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
