import 'dart:developer';

import 'package:sq_hub_app/model/promotion_item_model.dart';

import 'activity_item_model.dart';
import 'match_item_model.dart';
import 'news_item_model.dart';

class HeadlineModel {
  late String type;
  // late int id;
  // late String title;
  // late String image;
  // late String time;
  // late String location;
  // late String bonus;
  // late String flag;
  // late List<String> avatarList;
  // late int totalMembers;
  // late List<String> imageList;
  late dynamic model;

  HeadlineModel();

  HeadlineModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if(type == "news"){
      model = NewsItemModel.fromJson(json);
    }else if(type == "activity"){
      model = ActivityItemModel.fromJson(json);
    }else if(type == "match"){
      model = MatchItemModel.fromJson(json);
    }else if(type == "promotion"){
      model = PromotionItemModel.fromJson(json);
    }else{
      log("no supported type $type");
      model = NewsItemModel();
    }
    // id = json['id'];
    // title = json['title'];
    // image = json['image'] == null ? "" : json['image'];
    // time = json['time'];
    // location = json['location'] == null ? "" : json['location'];
    // bonus = json['bonus'] == null ? "" : json['bonus'];
    // flag = json['flag'] == null ? "" : json['flag'];
    // totalMembers = json['totalMembers'] == null ? 0 : json['flag'];
    // imageList = json['imageList'] == null ? [] : (json['imageList'] as List).map<String>((e) => e.toString()).toList() ;
  }
}