class IntegralListModel {
  late int total = 0;
  late List<IntegralListRow> rows = [];

  IntegralListModel();

  IntegralListModel.fromJson(Map<String, dynamic> json) {
    total = json["total"] ?? 0;
    rows = json["rows"] == null
        ? []
        : List<IntegralListRow>.from(
            json["rows"]!.map((x) => IntegralListRow.fromJson(x)));
  }
}

class IntegralListRow {
  int? id;
  int? memberId;
  String? detailName;
  String? dataId;
  int? pointsNum;
  int? pointsType;
  int? pointsState;
  String? notes;
  String? createTime;

  IntegralListRow({
    this.id,
    this.memberId,
    this.detailName,
    this.dataId,
    this.pointsNum,
    this.pointsType,
    this.pointsState,
    this.notes,
    this.createTime,
  });

  factory IntegralListRow.fromJson(Map<String, dynamic> json) =>
      IntegralListRow(
        id: json["id"],
        memberId: json["memberId"],
        detailName: json["detailName"],
        dataId: json["dataId"],
        pointsNum: json["pointsNum"],
        pointsType: json["pointsType"],
        pointsState: json["pointsState"],
        notes: json["notes"],
        createTime: json["createTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberId": memberId,
        "detailName": detailName,
        "dataId": dataId,
        "pointsNum": pointsNum,
        "pointsType": pointsType,
        "pointsState": pointsState,
        "notes": notes,
      };
}
