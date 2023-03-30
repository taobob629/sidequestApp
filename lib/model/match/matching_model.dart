// To parse this JSON data, do
//
//     final matchingModel = matchingModelFromJson(jsonString);

import 'dart:convert';

import 'package:wy/model/match_init_model.dart';

MatchingModel matchingModelFromJson(String str) => MatchingModel.fromJson(json.decode(str));

String matchingModelToJson(MatchingModel data) => json.encode(data.toJson());

class MatchingModel {
  MatchingModel({
    required this.types,
    required this.gid,
    required this.category,
    required this.orderId,
    required this.players,
    required this.language,
    required this.uid,
    required this.unit,
    required this.game,
    required this.createTime,
    required this.minPrice,
    required this.id,
    required this.maxPrice,
    required this.distance,
  });

  List<Language> types;
  int gid;
  int distance;
  String category;
  int orderId;
  List<Player> players;
  String language;
  int uid;
  String unit;
  String game;
  String createTime;
  int minPrice;
  int id;
  int maxPrice;

  factory MatchingModel.fromJson(Map<String, dynamic> json) => MatchingModel(
    types: List<Language>.from(json["types"].map((x) => Language.fromJson(x))),
    gid: json["gid"],
    category: json["Category"],
    orderId: json["orderId"],
    players: List<Player>.from(json["players"].map((x) => Player.fromJson(x))),
    language: json["language"],
    uid: json["uid"],
    unit: json["unit"],
    game: json["Game"],
    createTime: json["createTime"],
    minPrice: json["minPrice"],
    id: json["id"],
    maxPrice: json["maxPrice"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "types": List<dynamic>.from(types.map((x) => x.toJson())),
    "gid": gid,
    "Category": category,
    "orderId": orderId,
    "players": List<dynamic>.from(players.map((x) => x.toJson())),
    "language": language,
    "uid": uid,
    "unit": unit,
    "Game": game,
    "createTime": createTime,
    "minPrice": minPrice,
    "id": id,
    "maxPrice": maxPrice,
  };
}

class Player {
  Player({
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
    required this.age,
  });

  String memberCode;
  String pirce;
  int serviceItemId;
  int birthday;
  String levelNameEn;
  int orderId;
  int skillAuthId;
  int sex;
  String avatar;
  String stars;
  List<dynamic> label;
  int levelid;
  String nickname;
  int liveuid;
  int age;

  factory Player.fromJson(Map<String, dynamic> json) => Player(
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
    "age": age,
  };
}
