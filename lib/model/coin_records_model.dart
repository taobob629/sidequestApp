/// id : 2
/// type : 0
/// action : 6
/// uid : 4
/// touid : 102326
/// actionid : 1
/// nums : 2
/// total : 10
/// addtime : 1663739455
/// showid : 0
/// actionName : ""

class CoinRecordsModel {
  CoinRecordsModel({
      this.id, 
      this.type, 
      this.action, 
      this.uid, 
      this.touid, 
      this.actionid, 
      this.nums, 
      this.total, 
      this.datatime,
      this.addtime,
      this.showid, 
      this.actionName,});

  CoinRecordsModel.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    action = json['action'];
    uid = json['uid'];
    touid = json['touid'];
    actionid = json['actionid'];
    nums = json['nums'];
    total = json['total'];
    datatime = json['datatime'];
    addtime = json['addtime'];

    showid = json['showid'];
    actionName = json['actionName'];
    afterChangeVotes = json['afterChangeVotes']?.toString() ?? '0';
    afterChangeCoin = json['afterChangeCoin']?.toString() ?? '0';
  }
  int? id;
  num? type;
  num? action;
  num? uid;
  num? touid;
  int? actionid;
  num? nums;
  num? total;
  String? datatime;
  num? addtime;
  num? showid;
  String? actionName;
  String? afterChangeVotes;
  String? afterChangeCoin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['action'] = action;
    map['uid'] = uid;
    map['touid'] = touid;
    map['actionid'] = actionid;
    map['nums'] = nums;
    map['total'] = total;
    map['datatime'] = datatime;
    map['showid'] = showid;
    map['addtime'] = addtime;

    map['actionName'] = actionName;
    return map;
  }

}