class TaskOutModel {
  int sidekickNums;
  int storeNums;
  List<TaskModel> tasks;

  TaskOutModel({
    required this.sidekickNums,
    required this.storeNums,
    required this.tasks,
  });

  factory TaskOutModel.fromJson(Map<String, dynamic> json) => TaskOutModel(
    sidekickNums: json["sidekick_nums"] ?? 0,
    storeNums: json["store_nums"] ?? 0,
    tasks: List<TaskModel>.from(json["tasks"].map((x) => TaskModel.fromJson(x))),
  );
}

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
  int newReward;
  int parent;
  int taskType;
  dynamic target;

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
    required this.newReward,
    required this.parent,
    required this.taskType,
    this.target,
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
    newReward: json["newReward"],
    parent: json["parent"],
    taskType: json["taskType"],
    target: json["target"],
  );
}
