import 'dart:convert';

import 'package:wy/utils/utils.dart';

class StatusLable {
  late int colour;
  late String displayLable;

  StatusLable({required this.colour, required this.displayLable});

  factory StatusLable.fromJson(Map<String, dynamic> json) {
    return StatusLable(
      colour: json['colour'],
      displayLable: json['displayLable'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colour'] = this.colour;
    data['displayLable'] = this.displayLable;
    return data;
  }
}

class PlayOrderDetailModel {
  String creater='';
  String player='';//
  late String icon = "";
  late String gameName = "";
  late Map serviceItem = {};
  late String unit = "";
  late int orderId = 0;
  int liveuid = 0;
  int uid = 0;
  late int fromUid = 0;
  late int toUid = 0;
  late int nums = 0;
  late int total = 0;
  late int discount=0;
  late int acturalPayment=0;
 // late int status = 0; //-4已超时-3拒绝-2已完成-1取消0待支付1已支付2已接单，3：等待退款；4：拒绝退款；5：同意退款；6：退款申诉：等待平台退款
  late String orderno = "";
  late int svctm = 0;
  late int addtime = 0;
  late String comments = "";
  late double star = 0.0;
  late String rejectReason = "";
   String reason = "";
   int receipttime = 0;
   List<StatusLable> statusArray=[];
  int status=0;
  PlayOrderDetailModel

  (

  );

  PlayOrderDetailModel.fromJson(Map<String, dynamic> json) {
    icon = json['skill']['thumb'] ?? "";
    creater = json['order']['creater'] ?? '';
    player = json['order']['player'] ?? '';
    liveuid = json['order']['liveuid'] ?? 0;
    uid = json['order']['uid'] ?? 0;
    gameName = json['skill']['nameEn'] ?? "";
    serviceItem = json['serviceItem']?? {};
    orderId = json['order']['id'] ?? 0;
    fromUid = json['order']['uid'] ?? 0;
    toUid = json['order']['liveuid'] ?? 0;
    nums = json['order']['nums'] ?? 0;
    unit = json['order']['unit'] ?? "";
    total = json['order']['total'] ?? 0;
    status = json['order']['status'] ?? 0;
    statusArray = json['status'] == null ? []:(json['status'] as List).map((e) => StatusLable.fromJson(e)).toList();
    orderno = json['order']['orderno'] ?? 0;
    svctm = json['order']['svctm'] ?? 0;
    star = json['order']['star'] ?? 0.0;
    comments = json['order']['comments'] ?? "";
    rejectReason = json['order']['rejectReason'] ?? "";
    reason = json['order']['reason'] ?? "";
    receipttime = json['order']['receipttime'] ?? "";
    addtime = json['order']['addtime'] ?? "";

    discount = json['order']['discount'] ?? 0;
    acturalPayment=total-discount;
    flog('status 3 $status');
  }
}