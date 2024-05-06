class IntegralGoodsDetailModel {
  bool? enoughPoint;
  List<Coupon> coupons;
  int? price;
  int? myPoints;
  String? name;
  String? pic;

  IntegralGoodsDetailModel({
    this.enoughPoint,
    required this.coupons,
    this.price,
    this.myPoints,
    this.name,
    this.pic,
  });

  factory IntegralGoodsDetailModel.fromJson(Map<String, dynamic> json) => IntegralGoodsDetailModel(
    enoughPoint: json["enoughPoint"],
    coupons: json["coupons"] == null ? [] : List<Coupon>.from(json["coupons"]!.map((x) => Coupon.fromJson(x))),
    price: json["price"],
    name: json["name"],
    pic: json["pic"],
    myPoints: json["myPoints"],
  );

  Map<String, dynamic> toJson() => {
    "enoughPoint": enoughPoint,
    "coupons": List<dynamic>.from(coupons!.map((x) => x.toJson())),
    "price": price,
    "name": name,
    "pic": pic,
    "myPoints": myPoints,
  };
}

class Coupon {
  String? couponName;

  Coupon({
    this.couponName,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    couponName: json["couponName"],
  );

  Map<String, dynamic> toJson() => {
    "couponName": couponName,
  };
}
