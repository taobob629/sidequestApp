import 'dart:convert';

import 'package:get/get.dart';
import 'package:wy/model/safe_convert.dart';

class ProfileModel {
  int memberId = 0;
  int pwId = 0;
  String backGround = "";
  RxString? voice = "".obs;
  String language = "";
  String signature = "";
  int isAuth = 0;
  int sidekickLevel = 1;
  CountryModel location = CountryModel();
  String nickName = "";
  int fans = 0;
  int visitor = 0;
  int visitorToday = 0;
  int vipLevel = 0;
  int followers = 0;
  int followerToday = 0;
  String balance = "0.00";
  String uk = "";
  List<TrophieModel> trophies = [];
  int gender = 1;
  String avatar = "";
  int coin = 0;
  int userAvatar = 0;
  int integralTotal = 0;
  int nexIntegralNumber = 0;
  int lv = 0;
  int checkTotal = 0;
  String email = "";
  String describe = "";
  int age = 0;
  List<VipModel> vips = [];
  List<AdModel> ads = [];
  int coupons = 0;
  double ranking = 0.0;
  int postNum = 0;
  int orderNum = 0;
  int taskNum = 0;
  int service = 0;
  int orders = 0;
  int giftOrderNum = 0;
  int sidekickNum = 0;
  String diamond = "";
  String phone = "";
  List<BadgesItem> badges = [];
  bool vipCanceled = false;
  int totalmins = 0;
  int avamins = 0;

  balanceMoney() {
    return '£$balance';
  }

  ProfileModel(
      {this.language = "",
      this.signature = "",
      this.voice,
      this.totalmins = 0,
      this.avamins = 0,
      this.isAuth = 0,
      this.sidekickLevel = 1,
      this.nickName = "",
      this.fans = 0,
      this.visitor = 0,
      this.visitorToday = 0,
      this.vipLevel = 0,
      this.followers = 0,
      this.followerToday = 0,
      this.balance = "0.00",
      this.uk = "",
      this.trophies = const [],
      this.badges = const [],
      this.gender = 1,
      this.avatar = "",
      this.coin = 0,
      this.userAvatar = 0,
      this.integralTotal = 0,
      this.nexIntegralNumber = 0,
      this.lv = 0,
      this.checkTotal = 0,
      this.email = "",
      this.describe = "",
      this.age = 0,
      this.vips = const [],
      this.ads = const [],
      this.coupons = 0,
      this.ranking = 0,
      this.postNum = 0,
      this.orderNum = 0,
      this.taskNum = 0,
      this.service = 0,
      this.orders = 0,
      this.giftOrderNum = 0,
      this.sidekickNum = 0,
      this.diamond = "",
      this.vipCanceled = false});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    language = json["language"] ?? "";
    voice?.value = json["voice"] ?? "";
    isAuth = json["isAuth"] ?? 0;
    sidekickLevel = json["sidekickLevel"] ?? 1;
    memberId = json["memberId"] ?? 0;
    backGround = json["backGround"] ?? "";
    signature = json["signature"] ?? "";
    pwId = json["pwId"] ?? 0;
    var loc = json["country"].toString();
    if (loc.isNotEmpty && loc != "null") {
      location = CountryModel.fromJson(jsonDecode(loc.replaceAll("""\\""", """\\\\""")));
    } else {
      location = CountryModel();
    }

    nickName = json["nickName"] ?? "";
    phone = json["phone"] ?? "";

    fans = json["fans"] ?? 0;
    visitor = json["visitor"] ?? 0;
    visitorToday = json["visitorToday"] ?? 0;
    vipLevel = json["vipLevel"] ?? 0;
    followers = json["followers"] ?? 0;
    followerToday = json["followerToday"] ?? 0;
    balance = json["balance"] ?? "0.00";
    uk = json["uk"] ?? "";
    trophies = json["trophies"] != null
        ? json["trophies"].map<TrophieModel>((e) => TrophieModel.fromJson(e)).toList()
        : [];
    badges = json["badges"] != null
        ? json["badges"].map<BadgesItem>((e) => BadgesItem.fromJson(e)).toList()
        : [];
    gender = json["gender"] ?? 1;
    avatar = json["avatar"] ?? "";
    coin = json["coin"] ?? 0;
    userAvatar = json["userAvatar"] ?? 0;
    integralTotal = json["integralTotal"] ?? 0;
    checkTotal = json["checkTotal"] ?? 0;
    nexIntegralNumber = json["nexIntegralNumber"] ?? 0;
    lv = json["lv"] ?? 0;
    email = json["email"] ?? "";
    describe = json["describe"] ?? "";
    age = json["age"] ?? 0;
    vips = json["vips"] != null
        ? json["vips"].map<VipModel>((e) => VipModel.fromJson(e)).toList()
        : [];
    ads = json["ads"] != null
        ? json["ads"].map<AdModel>((e) => AdModel.fromJson(e)).toList()
        : [];
    coupons = json["coupons"] ?? 0;
    ranking = json["ranking"] ?? 5.0;
    postNum = json["postNum"] ?? 0;
    orderNum = json["OrderNum"] ?? 0;
    taskNum = json["taskNum"] ?? 0;
    avamins = json["avamins"] ?? 0;
    totalmins = json["totalmins"] ?? 0;
    orders = json["orders"] ?? 0;
    giftOrderNum = json["giftOrderNum"] ?? 0;
    service = json["service"] ?? 0;
    sidekickNum = json["sidekickNum"] ?? 0;
    diamond = json["diamond"] ?? "";
    vipCanceled = json["vipCanceled"] ?? false;
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

class TrophieModel {
  int id = 0;
  String iconName = "";
  String iconImage = "";
  String iconLightImage = "";
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

class AdModel {
  String url;
  String? link;

  AdModel({
    required this.url,
    required this.link,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
    url: json["url"] ?? '',
    link: json["link"],
  );
}

class VipModel {
  int level = 0;
  double price = 0.0;
  String name = "";

  VipModel({
    this.level = 0,
    this.price = 0.0,
    this.name = "",
  });

  VipModel.fromJson(Map<String, dynamic> json) {
    level = json["level"] ?? 0;
    price = json["price"] ?? 0.0;
    name = json["name"] ?? "";
  }
}

class BadgesItem {
  List<BadgeItem> getPageData(int page) {
    if (badge.length <= 6) return badge;
    int nextPage = page + 1;
    if (nextPage * 6 > badge.length) return badge.sublist(page * 6, badge.length);
    return badge.sublist(page * 6, nextPage * 6);
  }

  getPageSize() {
    if (badge.length % 6 == 0) {
      return badge.length % 6;
    }
    return (badge.length / 6).truncate() + 1;
  }

  final List<BadgeItem> badge;

  // Intimacy
  final String name;
  final String tips;

  BadgesItem({
    required this.badge,
    this.name = "",
    this.tips = "",
  });

  factory BadgesItem.fromJson(Map<String, dynamic>? json) => BadgesItem(
        badge: asT<List>(json, 'badge').map((e) => BadgeItem.fromJson(e)).toList(),
        name: asT<String>(json, 'name'),
        tips: asT<String>(json, 'tips'),
      );

  Map<String, dynamic> toJson() => {
        'badge': badge.map((e) => e.toJson()).toList(),
        'name': name,
        'tips': tips,
      };
}

class BadgeItem {
  // 29
  final int id;

  // VIP1
  final String iconName;

  // https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/01-VIP1.png
  final String iconImage;

  // Accumulated spending of 750 gold coins
  final String tips;

  // false
  final bool lighted;

  // 2
  final int medalType;

  // 750
  final int threshold;

  BadgeItem({
    this.id = 0,
    this.iconName = "",
    this.iconImage = "",
    this.tips = "",
    this.lighted = false,
    this.medalType = 0,
    this.threshold = 0,
  });

  factory BadgeItem.fromJson(Map<String, dynamic>? json) => BadgeItem(
        id: asT<int>(json, 'id'),
        iconName: asT<String>(json, 'iconName'),
        iconImage: asT<String>(json, 'iconImage'),
        tips: asT<String>(json, 'tips'),
        lighted: asT<bool>(json, 'lighted'),
        medalType: asT<int>(json, 'medalType'),
        threshold: asT<int>(json, 'threshold'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'iconName': iconName,
        'iconImage': iconImage,
        'tips': tips,
        'lighted': lighted,
        'medalType': medalType,
        'threshold': threshold,
      };
}
