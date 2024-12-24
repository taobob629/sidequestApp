import 'integral_task_detail_model.dart';

class IntegralTaskModel {
  int? id;
  String? taskName;
  String? description;
  int? taskSource;
  int? taskType;
  int? taskFrequency;
  int? taskHide;
  int? taskActivity;
  String? icon;
  String? taskStartTime;
  String? taskEndTime;
  int? pointsNum;
  int? taskState;
  String? notes;
  String? createTime;
  String? updateTime;
  int? maxNum;
  NowTaskDetail? nowTaskDetail;

  IntegralTaskModel({
    this.id,
    this.taskName,
    this.description,
    this.taskSource,
    this.taskType,
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
    this.maxNum,
    this.nowTaskDetail,
  });

  factory IntegralTaskModel.fromJson(Map<String, dynamic> json) =>
      IntegralTaskModel(
        id: json["id"],
        taskName: json["taskName"],
        description: json["description"],
        taskSource: json["taskSource"],
        taskType: json["taskType"],
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
        maxNum: json["maxNum"],
        nowTaskDetail: json["nowTaskDetail"] == null
            ? null
            : NowTaskDetail.fromJson(json["nowTaskDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taskName": taskName,
        "description": description,
        "taskSource": taskSource,
        "taskType": taskType,
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
        "maxNum": maxNum,
        "nowTaskDetail": nowTaskDetail?.toJson(),
      };
}
