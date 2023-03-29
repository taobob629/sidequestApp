import '../../ui/frame/profile/other_profile/mdoel/player_info_mdoel.dart';

class MatchPlayModel {
  MatchPlayModel({
    required this.total,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.serviceItems,
    required this.couponId,
    required this.coin,
    required this.bossfee,
  });

  int total;
  int subtotal;
  int discount;
  int tax;
  List<ServiceItem> serviceItems;
  int couponId;
  int coin;
  double bossfee;

  factory MatchPlayModel.fromJson(Map<String, dynamic> json) => MatchPlayModel(
    total: json["total"],
    subtotal: json["subtotal"],
    discount: json["discount"],
    tax: json["tax"],
    serviceItems: List<ServiceItem>.from(json["serviceItems"].map((x) => ServiceItem.fromJson(x))),
    couponId: json["couponId"],
    coin: json["coin"],
    bossfee: json["bossfee"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "subtotal": subtotal,
    "discount": discount,
    "tax": tax,
    "serviceItems": List<dynamic>.from(serviceItems.map((x) => x.toJson())),
    "couponId": couponId,
    "coin": coin,
    "bossfee": bossfee,
  };
}