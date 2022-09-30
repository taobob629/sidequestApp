/// sex : 0
/// name : "test3"
/// avatar : "https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/MemberAvatar/members/3.jpg"
/// isfans : 1
/// id : 19030
const int BOTH_FOCUS=1;
class AttentionModel {
  AttentionModel({this.sex, this.name, this.avatar, this.isfans, this.status, this.id});

  AttentionModel.fromJson(dynamic json) {
    sex = json['sex'];
    name = json['name'];
    avatar = json['avatar'];
    signature = json['signature'];
    isfans = json['isfans'];
    status = json['status'];
    id = json['id'];
  }

  int? sex;
  int? status; //status=1，代表我已经关注了对方 0代表可以还没关注对方
  String? name;
  String? avatar;
  String? signature;
  int? isfans;
  num? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sex'] = sex;
    map['name'] = name;
    map['avatar'] = avatar;
    map['isfans'] = isfans;
    map['id'] = id;
    return map;
  }
}
