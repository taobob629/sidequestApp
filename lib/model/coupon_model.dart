
class CouponModel {
  late int id = 0;
  late String name = "";
  late String description = "";
  late int type = 0;
  late String expireTime = "";
  late int discount = 0;
  late String limitStore = "";
  late String productId = "0";
  late int freeTime = 0;
  late String couponCode = "";
  late String typeName = "";
  late String qrcode = "";
  late String unit = "";
  late int usedCount = 0;

  CouponModel();

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['coupon']['id'];
    name = json['coupon']['name'] == null ? "" : json['coupon']['name'];
    discount =
        json['coupon']['discount'] == null ? 0 : json['coupon']['discount'];
    type = json['coupon']['type'];
    expireTime = json['coupon']['expireTime'] == null
        ? ""
        : json['coupon']['expireTime'].toString().substring(0, 10);
    description = json['coupon']['description'] == null
        ? ""
        : json['coupon']['description'];
    limitStore = json['coupon']['limitStore'] == null
        ? ""
        : json['coupon']['limitStore'];
    freeTime = json['coupon']['freeTime'] ?? 0;
    productId =
        json['coupon']['productId'] == null ? "0" : json['coupon']['productId'];
    couponCode = json['coupon']['code'] == null ? "" : json['coupon']['code'];
    typeName = json['type'] == null ? "" : json['type'];
    qrcode = json['qrcode'] == null ? "" : json['qrcode'];
    unit = json['unit'] == null ? "" : json['unit'];
    usedCount = json['usedCount'] == null ? 0 : json['usedCount'];
  }
}