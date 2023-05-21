class TaskDetailModel {
  Task task;
  List<Reward> rewards;

  TaskDetailModel({
    required this.task,
    required this.rewards,
  });

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) => TaskDetailModel(
    task: Task.fromJson(json["task"]),
    rewards: List<Reward>.from(json["rewards"].map((x) => Reward.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "task": task.toJson(),
    "rewards": List<dynamic>.from(rewards.map((x) => x.toJson())),
  };
}

class Reward {
  int id;
  int type;
  int level;
  String authCode;
  int memberId;
  int draw;
  int storeId;
  int createtime;
  dynamic couponid;
  int taskId;
  int expireState;
  String? couponName;

  Reward({
    required this.id,
    required this.type,
    required this.level,
    required this.authCode,
    required this.memberId,
    required this.draw,
    required this.storeId,
    required this.createtime,
    this.couponid,
    required this.taskId,
    required this.expireState,
    this.couponName,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json["id"],
    type: json["type"],
    level: json["level"],
    authCode: json["authCode"],
    memberId: json["memberId"],
    draw: json["draw"],
    storeId: json["storeId"],
    createtime: json["createtime"],
    couponid: json["couponid"],
    taskId: json["taskId"],
    expireState: json["expireState"],
    couponName: json["couponName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "level": level,
    "authCode": authCode,
    "memberId": memberId,
    "draw": draw,
    "storeId": storeId,
    "createtime": createtime,
    "couponid": couponid,
    "taskId": taskId,
    "expireState": expireState,
    "couponName": couponName,
  };
}

class Task {
  String couponId;
  int id;
  String name;
  String description;
  String url;
  dynamic url2;
  int type;
  int threshold;
  int level;
  int enabled;
  int memberLevel;

  Task({
    required this.couponId,
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    this.url2,
    required this.type,
    required this.threshold,
    required this.level,
    required this.enabled,
    required this.memberLevel,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    couponId: json["couponId"],
    id: json["id"],
    name: json["name"],
    description: json["description"],
    url: json["url"],
    url2: json["url2"],
    type: json["type"],
    threshold: json["threshold"],
    level: json["level"],
    enabled: json["enabled"],
    memberLevel: json["memberLevel"],
  );

  Map<String, dynamic> toJson() => {
    "couponId": couponId,
    "id": id,
    "name": name,
    "description": description,
    "url": url,
    "url2": url2,
    "type": type,
    "threshold": threshold,
    "level": level,
    "enabled": enabled,
    "memberLevel": memberLevel,
  };
}
