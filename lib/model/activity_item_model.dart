
import 'package:wy/config/app_config.dart';

class ActivityItemModel {
  late int id = 0;
  late String title = "";
  late String image = AppConfig.noImage;
  late String time = "";
  late bool inProgress = false;

  ActivityItemModel();

  ActivityItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'] == null ? AppConfig.noImage : json['image'];
    time = json['time'];
  }
}