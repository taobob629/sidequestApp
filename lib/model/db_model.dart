class PayRecord{
  late String orderId;
  late String tranId;
  late DateTime createTime;

  PayRecord();

  PayRecord.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    tranId = json['tranId'];
    createTime = DateTime.fromMillisecondsSinceEpoch(json['createTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['tranId'] = this.tranId;
    data['createTime'] = this.createTime.millisecondsSinceEpoch;
    return data;
  }
}