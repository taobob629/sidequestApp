import 'package:get/get.dart';

/// sex : 0
/// name : "test3"
/// avatar : "https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/MemberAvatar/members/3.jpg"
/// isfans : 1
/// id : 19030
const int BOTH_FOCUS = 1;

class AttentionModel {
  AttentionModel();

  AttentionModel.fromJson(dynamic json) {
    sex = json['sex'] ?? 0;
    age = json['age'] ?? 0;
    name = json['name'] ?? "";
    avatar = json['avatar'] ?? "";
    signature = json['signature'] ?? "";
    isfans = json['isfans'] ?? 0;
    isAuth = json['isauth'] ?? 0;
    userLevel = json['userLevel'] ?? 0;
    titlesLevel = json['titlesLevel'] ?? 0;
    status.value = json['status'] ?? 0;
    id = json['id'] ?? 0;
    uk = json['uk'] ?? 0;
  }

  int sex = 0;
  int age = 0;
  RxInt status = RxInt(0); //status=1，代表我已经关注了对方 0代表可以还没关注对方
  String name = "";
  String avatar = "";
  String signature = "";
  String uk = "";
  int isfans = 0;
  int isAuth = 0;
  int titlesLevel = 0;
  int userLevel = 0;
  int id = 0;
  RxBool _isSelet=RxBool(false);

  bool get isSelet => _isSelet.value;

  set isSelet(bool value) {
    _isSelet.value = value;
  }

  bool get isFans => isfans == 1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sex'] = sex;
    map['age'] = age;
    map['name'] = name;
    map['avatar'] = avatar;
    map['isfans'] = isfans;
    map['isAuth'] = isAuth;
    map['titlesLevel'] = titlesLevel;
    map['userLevel'] = userLevel;
    map['id'] = id;
    map['uk'] = uk;
    return map;
  }
}
