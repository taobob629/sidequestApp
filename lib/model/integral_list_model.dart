class IntegralListModel {
  late int total = 0;
  late List<IntegralListRow> rows = [];

  IntegralListModel();

  IntegralListModel.fromJson(Map<String, dynamic> json) {
    total = json["total"] ?? 0;
    rows = json["rows"] == null ? [] : List<IntegralListRow>.from(json["rows"]!.map((x) => IntegralListRow.fromJson(x)));
  }
}

class IntegralListRow {
  int? id;
  int? integralId;
  int? userId;
  String? checkDay;
  String? integralName;
  int? integralNumber;
  int? status;
  int? mold;
  int? checkType;

  IntegralListRow({
    this.id,
    this.integralId,
    this.userId,
    this.checkDay,
    this.integralName,
    this.integralNumber,
    this.status,
    this.mold,
    this.checkType,
  });

  factory IntegralListRow.fromJson(Map<String, dynamic> json) => IntegralListRow(
    id: json["id"],
    integralId: json["integralId"],
    userId: json["userId"],
    checkDay: json["checkDay"],
    integralName: json["integralName"],
    integralNumber: json["integralNumber"],
    status: json["status"],
    mold: json["mold"],
    checkType: json["checkType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "integralId": integralId,
    "userId": userId,
    "checkDay": checkDay,
    "integralName": integralName,
    "integralNumber": integralNumber,
    "status": status,
    "mold": mold,
    "checkType": checkType,
  };
}
