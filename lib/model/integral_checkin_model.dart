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
  int? checkType;
  int? number;
  String day;
  int? awardType;

  CheckList({
    this.checkType,
    this.number,
    required this.day,
    this.awardType,
  });

  factory CheckList.fromJson(Map<String, dynamic> json) => CheckList(
    checkType: json["checkType"],
    number: json["number"],
    day: json["day"] ?? '----',
    awardType: json["awardType"],
  );

  Map<String, dynamic> toJson() => {
    "checkType": checkType,
    "number": number,
    "day": day,
    "awardType": awardType,
  };
}
