import 'package:date_format/date_format.dart';

class VipInfoModel {
  String name = "";
  bool available = false;
  String vouchers = "";
  double monthFee = 0.0;
  double yearFee = 0.0;
  String mins = "";
  String nextChargeDate = "";
  String tips="";
  int level = 0;
  List<VipIntro> intro = [];

  ///转换为正常时间
  String get renewDateStr {
    try {
      return formatDate(DateTime.parse(nextChargeDate), [dd, '-', mm, '-', yyyy]);
    } catch (e) {
      return "";
    }
  }

  VipInfoModel({
    this.name = "",
    this.available = false,
    this.vouchers = "",
    this.monthFee = 0.0,
    this.yearFee = 0.0,
    this.mins = "",
    this.nextChargeDate = "",
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
    nextChargeDate = json["nextChargeDate"] ?? "";
    level = json["level"] ?? 0;
    intro = json["intro"] != null ? json["intro"].map<VipIntro>((e) => VipIntro.fromJson(e)).toList() : [];
    tips=json["tips"] ?? "";
  }
}

class VipIntro {
  String title = "";
  String intro = "";

  /// 1：时间，2：饮料，3：食品，0：通用
  int iconType = 0;
  String get iconName {
    if ([0, 1, 2, 3].contains(iconType)) {
      return "assets/images/profile/benefit_type_$iconType.webp";
    }
    return "assets/images/profile/benefit_type_0.webp";
  }

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
