
import 'package:wy/config/app_config.dart';

class MatchItemModel {
  late int id = 0;
  late String title = "";
  late String image = "";
  late String time = "";
  late String location = "";
  late String bonus = "";
  late String flag = "";
  late List<String> avatarList = [];
  late int totalMembers = 0;

  MatchItemModel();

  MatchItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'] == null || json['image'] == "" ? AppConfig.noImage : json['image'];
    time = json['time'];
    location = json['location'] == null ? "" : json['location'];
    bonus = json['bonus'] == null ? "" : json['bonus'];
    flag = json['flag'] == null || json['flag'] == "" ? AppConfig.noImage : json['flag'];
    totalMembers = json['totalMembers'] == null ? 0 : json['totalMembers'];
  }
}

class MatchContent{
  late int type;
  late String content;
}