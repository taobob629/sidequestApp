
import 'safe_convert.dart';
class QrLoginModel {
  final int code;
  // No
  final String gamingFree;
  // 57M
  final String estimatedtime;
  // 28.50
  final String balance;
  // 0H0M
  final String freetime;
  // 1687704878
  final int estimatedDatetime;
  // 30
  final String price;
  // 0.0% OFF
  final String discount;
  // CX-BR-1
  final String device;

  QrLoginModel({
    this.gamingFree = "",
    this.estimatedtime = "",
    this.balance = "",
    this.freetime = "",
    this.estimatedDatetime = 0,
    this.code = 200,
    this.price = "",
    this.discount = "",
    this.device = "",
  });

  factory QrLoginModel.fromJson(Map<String, dynamic>? json) => QrLoginModel(
    gamingFree: asT<String>(json, 'gamingFree'),
    estimatedtime: asT<String>(json, 'estimatedtime'),
    balance: asT<String>(json, 'balance'),
    freetime: asT<String>(json, 'freetime'),
    estimatedDatetime: asT<int>(json, 'estimatedDatetime'),
    code: asT<int>(json, 'code',defaultValue: 0),
    price: asT<String>(json, 'price'),
    discount: asT<String>(json, 'discount'),
    device: asT<String>(json, 'device'),
  );


  @override
  String toString() {
    return 'QrLoginModel{code: $code, gamingFree: $gamingFree, estimatedtime: $estimatedtime, balance: $balance, freetime: $freetime, estimatedDatetime: $estimatedDatetime, price: $price, discount: $discount, device: $device}';
  }

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

