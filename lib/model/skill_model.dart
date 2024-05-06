import 'package:get/get.dart';
import 'package:sq_hub_app/model/skill_item_model.dart';

import 'safe_convert.dart';

/// id : 22
/// uid : 64
/// sex : 0
/// skillid : 10
/// skillName : "DATA2 "
/// skillThumb : "https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/DOTA2.png"
/// thumb : "https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1667809245632.jpg"
/// levelid : 66
/// levelName : "Guardian"
/// status : 0
/// reason : ""
/// addtime : 1667809249
/// uptime : 1667809249
/// wswitch : 1
/// coinid : 2
/// coin : 127
/// label : ""
/// voice : ""
/// voiceL : "0"
/// des : ""
/// star : 0.0
/// comments : 0
/// orders : 0
/// stars : 0.0
/// edit : 0
/// backGround : null
/// childItemVoList : []
/// uname : null

class ServiceTopModel {
  // 61
  final int followers;
  // 0
  final int visitorToday;
  // 2
  final int service;
  // 5
  final int following;
  // 0
  final int followerToday;
  // 5.0
  final double ranking;
  // 6
  final int orders;
  // 225
  final int visitor;

  ServiceTopModel({
    this.followers = 0,
    this.visitorToday = 0,
    this.service = 0,
    this.following = 0,
    this.followerToday = 0,
    this.ranking = 0.0,
    this.orders = 0,
    this.visitor = 0,
  });

  factory ServiceTopModel.fromJson(Map<String, dynamic>? json) => ServiceTopModel(
    followers: asT<int>(json, 'followers'),
    visitorToday: asT<int>(json, 'visitorToday'),
    service: asT<int>(json, 'service'),
    following: asT<int>(json, 'following'),
    followerToday: asT<int>(json, 'followerToday'),
    ranking: asT<double>(json, 'ranking'),
    orders: asT<int>(json, 'orders'),
    visitor: asT<int>(json, 'visitor'),
  );

  Map<String, dynamic> toJson() => {
    'followers': followers,
    'visitorToday': visitorToday,
    'service': service,
    'following': following,
    'followerToday': followerToday,
    'ranking': ranking,
    'orders': orders,
    'visitor': visitor,
  };
}
class SkillModel {
  static const int ONGOING = 0;
  static const int PASS = 1;
  static const int DENIED = 2;

  SkillModel({
    this.id,
    this.uid,
    this.sex,
    this.skillid,
    this.skillName,
    this.skillThumb,
    this.thumb,
    this.levelid,
    this.levelName,
    this.status = ONGOING,
    this.reason,
    this.addtime,
    this.uptime,
    this.wswitch,
    this.coinid,
    this.coin,
    this.label,
    this.voice,
    this.voiceL,
    this.des,
    this.star,
    this.comments,
    this.orders,
    this.stars,
    this.edit,
    this.backGround,
    this.childItemVoList = const [],
    this.uname,
  });
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['addServiceItem'] = addServiceItem;
    map['isTech'] = isTech;
    map['uid'] = uid;
    map['sex'] = sex;
    map['skillid'] = skillid;
    map['skillName'] = skillName;
    map['skillThumb'] = skillThumb;
    map['thumb'] = thumb;
    map['levelid'] = levelid;
    map['levelName'] = levelName;
    map['status'] = status;
    map['reason'] = reason;
    map['addtime'] = addtime;
    map['uptime'] = uptime;
    map['wswitch'] = wswitch;
    map['coinid'] = coinid;
    map['coin'] = coin;
    map['label'] = label;
    map['voice'] = voice;
    map['voiceL'] = voiceL;
    map['des'] = des;
    map['star'] = star;
    map['comments'] = comments;
    map['orders'] = orders;
    map['stars'] = stars;
    map['edit'] = edit;
    map['backGround'] = backGround;
    if (childItemVoList != null) {
      map['childItemVoList'] = childItemVoList?.map((v) => v.toJson()).toList();
    }
    map['uname'] = uname;
    return map;
  }
  SkillModel.fromJson(dynamic json) {
    id = json['id'];
    addServiceItem = json['addServiceItem'];
    isTech = json['isTech'];
    uid = json['uid'];
    sex = json['sex'];
    skillid = json['skillid'];
    skillName = json['skillName'];
    skillThumb = json['skillThumb'];
    thumb = json['thumb'];
    levelid = json['levelid'];
    levelName = json['levelName'];
    status = json['status'];
    reason = json['reason'];
    addtime = json['addtime'];
    uptime = json['uptime'];
    wswitch = json['wswitch'];
    coinid = json['coinid'];
    coin = json['coin'];
    label = json['label'];
    voice = json['voice'];
    voiceL = json['voiceL'];
    des = json['des'];
    star = json['star'];
    comments = json['comments'];
    orders = json['orders'];
    stars = json['stars'];
    edit = json['edit'];
    backGround = json['backGround'];
    if (json['childItemVoList'] != null) {
      childItemVoList = [];
      json['childItemVoList'].forEach((v) {
        childItemVoList.add(SkillItemModel.fromJson(v));
      });
    }
    uname = json['uname'];
  }

  int? id;
  int? uid;
  int? sex;
  int? skillid;
  String? skillName;
  String? skillThumb;
  String? thumb;
  int? levelid;
  String? levelName;
  int? status; //0审核中1通过2拒绝3hide
  String? reason;
  int? addtime;
  int? uptime;
  int? wswitch;
  int? coinid;
  int? coin;
  String? label;
  String? voice;
  String? voiceL;
  String? des;
  double? star;
  int? comments;
  int? orders;
  double? stars;
  int? edit;
  int? addServiceItem;
  int? isTech;
  dynamic backGround;
  List<SkillItemModel> childItemVoList = [];
  dynamic uname;
  RxBool _expanded = RxBool(false);

  bool get expanded => _expanded.value;

  changeExpanded() {
    expanded = !expanded;
  }

  set expanded(bool value) {
    _expanded.value = value;
  }
}
