class VipInfoModel {
  String name = "";
  bool available = false;
  String vouchers = "";
  double monthFee = 0.0;
  double yearFee = 0.0;
  String mins = "";
  int level = 0;
  List<VipIntro> intro = [];

  VipInfoModel({
    this.name = "",
    this.available = false,
    this.vouchers = "",
    this.monthFee = 0.0,
    this.yearFee = 0.0,
    this.mins = "",
    this.level = 0,
    this.intro = const [],
  });

  VipInfoModel.fromJson(Map<String, dynamic> json) {
    name = json["name"] ?? "";
    available = json["available"] ?? false;
    vouchers = json["vouchers"] ?? "";
    monthFee = json["monthFee"] ?? 0.0;
    yearFee = json["yearFee"] ?? 0.0;
    mins = json["mins"] ?? "";
    level = json["level"] ?? 0;
    intro = json["intro"] != null ? json["intro"].map<VipIntro>((e) => VipIntro.fromJson(e)).toList() : [];
  }
}

class VipIntro {
  String title = "";
  String intro = "";
  int iconType = 0;

  VipIntro({
    this.title = "",
    this.intro = "",
    this.iconType = 0,
  });

  VipIntro.fromJson(Map<String, dynamic> json) {
    title = json["title"] ?? "";
    intro = json["intro"] ?? "";
    iconType = json["iconType"] ?? 0;
  }
}
