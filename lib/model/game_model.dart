
import 'package:wy/config/app_config.dart';

class GameModel {
  late String image;
  late String name;
  late int stars;
  late bool popular;

  GameModel();

  GameModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    stars = json['stars'];
    popular = json['popular'];
    image = json['image'] == null ? AppConfig.noImage : json['image'];
  }
}