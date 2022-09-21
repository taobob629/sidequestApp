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
    this. addtime,
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
