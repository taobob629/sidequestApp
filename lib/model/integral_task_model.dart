class IntegralTaskModel {
  int? total;
  List<IntegralTask> rows;

  IntegralTaskModel({
    this.total,
    required this.rows,
  });

  factory IntegralTaskModel.fromJson(Map<String, dynamic> json) =>
      IntegralTaskModel(
        total: json["total"],
        rows: json["rows"] == null
            ? []
            : List<IntegralTask>.from(json["rows"]!.map((x) => IntegralTask.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "rows": rows == null
            ? []
            : List<dynamic>.from(rows!.map((x) => x.toJson())),
      };
}

class IntegralTask {
  int? id;
  String? taskName;
  String? description;
  int? taskSource;
  int? taskType;
  dynamic storeIds;
  int? taskFrequency;
  int? taskHide;
  int? taskActivity;
  dynamic icon;
  String? taskStartTime;
  String? taskEndTime;
  int? pointsNum;
  int? taskState;
  dynamic notes;
  String? createTime;
  String? updateTime;

  IntegralTask({
    this.id,
    this.taskName,
    this.description,
    this.taskSource,
    this.taskType,
    this.storeIds,
    this.taskFrequency,
    this.taskHide,
    this.taskActivity,
    this.icon,
    this.taskStartTime,
    this.taskEndTime,
    this.pointsNum,
    this.taskState,
    this.notes,
    this.createTime,
    this.updateTime,
  });

  factory IntegralTask.fromJson(Map<String, dynamic> json) => IntegralTask(
        id: json["id"],
        taskName: json["taskName"],
        description: json["description"],
        taskSource: json["taskSource"],
        taskType: json["taskType"],
        storeIds: json["storeIds"],
        taskFrequency: json["taskFrequency"],
        taskHide: json["taskHide"],
        taskActivity: json["taskActivity"],
        icon: json["icon"],
        taskStartTime: json["taskStartTime"],
        taskEndTime: json["taskEndTime"],
        pointsNum: json["pointsNum"],
        taskState: json["taskState"],
        notes: json["notes"],
        createTime: json["createTime"],
        updateTime: json["updateTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taskName": taskName,
        "description": description,
        "taskSource": taskSource,
        "taskType": taskType,
        "storeIds": storeIds,
        "taskFrequency": taskFrequency,
        "taskHide": taskHide,
        "taskActivity": taskActivity,
        "icon": icon,
        "taskStartTime": taskStartTime,
        "taskEndTime": taskEndTime,
        "pointsNum": pointsNum,
        "taskState": taskState,
        "notes": notes,
        "createTime": createTime,
        "updateTime": updateTime,
      };
}
