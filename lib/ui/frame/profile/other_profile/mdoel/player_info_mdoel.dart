import 'dart:convert';

import 'package:get/get.dart';

class PlayerInfoModel {
  String voice = "";
  String signature = "";
  String nickName = "";
  String language = "";
  String avatar = "";
  bool follow = false;
  int sex = 0;
  int fans = 0;
  int followers = 0;
  bool isAuth = false;
  String backGround = "";
  int userLevel = 0;
  List<GamesItem> games = [];
  bool online = false;
  CountryModel location = CountryModel();
  double ranking = 0.0;
  int age = 0;
  int uid = 0;
  List<TrophieModel> trophies = [];

  PlayerInfoModel();

  PlayerInfoModel.fromJson(Map<String, dynamic> json) {
    voice = json['voice'] ?? voice;
    signature = json['signature'] ?? signature;
    nickName = json['nickName'] ?? nickName;
    language = json['language'] ?? language;
    avatar = json['avatar'] ?? avatar;
    follow = json['follow'] == 1;
    fans = json['fans'] ?? fans;
    sex = json['sex'] ?? sex;
    followers = json['followers'] ?? followers;
    backGround = json['backGround'] ?? backGround;
    userLevel = json['userLevel'] ?? userLevel;
    if (json['games'] != null) {
      games = <GamesItem>[];
      json['games'].forEach((v) {
        games.add(GamesItem.fromJson(v));
      });
    }
    trophies = json["trophies"] != null ? json["trophies"].map<TrophieModel>((e) => TrophieModel.fromJson(e)).toList() : [];
    isAuth = json['isAuth'] == 1;
    online = json['online'] == 1;
    ranking = json['ranking'] ?? ranking;
    age = json['age'] ?? age;
    if ((json["country"] is String)) {
      location = CountryModel.fromJson(jsonDecode(json["location"].replaceAll("""\\""", """\\\\""")));
    } else {
      location = CountryModel();
    }
  }
}

class CountryModel {
  String country = "";
  String emoji = "";
  String city = "";
  String state = "";

  CountryModel({
    this.country = "",
    this.emoji = "",
    this.city = "",
    this.state = "",
  });

  CountryModel.fromJson(Map<String, dynamic> json) {
    country = json["country"] ?? "";
    emoji = json["emoji"] ?? "";
    city = json["city"] ?? "";
    state = json["state"] ?? "";
  }
}

class GamesItem {
  List<ServiceItem> serviceItem = [];
  double star = 0.0;
  String thumb = "";
  String level = "";
  String name = "";
  int orders = 0;
  int id = 0;

  GamesItem();

  GamesItem.fromJson(Map<String, dynamic> json) {
    if (json['serviceItem'] != null) {
      serviceItem = <ServiceItem>[];
      json['serviceItem'].forEach((v) {
        serviceItem.add(new ServiceItem.fromJson(v));
      });
    }
    star = json['star'] ?? star;
    thumb = json['thumb'] ?? thumb;
    level = json['level'] ?? level;
    name = json['name'] ?? name;
    orders = json['orders'] ?? orders;
    id = json['id'] ?? id;
  }
}

class ServiceItem {
  int id = 0;
  String name = "";
  int uid = 0;
  String skillName = "";
  int skillid = 0;
  int levelId = 0;
  String price = "";
  String unit = "";
  bool enabled = false;
  int skillAuthid = 0;
  String createTime = "";
  bool isDefault = false;
  String avatar = "";
  RxInt num = RxInt(1);
  ServiceItem();

  ServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? id;
    name = json['name'] ?? name;
    uid = json['uid'] ?? uid;
    skillName = json['skillName'] ?? skillName;
    skillid = json['skillid'] ?? skillid;
    levelId = json['levelId'] ?? levelId;
    price = json['price'] ?? price;
    unit = json['unit'] ?? unit;
    enabled = json['enabled'] == 1;
    skillAuthid = json['skillAuthid'] ?? skillAuthid;
    createTime = json['createTime'] ?? createTime;
    avatar = json['avatar'] ?? avatar;

    isDefault = json['isDefault'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['uid'] = this.uid;
    data['skillName'] = this.skillName;
    data['skillid'] = this.skillid;
    data['levelId'] = this.levelId;
    data['price'] = this.price;
    data['unit'] = this.unit;
    data['enabled'] = this.enabled;
    data['skillAuthid'] = this.skillAuthid;
    data['createTime'] = this.createTime;
    data['isDefault'] = this.isDefault;
    data["avatar"] = this.avatar;
    return data;
  }
}

class TrophieModel {
  int id = 0;
  String iconName = "";
  String iconImage = "";
  String tips = "";
  bool lighted = false;
  int medalType = 0;
  int threshold = 0;

  TrophieModel({
    this.id = 0,
    this.iconName = "",
    this.iconImage = "",
    this.tips = "",
    this.lighted = false,
    this.medalType = 0,
    this.threshold = 0,
  });

  TrophieModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    iconName = json["iconName"] ?? "";
    iconImage = json["iconImage"] ?? "";
    tips = json["tips"] ?? "";
    lighted = json["lighted"] ?? false;
    medalType = json["medalType"] ?? 0;
    threshold = json["threshold"] ?? 0;
  }
}
