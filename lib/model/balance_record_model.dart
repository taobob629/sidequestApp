
class ConsumeRecordModel {
  late String nowBalance = "";
  late String amount = "";
  late int addtime = 0;
  late String time = "";
  late int refund = 0;

  late String name = '';
  late String startTime = '';
  late String endTime = '';
  late String title = '';
  late String free = '';
  late int howLong;

  late String orderNo;
  late String goodsUrl;
  late int num;
  late bool discount;
  late String couponCode;

  ConsumeRecordModel();

  ConsumeRecordModel.fromJson(Map<String, dynamic> json) {
    nowBalance = json['nowBalance'] ?? '';
    amount = json['amount'] ?? '';
    addtime = json['addtime'] ?? 0;
    time = json['time'] ?? '';
    refund = json['refund'] ?? 0;

    name = json['name'] ?? '';
    startTime = json['startTime'] ?? '';
    endTime = json['endTime'] ?? '';
    title = json['title'] ?? '';
    free = json['free'] ?? '';
    howLong = json['howLong'] ?? 0;

    orderNo = json['orderNo'] ?? '';
    goodsUrl = json['goodsUrl'] ?? '';
    num = json['num'] ?? 0;
    discount = json['discount'] ?? false;
    couponCode = json['couponCode'] ?? '';
  }
}

class BalanceRecordModel {
  late String time = "";
  late String amount = "";

  late List<BalanceDetailModel> details = [];

}

class BalanceDetailModel{
  late int type = 0;
  late String title = "";
  late String amount = "";
}