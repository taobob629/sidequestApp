import 'package:wy/model/safe_convert.dart';

class OrderDetailModel {
  // 1
  final int amount;

  // PA20230321167586
  final String orderSn;

  final String userAvatar;

  final String skillThumb;

  // 青柠
  final String nickName;

  // 0
  final int discount;

  // Naraka：Bladepoint
  final String skillName;

  // Hour
  final String unit;

  // 60
  final int total;

  // naraka
  final String serviceItemName;

  // UK2022635757
  final String uk;

  // 65926
  final int pwId;

  // 60
  final int price;

  // 60
  final int subtotal;

  // Mar 21,2023 04:51 PM
  final String time;

  // 2
  final int status;

  OrderDetailModel({
    this.amount = 0,
    this.skillThumb='',
    this.userAvatar='',
    this.orderSn = "",
    this.nickName = "",
    this.discount = 0,
    this.skillName = "",
    this.unit = "",
    this.total = 0,
    this.serviceItemName = "",
    this.uk = "",
    this.pwId = 0,
    this.price = 0,
    this.subtotal = 0,
    this.time = "",
    this.status = 0,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic>? json) => OrderDetailModel(
        amount: asT<int>(json, 'amount'),
        orderSn: asT<String>(json, 'orderSn'),
        skillThumb: asT<String>(json, 'skillThumb'),
        userAvatar: asT<String>(json, 'userAvatar'),
        nickName: asT<String>(json, 'nickName'),
        discount: asT<int>(json, 'discount'),
        skillName: asT<String>(json, 'skillName'),
        unit: asT<String>(json, 'unit'),
        total: asT<int>(json, 'total'),
        serviceItemName: asT<String>(json, 'serviceItemName'),
        uk: asT<String>(json, 'uk'),
        pwId: asT<int>(json, 'pwId'),
        price: asT<int>(json, 'price'),
        subtotal: asT<int>(json, 'subtotal'),
        time: asT<String>(json, 'time'),
        status: asT<int>(json, 'status'),
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'orderSn': orderSn,
        'nickName': nickName,
        'discount': discount,
        'skillName': skillName,
        'unit': unit,
        'total': total,
        'serviceItemName': serviceItemName,
        'uk': uk,
        'pwId': pwId,
        'price': price,
        'subtotal': subtotal,
        'time': time,
        'status': status,
      };
}
