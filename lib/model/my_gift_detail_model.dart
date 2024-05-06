class MyGiftDetailModel {
  String giftImage;
  String orderId;
  String giftName;
  int num;
  int discount;
  String avatar;
  int userId;
  int total;
  String uk;
  String price;
  int addtime;
  int subtotal;
  String nickname;

  MyGiftDetailModel({
    required this.giftImage,
    required this.orderId,
    required this.giftName,
    required this.num,
    required this.discount,
    required this.avatar,
    required this.userId,
    required this.total,
    required this.uk,
    required this.price,
    required this.addtime,
    required this.subtotal,
    required this.nickname,
  });

  factory MyGiftDetailModel.fromJson(Map<String, dynamic> json) => MyGiftDetailModel(
    giftImage: json["giftImage"] ?? '',
    orderId: json["orderId"] ?? '',
    giftName: json["giftName"] ?? '',
    num: json["num"] ?? 0,
    discount: json["discount"] ?? 0,
    avatar: json["avatar"] ?? '',
    userId: json["userId"] ?? 0,
    total: json["total"] ?? 0,
    uk: json["uk"] ?? '',
    price: json["price"] ?? '',
    addtime: json["addtime"] ?? 0,
    subtotal: json["subtotal"] ?? 0,
    nickname: json["nickname"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "giftImage": giftImage,
    "orderId": orderId,
    "giftName": giftName,
    "num": num,
    "discount": discount,
    "avatar": avatar,
    "userId": userId,
    "total": total,
    "uk": uk,
    "price": price,
    "addtime": addtime,
    "subtotal": subtotal,
    "nickname": nickname,
  };
}
