import 'package:sq_hub_app/model/order_detail_new_model.dart';

class BubbleConfirmOrderModel {
  OrderInfo? orderInfo;

  BubbleConfirmOrderModel({
    this.orderInfo,
  });

  factory BubbleConfirmOrderModel.fromJson(Map<String, dynamic> json) => BubbleConfirmOrderModel(
    orderInfo: json["orderInfo"] == null ? null : OrderInfo.fromJson(json["orderInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "orderInfo": orderInfo?.toJson(),
  };
}

class OrderInfo {
  double? total;
  double? subTotal;
  String? address;
  String? orderTime;
  String? orderSn;
  int? id;
  double? discount;
  int? statusValue;
  String? storeName;
  String? payment;
  List<OrderDetailItem> items = [];
  String? pickNum;
  String? status;

  OrderInfo({
    this.total,
    this.subTotal,
    this.address,
    this.orderTime,
    this.orderSn,
    this.id,
    this.discount,
    this.statusValue,
    this.storeName,
    this.payment,
    required this.items,
    this.pickNum,
    this.status,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) => OrderInfo(
    total: json["total"]?.toDouble(),
    subTotal: json["subTotal"]?.toDouble(),
    address: json["address"],
    orderTime: json["orderTime"],
    orderSn: json["orderSn"],
    id: json["id"],
    discount: json["discount"],
    statusValue: json["statusValue"],
    storeName: json["storeName"],
    payment: json["payment"],
    items: json["items"] == null ? [] : List<OrderDetailItem>.from(json["items"]!.map((x) => OrderDetailItem.fromJson(x))),
    pickNum: json["pickNum"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "subTotal": subTotal,
    "address": address,
    "orderTime": orderTime,
    "orderSn": orderSn,
    "id": id,
    "discount": discount,
    "statusValue": statusValue,
    "storeName": storeName,
    "payment": payment,
    "items": items == null ? [] : List<dynamic>.from(items.map((x) => x.toJson())),
    "pickNum": pickNum,
    "status": status,
  };
}