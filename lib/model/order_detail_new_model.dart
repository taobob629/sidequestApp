class OrderDetailNewModel {
  double? total;
  String? address;
  String? orderTime;
  String? orderSn;
  double? discount;
  String? storeName;
  String? payment;
  List<OrderDetailItem> items = [];
  String? pickNum;
  String? status;
  int reward = 0;

  OrderDetailNewModel({
    this.total,
    this.address,
    this.orderTime,
    this.orderSn,
    this.discount,
    this.storeName,
    this.payment,
    required this.items,
    this.pickNum,
    this.status,
    required this.reward,
  });

  factory OrderDetailNewModel.fromJson(Map<String, dynamic> json) => OrderDetailNewModel(
    total: json["total"]?.toDouble(),
    address: json["address"],
    orderTime: json["orderTime"],
    orderSn: json["orderSN"],
    discount: json["discount"],
    storeName: json["storeName"],
    payment: json["payment"],
    items: json["items"] == null ? [] : List<OrderDetailItem>.from(json["items"]!.map((x) => OrderDetailItem.fromJson(x))),
    pickNum: json["pickNum"],
    status: json["status"],
    reward: json["reward"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "address": address,
    "orderTime": orderTime,
    "orderSN": orderSn,
    "discount": discount,
    "storeName": storeName,
    "payment": payment,
    "items": items == null ? [] : List<dynamic>.from(items.map((x) => x.toJson())),
    "pickNum": pickNum,
    "status": status,
  };
}

class OrderDetailItem {
  String? picUrl;
  int? num;
  String? name;
  double? retailPrice;

  OrderDetailItem({
    this.picUrl,
    this.num,
    this.name,
    this.retailPrice,
  });

  factory OrderDetailItem.fromJson(Map<String, dynamic> json) => OrderDetailItem(
    picUrl: json["picUrl"],
    num: json["num"],
    name: json["name"],
    retailPrice: json["retailPrice"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "picUrl": picUrl,
    "num": num,
    "name": name,
    "retailPrice": retailPrice,
  };
}
