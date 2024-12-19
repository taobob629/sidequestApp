class IntegralModel {
  List<LevelConfigVoList> levelConfigVoList;

  IntegralModel({
    required this.levelConfigVoList,
  });

  factory IntegralModel.fromJson(Map<String, dynamic> json) => IntegralModel(
        levelConfigVoList: json["levelConfigVoList"] == null
            ? []
            : List<LevelConfigVoList>.from(json["levelConfigVoList"]!
                .map((x) => LevelConfigVoList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "levelConfigVoList":
            List<dynamic>.from(levelConfigVoList.map((x) => x.toJson())),
      };
}

class LevelConfigVoList {
  int? id;
  String? content;
  int threshold;
  String? name;
  String? description;
  int level;
  int? locked;
  int nowExperience;
  String? levelCoupons;
  List<CouponsModel> coupons;

  LevelConfigVoList({
    this.id,
    this.content,
    required this.threshold,
    this.name,
    this.description,
    required this.level,
    this.locked,
    required this.nowExperience,
    this.levelCoupons,
    required this.coupons,
  });

  factory LevelConfigVoList.fromJson(Map<String, dynamic> json) =>
      LevelConfigVoList(
        id: json["id"],
        content: json["content"],
        threshold: json["threshold"] ?? 0,
        name: json["name"],
        description: json["description"],
        level: json["level"] ?? 0,
        locked: json["locked"],
        nowExperience: json["nowExperience"] ?? 0,
        levelCoupons: json["levelCoupons"],
        coupons: json["coupons"] == null
            ? []
            : List<CouponsModel>.from(
                json["coupons"]!.map((x) => CouponsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "threshold": threshold,
        "name": name,
        "description": description,
        "level": level,
        "locked": locked,
        "nowExperience": nowExperience,
        "levelCoupons": levelCoupons,
        "coupons": List<dynamic>.from(coupons.map((x) => x.toJson())),
      };
}

class CouponsModel {
  String? code;
  int? level;
  int? num;
  String? name;
  String? description;
  int? id;
  int? state;

  CouponsModel({
    this.code,
    this.level,
    this.num,
    this.name,
    this.description,
    this.id,
    this.state,
  });

  factory CouponsModel.fromJson(Map<String, dynamic> json) => CouponsModel(
        code: json["code"],
        level: json["level"],
        num: json["num"],
        name: json["name"],
        description: json["description"],
        id: json["id"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "level": level,
        "num": num,
        "name": name,
        "description": description,
        "id": id,
        "state": state,
      };
}
