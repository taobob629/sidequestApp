/// id : 1
/// name : "bob"
/// card : "123456789876543"
/// memberId : 16955
/// coin : 3000
/// money : "180.00"
/// cardId : 1
/// fee : "12.00"
/// createTime : "2022-09-20 10:00:00"
/// sortCode : null
/// bankName : null
/// status : 0
/// votes : 0

class WithdrawRecordModel {
  WithdrawRecordModel({
    this.id,
    this.name,
    this.card,
    this.memberId,
    this.coin,
    this.money,
    this.cardId,
    this.fee,
    this.createTime,
    this.sortCode,
    this.bankName,
    this.status,
    this.votes,
  });

  WithdrawRecordModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    card = json['card'];
    memberId = json['memberId'];
    coin = json['coin'];
    note = json['note'];

    money = json['money'];
    cardId = json['cardId'];
    fee = json['fee'];
    createTime = json['createTime'];
    sortCode = json['sortCode'];
    bankName = json['bankName'];
    status = json['status'];
    votes = json['votes'];
  }

  num? id;
  String? name;
  String? card;
  num? memberId;
  num? coin;
  String? money;
  num? cardId;
  String? fee;
  String? createTime;
  String? note;

  String? sortCode;
  String? bankName;
  num? status;
  num? votes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['card'] = card;
    map['memberId'] = memberId;
    map['coin'] = coin;
    map['note'] = note;

    map['money'] = money;
    map['cardId'] = cardId;
    map['fee'] = fee;
    map['createTime'] = createTime;
    map['sortCode'] = sortCode;
    map['bankName'] = bankName;
    map['status'] = status;
    map['votes'] = votes;
    return map;
  }

  String statusText() {
    switch (status) {
      case 0:
        return 'Processing';
      case 1:
        return 'Succeed';
      case 2:
        return 'Rejected';
      case 3:
        return 'Canceled';
      default:
        return '';
    }
  }
}
