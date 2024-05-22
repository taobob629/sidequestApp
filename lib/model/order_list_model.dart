class OrderListModel {
  double? total;
  String? orderTime;
  int? id;
  List<OrderItem> items = [];
  int? status;

  OrderListModel({
    this.total,
    this.orderTime,
    this.id,
    required this.items,
    this.status,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        total: json["total"],
        orderTime: json["orderTime"],
        id: json["id"],
        items: json["items"] == null
            ? []
            : List<OrderItem>.from(
                json["items"]!.map((x) => OrderItem.fromJson(x))),
        status: json["status"],
      );
}

class OrderItem {
  String? name;
  String? picUrl;
  int? num;
  double? retailPrice;

  OrderItem({
    this.name,
    this.num,
    this.picUrl,
    this.retailPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        num: json["num"],
        picUrl: json["picUrl"],
        name: json["name"],
        retailPrice: json["retailPrice"],
      );
}

class Specifications {
  String? cupSize;
  String? ice;
  String? sugar;

  Specifications({
    this.cupSize,
    this.ice,
    this.sugar,
  });

  factory Specifications.fromJson(Map<String, dynamic> json) => Specifications(
        cupSize: json["CupSize"],
        ice: json["Ice"],
        sugar: json["Sugar"],
      );

  Map<String, dynamic> toJson() => {
        "CupSize": cupSize,
        "Ice": ice,
        "Sugar": sugar,
      };
}
