

import 'package:wy/model/event_detail_model.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/utils/utils.dart';

class PlayDetailModel {
  late int userId = 0;
  late String memberId = "";
  late String signature = "";
  late String emptyAlbumDesc1 = "";
  late String emptyAlbumDesc2 = "";
  late List<String> imageList = [];
  late String name = "";
  late String avatar = "";
  late String avatarThumb = "";
  late String language = "";
  late int age = 0;
  late int online = 0;
  late int sex = 0;
  late int level = 0;
  late int follows = 0;
  late int follow = 0;
  late int userLevel = 0;
  late num mark=0.0;
  late String orderSn = "";
  late int fans = 0;
  late int isauth = 0;
  late int orders=0;
  late Location location=Location();
  late List<SkillModel> skills = [];

  PlayDetailModel();

  PlayDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['basicInfo']['id'];
    mark=json['basicInfo']['stars']==0?5.0:json['basicInfo']['stars'];
    orders=json['basicInfo']['orders'];
    memberId = json['basicInfo']['userLogin'];
    signature = json['basicInfo']['signature'];
    imageList = json['thumb'] == null ? [] : (json['thumb'] as List).map<String>((e) => e['thumb']).toList();
    name = json['basicInfo']['userNickname'] ?? '';
    avatar = json['basicInfo']['avatar'] ?? '';
    avatarThumb = json['basicInfo']['avatarThumb'] ?? '';
    location =  Location.fromStr(json['basicInfo']['location']);
    age = json['basicInfo']['age'] ?? 0;
    language = json['basicInfo']['language'] ?? '';
    online = json['basicInfo']['online'] ?? 0;
    sex = json['basicInfo']['sex'] ?? 2;
    level = json['level'] ?? 0;
    follows = json['followers'] ?? 0;
    follow = json['follow'] ?? 0;
    fans = json['fans'] ?? 0;
    isauth = json['basicInfo']['isauth'] ?? 0;
    userLevel = json['userLevel'] ?? 0;
    orderSn = json['orderSn'] ?? '';
    emptyAlbumDesc1 = json['emptyAlbumDesc1'] ?? '';
    emptyAlbumDesc2 = json['emptyAlbumDesc2'] ?? '';

    skills = json["games"].map<SkillModel>((item) => SkillModel.fromJson(item)).toList();
  }

}

class SkillModel{
  late String id = "";
  late int coinType = 0;
  late String thumb = "";
  late String background = "";
  late String name = "";
  late String level = "";
  late String label = "";
  late String unit = "";
  late int coin = 0;
  late int authId = 0;
  late int wswitch = 0;
  late double star = 0;
  late int orders = 0;
  late List serviceItem;
  SkillModel();

  SkillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    serviceItem = json['serviceItem'] ?? [];
    coinType = json['coinType'] ?? 0;
    thumb = json['thumb'] ??"";
    background = json['background'] ??"";
    name = json['name']?? "";
    unit = json['unit']?? "";
    coin = json['coin'] ?? 0;
    authId = json['authId'] ?? 0;
    wswitch = json['wswitch'] ?? 0;
    star = json['star'] ?? 0.0;
    orders = json['orders'] ?? 0;
    label = json['label']?? "";
    level = json['level']?? "";
  }

}