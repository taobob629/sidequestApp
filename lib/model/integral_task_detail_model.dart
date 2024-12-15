class IntegralTaskDetailModel {
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
  int? maxNum;
  NowTaskDetail? nowTaskDetail;
  List<NowTaskDetail> taskDetailList;

  IntegralTaskDetailModel({
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
    this.maxNum,
    this.nowTaskDetail,
    required this.taskDetailList,
  });

  factory IntegralTaskDetailModel.fromJson(Map<String, dynamic> json) =>
      IntegralTaskDetailModel(
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
        maxNum: json["maxNum"],
        nowTaskDetail: json["nowTaskDetail"] == null
            ? null
            : NowTaskDetail.fromJson(json["nowTaskDetail"]),
        taskDetailList: json["taskDetailList"] == null
            ? []
            : List<NowTaskDetail>.from(
                json["taskDetailList"]!.map((x) => NowTaskDetail.fromJson(x))),
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
        "maxNum": maxNum,
        "nowTaskDetail": nowTaskDetail?.toJson(),
        "taskDetailList": List<dynamic>.from(taskDetailList.map((x) => x.toJson())),
      };
}

class NowTaskDetail {
  int? id;
  int? memberId;
  int? taskId;
  int? pointsNum;
  int? myNum;
  int? maxNum;
  int? receiveState;
  int? taskState;
  int? historyState;
  String? dataId;
  String? createTime;
  String? updateTime;

  NowTaskDetail({
    this.id,
    this.memberId,
    this.taskId,
    this.pointsNum,
    this.myNum,
    this.maxNum,
    this.receiveState,
    this.taskState,
    this.historyState,
    this.dataId,
    this.createTime,
    this.updateTime,
  });

  factory NowTaskDetail.fromJson(Map<String, dynamic> json) => NowTaskDetail(
        id: json["id"],
        memberId: json["memberId"],
        taskId: json["taskId"],
        pointsNum: json["pointsNum"],
        myNum: json["myNum"],
        maxNum: json["maxNum"],
        receiveState: json["receiveState"],
        taskState: json["taskState"],
        historyState: json["historyState"],
        dataId: json["dataId"],
        createTime: json["createTime"],
        updateTime: json["updateTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "taskId": taskId,
        "pointsNum": pointsNum,
        "myNum": myNum,
        "maxNum": maxNum,
        "receiveState": receiveState,
        "taskState": taskState,
        "historyState": historyState,
        "dataId": dataId,
        "createTime": createTime,
        "updateTime": updateTime,
      };
}
