class IntegralTaskDetailModel {
  int? id;
  String? taskName;
  String? description;
  String? url;
  int? taskType;
  dynamic target;
  dynamic icon;
  dynamic start;
  String? expire;
  int? integralNumber;
  int? status;
  int? deleted;
  int? enabled;
  dynamic coupons;
  String? taskAskFor;

  IntegralTaskDetailModel({
    this.id,
    this.taskName,
    this.description,
    this.url,
    this.taskType,
    this.target,
    this.icon,
    this.start,
    this.expire,
    this.integralNumber,
    this.status,
    this.deleted,
    this.enabled,
    this.coupons,
    this.taskAskFor,
  });

  factory IntegralTaskDetailModel.fromJson(Map<String, dynamic> json) => IntegralTaskDetailModel(
    id: json["id"],
    taskName: json["taskName"],
    description: json["description"],
    url: json["url"],
    taskType: json["taskType"],
    target: json["target"],
    icon: json["icon"],
    start: json["start"],
    expire: json["expire"],
    integralNumber: json["integralNumber"],
    status: json["status"],
    deleted: json["deleted"],
    enabled: json["enabled"],
    coupons: json["coupons"],
    taskAskFor: json["taskAskFor"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "taskName": taskName,
    "description": description,
    "url": url,
    "taskType": taskType,
    "target": target,
    "icon": icon,
    "start": start,
    "expire": expire,
    "integralNumber": integralNumber,
    "status": status,
    "deleted": deleted,
    "enabled": enabled,
    "coupons": coupons,
    "taskAskFor": taskAskFor,
  };
}
