class IntegralCheckInModel {
  int? checkTotal;
  List<CheckList> checkList;
  int? checkCount;
  int lv;
  int nexIntegralNumber;
  int integralTotal;
  String? describe;
  String? userName;
  String? memberPhoto;

  IntegralCheckInModel({
    this.checkTotal,
    required this.checkList,
    this.checkCount,
    required this.lv,
    required this.nexIntegralNumber,
    this.describe,
    this.userName,
    this.memberPhoto,
    required this.integralTotal,
  });

  factory IntegralCheckInModel.fromJson(Map<String, dynamic> json) => IntegralCheckInModel(
    checkTotal: json["checkTotal"],
    checkList: json["checkList"] == null ? [] : List<CheckList>.from(json["checkList"]!.map((x) => CheckList.fromJson(x))),
    checkCount: json["checkCount"],
    lv: json["lv"] ?? 1,
    nexIntegralNumber: json["nexIntegralNumber"] ?? 0,
    describe: json["describe"],
    userName: json["userName"],
    memberPhoto: json["memberPhoto"],
    integralTotal: json["integralTotal"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "checkTotal": checkTotal,
    "checkList": checkList == null ? [] : List<dynamic>.from(checkList!.map((x) => x.toJson())),
    "checkCount": checkCount,
    "lv": lv,
    "nexIntegralNumber": nexIntegralNumber,
    "describe": describe,
    "userName": userName,
    "memberPhoto": memberPhoto,
    "integralTotal": integralTotal,
  };
}

class CheckList {
  // 0未签到 1已签到 2待签到
  int? state;
  int? point;
  String day;

  CheckList({
    this.point,
    required this.day,
    this.state,
  });

  factory CheckList.fromJson(Map<String, dynamic> json) => CheckList(
    state: json["state"],
    point: json["point"],
    day: json["day"] ?? '----',
  );

  Map<String, dynamic> toJson() => {
    "point": point,
    "state": state,
    "day": day,
  };
}
