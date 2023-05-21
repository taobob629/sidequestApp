class TaskModel {
  int id;
  String name;
  String description;
  String url;
  dynamic url2;
  int threshold;
  int level;
  int type;
  String couponId;
  dynamic couponName;
  int enabled;
  int memberLevel;
  int userNum;
  dynamic rewardList;

  TaskModel({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    this.url2,
    required this.threshold,
    required this.level,
    required this.type,
    required this.couponId,
    this.couponName,
    required this.enabled,
    required this.memberLevel,
    required this.userNum,
    this.rewardList,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    url: json["url"],
    url2: json["url2"],
    threshold: json["threshold"],
    level: json["level"],
    type: json["type"],
    couponId: json["couponId"],
    couponName: json["couponName"],
    enabled: json["enabled"],
    memberLevel: json["memberLevel"],
    userNum: json["userNum"],
    rewardList: json["rewardList"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "url": url,
    "url2": url2,
    "threshold": threshold,
    "level": level,
    "type": type,
    "couponId": couponId,
    "couponName": couponName,
    "enabled": enabled,
    "memberLevel": memberLevel,
    "userNum": userNum,
    "rewardList": rewardList,
  };
}
