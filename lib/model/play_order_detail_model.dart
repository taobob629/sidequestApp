

class PlayOrderDetailModel {
  late String icon;
  late String gameName;
  late int orderId;
  late int fromUid;
  late int toUid;
  late int nums;
  late int total;
  late int status;//-4已超时-3拒绝-2已完成-1取消0待支付1已支付2已接单，3：等待退款；4：拒绝退款；5：同意退款；6：退款申诉：等待平台退款
  late String orderno;

  PlayOrderDetailModel();

  PlayOrderDetailModel.fromJson(Map<String, dynamic> json) {
    icon = json['skill']['thumb']?? "";
    gameName = json['skill']['nameEn'] ?? "";
    orderId = json['order']['id'] ?? 0;
    fromUid = json['order']['uid'] ?? 0;
    toUid = json['order']['liveuid'] ?? 0;
    nums = json['order']['nums'] ?? 0;
    total = json['order']['total'] ?? 0;
    status = json['order']['status'] ?? 0;
    orderno = json['order']['orderno'] ?? 0;
  }
}