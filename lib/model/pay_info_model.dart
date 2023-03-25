import 'dart:convert' as convert;

class PayInfoModel {
  late PayDataModel? result;
  late String orderNo;
  late String customerId;
  late String clientSecret;
  late String ephemeralKeySecret;
  late bool applePay;
  late bool googlePay;
  String uk = "";
  String desc = "";

  bool insufficient = false;

  PayInfoModel();

  PayInfoModel.fromJson(Map<String, dynamic> json) {
    orderNo = json["orderNo"] == null ? "" : json["orderNo"];
    customerId = json["customerId"] == null ? "" : json["customerId"];
    clientSecret = json["clientSecret"] == null ? "" : json["clientSecret"];
    ephemeralKeySecret = json["ephemeralKeySecret"] == null ? "" : json["ephemeralKeySecret"];
    applePay = json["applePay"] == null ? false : json["applePay"];
    googlePay = json["googlePay"] == null ? false : json["googlePay"];
    String resultString = json["result"] == null ? "" : json["result"];
    if (resultString.isNotEmpty && resultString.contains("app_data")) {
      result = PayDataModel.fromJson(convert.jsonDecode(json["result"]));
    } else {
      result = null;
    }
  }
}

class PayDataModel {
  late String appData;

  PayDataModel();

  PayDataModel.fromJson(Map<String, dynamic> json) {
    appData = json["app_data"];
  }
}
