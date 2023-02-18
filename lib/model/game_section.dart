import 'package:get/get.dart';

class GameSectionModel {
  RxList<String> gameLevel;
  RxList<String> genders;
  RxList<String> language;
  RxList<String> levels;

  GameSectionModel(
      {required this.gameLevel,
      required this.genders,
      required this.language,
      required this.levels});

  factory GameSectionModel.fromJson(Map<String, dynamic> json) {
    return GameSectionModel(
      gameLevel: json['gameLevel'] != null ? new RxList<String>.from(json['gameLevel']) : RxList(),
      genders: json['genders'] != null ? RxList<String>.from(json['genders']) : RxList(),
      language: json['language'] != null ? RxList<String>.from(json['language']) : RxList(),
      levels: json['levels'] != null ? RxList<String>.from(json['levels']) : RxList(),
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
