
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
class SimpleGameModel {
  SimpleGameModel({
    this.name,
    this.icon,
    this.id,
  });

  SimpleGameModel.fromJson(dynamic json) {
    name = json['name'];
    icon = json['icon'];
    id = json['id'];
  }

  String? name;
  String? icon;
  String? id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleGameModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['id'] = id;
    map['icon'] = icon;
    return map;
  }
}