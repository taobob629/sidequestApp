/// chargeRatio : "10"
/// pw_charge_rules : [{"id":null,"name":null,"money":"10","coin":100,"coinIos":70,"productId":null,"googlePid":null,"give":null,"listOrder":null,"addtime":null,"coinPaypal":null},{"id":null,"name":null,"money":"30","coin":310,"coinIos":217,"productId":null,"googlePid":null,"give":null,"listOrder":null,"addtime":null,"coinPaypal":null},{"id":null,"name":null,"money":"50","coin":530,"coinIos":371,"productId":null,"googlePid":null,"give":null,"listOrder":null,"addtime":null,"coinPaypal":null},{"id":null,"name":null,"money":"100","coin":1080,"coinIos":756,"productId":null,"googlePid":null,"give":null,"listOrder":null,"addtime":null,"coinPaypal":null},{"id":null,"name":null,"money":"200","coin":2100,"coinIos":1470,"productId":null,"googlePid":null,"give":null,"listOrder":null,"addtime":null,"coinPaypal":null},{"id":null,"name":null,"money":"300","coin":3300,"coinIos":2310,"productId":null,"googlePid":null,"give":null,"listOrder":null,"addtime":null,"coinPaypal":null}]
/// coin2votes : "0.9"
/// withdrawal_threshold : "100"
/// withdrawal_ratio : "0.15"
class ChargeRuleModel {
  ChargeRuleModel({
    this.chargeRatio,
    this.pwChargeRules,
    this.coin2votes,
    this.withdrawalThreshold,
    this.withdrawalRatio,
  });

  ChargeRuleModel.fromJson(dynamic json) {
    chargeRatio = json['chargeRatio'];
    coin = json['coin']??0;
    votes = json['votes']??0;
    if (json['pw_charge_rules'] != null) {
      pwChargeRules = [];
      json['pw_charge_rules'].forEach((v) {
        pwChargeRules?.add(CoinChargeRuleModel.fromJson(v));
      });
    }
    coin2votes = json['coin2votes'];
    withdrawalThreshold = json['withdrawal_threshold'];
    withdrawalRatio = json['withdrawal_ratio'];
  }

  String? chargeRatio;
  List<CoinChargeRuleModel>? pwChargeRules;
  String? coin2votes;
  String? withdrawalThreshold;
  String? withdrawalRatio;
  late int coin;
  late int votes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chargeRatio'] = chargeRatio;
    if (pwChargeRules != null) {
      map['pw_charge_rules'] = pwChargeRules?.map((v) => v.toJson()).toList();
    }
    map['coin2votes'] = coin2votes;
    map['withdrawal_threshold'] = withdrawalThreshold;
    map['withdrawal_ratio'] = withdrawalRatio;
    return map;
  }
}

class CoinChargeRuleModel {
  CoinChargeRuleModel({
    this.id,
    this.name,
    this.money = '',
    this.coin = 0,
    this.coinIos = 0,
    this.productId,
    this.googlePid,
    this.give,
    this.listOrder,
    this.addtime,
    this.coinPaypal,
  });

  CoinChargeRuleModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    money = json['money'] ?? '';
    coin = json['coin'] ?? 0;
    coinIos = json['coinIos'] ?? 0;
    productId = json['productId'];
    googlePid = json['googlePid'];
    give = json['give'];
    listOrder = json['listOrder'];
    addtime = json['addtime'];
    coinPaypal = json['coinPaypal'];
  }

  dynamic id;
  dynamic name;
  late String money;
  late int coin;
  late int coinIos;
  dynamic productId;
  dynamic googlePid;
  dynamic give;
  dynamic listOrder;
  dynamic addtime;
  dynamic coinPaypal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['money'] = money;
    map['coin'] = coin;
    map['coinIos'] = coinIos;
    map['productId'] = productId;
    map['googlePid'] = googlePid;
    map['give'] = give;
    map['listOrder'] = listOrder;
    map['addtime'] = addtime;
    map['coinPaypal'] = coinPaypal;
    return map;
  }
}
