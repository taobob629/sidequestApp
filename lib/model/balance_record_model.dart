
class ConsumeRecordModel {
  late String title = "";

  late String amount = "";

  late String payType = "";

  late String time = "";

  ConsumeRecordModel();

  ConsumeRecordModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] == null? "":json['title'];
    amount = json['amount'];
    payType = json['paytype'];
    time = json['time'];
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