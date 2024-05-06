import 'dart:convert';

import 'package:get/get.dart';

import '../../../../../model/player_info_mdoel.dart';

class PlayerInfoModel {
  RxString _voice = ''.obs;
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
  int maxIntimacy = 0;
  var currentIntimacy = 0.obs;
  String intimacyLevel = "";
  List<GamesItem> games = [];
  bool online = false;
  CountryModel location = CountryModel();
  double ranking = 0.0;
  int age = 0;
  int uid = 0;
  String uk = "";
  List<TrophieModel> trophies = [];

  String get voice => _voice.value;

  set voice(String value) {
    _voice.value = value;
  }

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
    uk = json['uk'] ?? uk;
    followers = json['followers'] ?? followers;
    backGround = json['backGround'] ?? backGround;
    userLevel = json['userLevel'] ?? userLevel;
    maxIntimacy = json['maxIntimacy'] ?? maxIntimacy;
    if (maxIntimacy == 0) {
      maxIntimacy = 1000;
    }
    currentIntimacy.value = json['currentIntimacy'] ?? currentIntimacy.value;
    intimacyLevel = json['intimacyLevel'] ?? intimacyLevel;
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
    var loc = json["country"].toString();
    if (loc.isNotEmpty && loc != "null") {
      location = CountryModel.fromJson(jsonDecode(loc.replaceAll("""\\""", """\\\\""")));
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
  String gameVoice = "";
  int orders = 0;
  int id = 0;
  int isTech = 0;

  var ifShow = false.obs;

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
    gameVoice = json['gameVoice'] ?? gameVoice;
    orders = json['orders'] ?? orders;
    id = json['id'] ?? id;
    isTech = json['isTech'] ?? isTech;
  }
}

class TrophieModel {
  int id = 0;
  String iconName = "";
  String iconImage = "";
  String iconLightImage="";
  String tips = "";
  bool lighted = false;
  int medalType = 0;
  int threshold = 0;

  TrophieModel({
    this.id = 0,
    this.iconName = "",
    this.iconImage = "",
    this.iconLightImage = "",
    this.tips = "",
    this.lighted = false,
    this.medalType = 0,
    this.threshold = 0,
  });

  TrophieModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    iconName = json["iconName"] ?? "";
    iconImage = json["iconImage"] ?? "";
    iconLightImage = json["iconLightImage"] ?? "";
    tips = json["tips"] ?? "";
    lighted = json["lighted"] ?? false;
    medalType = json["medalType"] ?? 0;
    threshold = json["threshold"] ?? 0;
  }
}
