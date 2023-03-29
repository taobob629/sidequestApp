import 'package:wy/model/match_init_model.dart';

class MatchOperationModel {
  MatchOperationModel({
    required this.memberCode,
    required this.pirce,
    required this.serviceItemId,
    required this.birthday,
    required this.levelNameEn,
    required this.orderId,
    required this.skillAuthId,
    required this.sex,
    required this.avatar,
    required this.stars,
    required this.label,
    required this.levelid,
    required this.nickname,
    required this.liveuid,
    required this.orderInfo,
    required this.age,
  });

  String memberCode;
  dynamic pirce;
  int serviceItemId;
  int birthday;
  String levelNameEn;
  int orderId;
  int skillAuthId;
  int sex;
  String avatar;
  dynamic stars;
  List<dynamic> label;
  int levelid;
  String nickname;
  int liveuid;
  OrderInfo orderInfo;
  int age;

  factory MatchOperationModel.fromJson(Map<String, dynamic> json) => MatchOperationModel(
    memberCode: json["memberCode"],
    pirce: json["pirce"],
    serviceItemId: json["serviceItemId"],
    birthday: json["birthday"],
    levelNameEn: json["levelNameEn"],
    orderId: json["orderId"],
    skillAuthId: json["skillAuthId"],
    sex: json["sex"],
    avatar: json["avatar"],
    stars: json["stars"],
    label: List<dynamic>.from(json["label"].map((x) => x)),
    levelid: json["levelid"],
    nickname: json["nickname"],
    liveuid: json["liveuid"],
    orderInfo: OrderInfo.fromJson(json["orderInfo"]),
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "memberCode": memberCode,
    "pirce": pirce,
    "serviceItemId": serviceItemId,
    "birthday": birthday,
    "levelNameEn": levelNameEn,
    "orderId": orderId,
    "skillAuthId": skillAuthId,
    "sex": sex,
    "avatar": avatar,
    "stars": stars,
    "label": List<dynamic>.from(label.map((x) => x)),
    "levelid": levelid,
    "nickname": nickname,
    "liveuid": liveuid,
    "orderInfo": orderInfo.toJson(),
    "age": age,
  };
}

class OrderInfo {
  OrderInfo({
    required this.uid,
    required this.unit,
    required this.types,
    required this.gid,
    required this.category,
    required this.game,
    required this.createTime,
    required this.minPrice,
    required this.language,
    required this.id,
    required this.maxPrice,
  });

  int uid;
  String unit;
  List<Language> types;
  int gid;
  String category;
  String game;
  String createTime;
  int minPrice;
  String language;
  int id;
  int maxPrice;

  factory OrderInfo.fromJson(Map<String, dynamic> json) => OrderInfo(
    uid: json["uid"],
    unit: json["unit"],
    types: List<Language>.from(json["types"].map((x) => Language.fromJson(x))),
    gid: json["gid"],
    category: json["Category"],
    game: json["Game"],
    createTime: json["createTime"],
    minPrice: json["minPrice"],
    language: json["language"],
    id: json["id"],
    maxPrice: json["maxPrice"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "unit": unit,
    "types": List<dynamic>.from(types.map((x) => x.toJson())),
    "gid": gid,
    "Category": category,
    "Game": game,
    "createTime": createTime,
    "minPrice": minPrice,
    "language": language,
    "id": id,
    "maxPrice": maxPrice,
  };
}
