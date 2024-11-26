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
  int? threshold;
  String? name;
  String? description;
  int? level;
  int? locked;
  int? nowExperience;
  String? levelCoupons;

  LevelConfigVoList({
    this.id,
    this.content,
    this.threshold,
    this.name,
    this.description,
    this.level,
    this.locked,
    this.nowExperience,
    this.levelCoupons,
  });

  factory LevelConfigVoList.fromJson(Map<String, dynamic> json) =>
      LevelConfigVoList(
        id: json["id"],
        content: json["content"],
        threshold: json["threshold"],
        name: json["name"],
        description: json["description"],
        level: json["level"],
        locked: json["locked"],
        nowExperience: json["nowExperience"],
        levelCoupons: json["levelCoupons"],
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
      };
}

class LevelCoupon {
  int level;
  String name;
  String description;
  int id;

  LevelCoupon({
    required this.level,
    required this.name,
    required this.description,
    required this.id,
  });

  factory LevelCoupon.fromJson(Map<String, dynamic> json) {
    return LevelCoupon(
      level: json['level'],
      name: json['name'],
      description: json['description'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'name': name,
      'description': description,
      'id': id,
    };
  }
}
