import 'dart:convert';

class ProfileModel {
  String language = "";
  int isAuth = 0;
  int sidekickLevel = 0;
  CountryModel country = CountryModel();
  String nickName = "";
  int fans = 0;
  int vipLevel = 0;
  int followers = 0;
  String balance = "";
  String uk = "";
  List<TrophieModel> trophies = [];
  int gender = 0;
  String avatar = "";
  int coin = 0;
  String email = "";
  int age = 0;
  List<VipModel> vips = [];
  int coupons = 0;
  int ranking = 0;
  int postNum = 0;
  String diamond = "";

  ProfileModel({
    this.language = "",
    this.isAuth = 0,
    this.sidekickLevel = 0,
    this.nickName = "",
    this.fans = 0,
    this.vipLevel = 0,
    this.followers = 0,
    this.balance = "",
    this.uk = "",
    this.trophies = const [],
    this.gender = 0,
    this.avatar = "",
    this.coin = 0,
    this.email = "",
    this.age = 0,
    this.vips = const [],
    this.coupons = 0,
    this.ranking = 0,
    this.postNum = 0,
    this.diamond = "",
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    language = json["language"] ?? "";
    isAuth = json["isAuth"] ?? 0;
    sidekickLevel = json["sidekickLevel"] ?? 0;

    if ((json["country"] is String)) {
      country = CountryModel.fromJson(jsonDecode(json["country"].replaceAll("""\\""", """\\\\""")));
    } else {
      country = CountryModel();
    }

    nickName = json["nickName"] ?? "";
    fans = json["fans"] ?? 0;
    vipLevel = json["vipLevel"] ?? 0;
    followers = json["followers"] ?? 0;
    balance = json["balance"] ?? "";
    uk = json["uk"] ?? "";
    trophies = json["trophies"] != null ? json["trophies"].map<TrophieModel>((e) => TrophieModel.fromJson(e)).toList() : [];
    gender = json["gender"] ?? 0;
    avatar = json["avatar"] ?? "";
    coin = json["coin"] ?? 0;
    email = json["email"] ?? "";
    age = json["age"] ?? 0;
    vips = json["vips"] != null ? json["vips"].map<VipModel>((e) => VipModel.fromJson(e)).toList() : [];
    coupons = json["coupons"] ?? 0;
    ranking = json["ranking"] ?? 0;
    postNum = json["postNum"] ?? 0;
    diamond = json["diamond"] ?? "";
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
