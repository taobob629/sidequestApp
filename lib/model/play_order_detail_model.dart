

class PlayOrderDetailModel {
  late String icon = "";
  late String gameName = "";
  late int orderId = 0;
  late int fromUid = 0;
  late int toUid = 0;
  late int nums = 0;
  late int total = 0;
  late int status = 0;//-4已超时-3拒绝-2已完成-1取消0待支付1已支付2已接单，3：等待退款；4：拒绝退款；5：同意退款；6：退款申诉：等待平台退款
  late String orderno = "";
  late int svctm = 0;
  late int addtime = 0;
  late String comments = "";
  late double star = 0.0;

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
    svctm = json['order']['svctm'] ?? 0;
    star = json['order']['star'] ?? 0.0;
    comments = json['order']['comments'] ?? "";
  }
}