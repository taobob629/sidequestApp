class MatchOrderPlayer {
  MatchOrderPlayer({
    required this.memberCode,
    required this.types,
    required this.gid,
    required this.category,
    required this.orderId,
    required this.sex,
    required this.language,
    required this.avatar,
    required this.uid,
    required this.unit,
    required this.game,
    required this.createTime,
    required this.minPrice,
    required this.nickname,
    required this.id,
    required this.maxPrice,
    required this.age,
  });

  String memberCode;
  String types;
  int gid;
  String category;
  int orderId;
  int sex;
  String language;
  String avatar;
  int uid;
  String unit;
  String game;
  String createTime;
  int minPrice;
  String nickname;
  int id;
  int maxPrice;
  int age;

  factory MatchOrderPlayer.fromJson(Map<String, dynamic> json) => MatchOrderPlayer(
    memberCode: json["memberCode"],
    types: json["types"],
    gid: json["gid"],
    category: json["Category"],
    orderId: json["orderId"],
    sex: json["sex"],
    language: json["language"],
    avatar: json["avatar"],
    uid: json["uid"],
    unit: json["unit"],
    game: json["Game"],
    createTime: json["createTime"],
    minPrice: json["minPrice"],
    nickname: json["nickname"],
    id: json["id"],
    maxPrice: json["maxPrice"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "memberCode": memberCode,
    "types": types,
    "gid": gid,
    "Category": category,
    "orderId": orderId,
    "sex": sex,
    "language": language,
    "avatar": avatar,
    "uid": uid,
    "unit": unit,
    "Game": game,
    "createTime": createTime,
    "minPrice": minPrice,
    "nickname": nickname,
    "id": id,
    "maxPrice": maxPrice,
    "age": age,
  };
}
