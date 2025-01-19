class IntegralInfoModel {
  List<Sign> appSign;
  List<Sign> webSign;
  PointInfo? pointInfo;
  List<LvList> lvList;
  int? couponNum;

  IntegralInfoModel({
    required this.appSign,
    required this.webSign,
    this.pointInfo,
    required this.lvList,
    this.couponNum,
  });

  factory IntegralInfoModel.fromJson(Map<String, dynamic> json) =>
      IntegralInfoModel(
        couponNum: json["couponNum"] ?? 0,
        appSign: json["appSign"] == null
            ? []
            : List<Sign>.from(json["appSign"]!.map((x) => Sign.fromJson(x))),
        webSign: json["webSign"] == null
            ? []
            : List<Sign>.from(json["webSign"]!.map((x) => Sign.fromJson(x))),
        pointInfo: json["pointInfo"] == null
            ? null
            : PointInfo.fromJson(json["pointInfo"]),
        lvList: json["lvList"] == null
            ? []
            : List<LvList>.from(json["lvList"]!.map((x) => LvList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "appSign": List<dynamic>.from(appSign.map((x) => x.toJson())),
        "webSign": List<dynamic>.from(webSign.map((x) => x.toJson())),
        "pointInfo": pointInfo?.toJson(),
        "lvList": List<dynamic>.from(lvList.map((x) => x.toJson())),
      };
}

class Sign {
  int? state;
  String day;
  int? point;

  Sign({
    this.state,
    required this.day,
    this.point,
  });

  factory Sign.fromJson(Map<String, dynamic> json) => Sign(
        state: json["state"],
        day: json["day"] ?? '----',
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "day": day,
        "point": point,
      };
}

class LvList {
  int? id;
  String? content;
  int? threshold;
  String? name;
  String? description;
  int? level;
  dynamic locked;
  dynamic nowExperience;
  String? levelCoupons;

  LvList({
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

  factory LvList.fromJson(Map<String, dynamic> json) => LvList(
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

class PointInfo {
  int? id;
  int? memberId;
  int? points;
  int? pointsTotal;
  int? experience;
  int? expGrade;
  String? expGradeName;
  int? nextExperience;
  int? nextExpGrade;
  String? nickName;
  String? memberPhoto;
  String? desc;
  int? expGradeState;

  PointInfo({
    this.id,
    this.memberId,
    this.points,
    this.pointsTotal,
    this.experience,
    this.expGrade,
    this.expGradeName,
    this.nextExperience,
    this.nextExpGrade,
    this.nickName,
    this.memberPhoto,
    this.desc,
    this.expGradeState,
  });

  factory PointInfo.fromJson(Map<String, dynamic> json) => PointInfo(
        id: json["id"],
        memberId: json["memberId"],
        points: json["points"],
        pointsTotal: json["pointsTotal"],
        experience: json["experience"],
        expGrade: json["expGrade"],
        expGradeName: json["expGradeName"],
        nextExperience: json["nextExperience"],
        nextExpGrade: json["nextExpGrade"],
        nickName: json["nickName"],
        memberPhoto: json["memberPhoto"],
        desc: json["desc"],
        expGradeState: json["expGradeState"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "points": points,
        "pointsTotal": pointsTotal,
        "experience": experience,
        "expGrade": expGrade,
        "expGradeName": expGradeName,
        "nextExperience": nextExperience,
        "nextExpGrade": nextExpGrade,
        "nickName": nickName,
        "memberPhoto": memberPhoto,
        "desc": desc,
        "expGradeState": expGradeState,
      };
}
