import 'package:get/get.dart';

class GameSectionModel {
  RxList<KeyMap> gameLevel;
  RxList<KeyMap> genders;
  RxList<KeyMap> language;
  RxList<KeyMap> levels;

  GameSectionModel(
      {required this.gameLevel,
      required this.genders,
      required this.language,
      required this.levels});

  factory GameSectionModel.fromJson(Map<String, dynamic> json) {
    return GameSectionModel(
      gameLevel: json['gameLevel'] != null
          ? RxList((json['gameLevel'] as List).map((i) => KeyMap.fromJson(i)).toList())
          : RxList(),
      genders: json['genders'] != null
          ? RxList((json['genders'] as List).map((i) => KeyMap.fromJson(i)).toList())
          : RxList(),
      language: json['language'] != null
          ? RxList((json['language'] as List).map((i) => KeyMap.fromJson(i)).toList())
          : RxList(),
      levels: json['levels'] != null
          ? RxList((json['levels'] as List).map((i) => KeyMap.fromJson(i)).toList())
          : RxList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gameLevel != null) {
      data['gameLevel'] = this.gameLevel;
    }
    if (this.genders != null) {
      data['genders'] = this.genders;
    }
    if (this.language != null) {
      data['language'] = this.language;
    }
    if (this.levels != null) {
      data['levels'] = this.levels;
    }
    return data;
  }
}

class KeyMap {
  String? name;
  String? value;

  KeyMap(this.name, this.value);

  @override
  String toString() {
    return 'KeyMap{name: $name, value: $value}';
  }

  KeyMap.fromJson(dynamic json) {
    name = json['name'];
    value = json['value'].toString();
  }
}
