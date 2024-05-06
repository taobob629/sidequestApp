class IntegralTaskModel {
  late int total = 0;
  late List<Row> rows = [];

  IntegralTaskModel();

  IntegralTaskModel.fromJson(Map<String, dynamic> json) {
    total = json["total"] ?? 0;
    rows = json["rows"] == null ? [] : List<Row>.from(json["rows"]!.map((x) => Row.fromJson(x)));
  }
}

class Row {
  int? id;
  String? taskName;
  String? description;
  String? url;
  int? taskType;
  dynamic target;
  String? icon;
  dynamic start;
  dynamic expire;
  int? integralNumber;
  int? status;

  Row({
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
  });

  factory Row.fromJson(Map<String, dynamic> json) => Row(
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
  };
}
