class GiftModel {
  int total;
  List<GiftListModel> rows;

  GiftModel({
    required this.total,
    required this.rows,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
    total: json["total"],
    rows: List<GiftListModel>.from(json["rows"].map((x) => GiftListModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
  };
}

class GiftListModel {
  int id;
  String name;
  int nums;
  int price;
  int total;
  int discount;
  int profit;
  int uid;
  int liveId;
  int status;
  int giftId;
  int source;
  String orderNo;
  int postId;
  int createTime;
  String image;

  GiftListModel({
    required this.id,
    required this.name,
    required this.nums,
    required this.price,
    required this.total,
    required this.discount,
    required this.profit,
    required this.uid,
    required this.liveId,
    required this.status,
    required this.giftId,
    required this.source,
    required this.orderNo,
    required this.postId,
    required this.createTime,
    required this.image,
  });

  factory GiftListModel.fromJson(Map<String, dynamic> json) => GiftListModel(
    id: json["id"],
    name: json["name"],
    nums: json["nums"],
    price: json["price"],
    total: json["total"],
    discount: json["discount"],
    profit: json["profit"],
    uid: json["uid"],
    liveId: json["liveId"],
    status: json["status"],
    giftId: json["giftId"],
    source: json["source"],
    orderNo: json["orderNo"],
    postId: json["postId"],
    createTime: json["createTime"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "nums": nums,
    "price": price,
    "total": total,
    "discount": discount,
    "profit": profit,
    "uid": uid,
    "liveId": liveId,
    "status": status,
    "giftId": giftId,
    "source": source,
    "orderNo": orderNo,
    "postId": postId,
    "createTime": createTime,
    "image": image,
  };
}
