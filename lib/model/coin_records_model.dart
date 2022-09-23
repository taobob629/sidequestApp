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
    addtime = json['addtime'].toString()??'';
    showid = json['showid'];
    actionName = json['actionName'];
  }
  num? id;
  num? type;
  num? action;
  num? uid;
  num? touid;
  num? actionid;
  num? nums;
  num? total;
  String? addtime;
  num? showid;
  String? actionName;

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
    map['addtime'] = addtime;
    map['showid'] = showid;
    map['actionName'] = actionName;
    return map;
  }

}