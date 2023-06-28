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
  int threshold;
  int type;
  int enabled;
  int userNum;
  int newReward;
  String? target;

  TaskModel({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.threshold,
    required this.type,
    required this.enabled,
    required this.userNum,
    required this.newReward,
    this.target,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    url: json["url"],
    threshold: json["threshold"],
    type: json["type"],
    enabled: json["enabled"],
    userNum: json["userNum"],
    newReward: json["newReward"],
    target: json["target"],
  );
}
