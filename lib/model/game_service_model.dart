import 'package:get/get.dart';

class GameServiceModel {
  String category;
  List<GameInfo> games;

  GameServiceModel({required this.category, this.games = const []});

  factory GameServiceModel.fromJson(Map<String, dynamic> json) {
    return GameServiceModel(
      category: json['category'] ?? '',
      games: json['games'] != null
          ? (json['games'] as List).map((i) => GameInfo.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    return data;
  }
}

class GameInfo {
  late String desc;
  RxInt _favorite = RxInt(0);
  late String gameName;
  late int gameid;
  late int uid;
  late String url;

  int get favorite => _favorite.value;

  set favorite(int value) {
    _favorite.value = value;
  }

  changeFocus() {
    if (favorite == 0) {
      favorite = 1;
      return;
    }
    favorite = 0;
  }

  GameInfo.fromJson(Map<String, dynamic> json) {
    desc = json['desc'] ?? '';
    favorite = json['favorite'] ?? 0;
    gameName = json['gameName'] ?? '';
    gameid = json['gameid'] ?? 0;
    uid = json['uid'] ?? 0;
    url = json['url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['favorite'] = this.favorite;
    data['gameName'] = this.gameName;
    data['gameid'] = this.gameid;
    data['uid'] = this.uid;
    data['url'] = this.url;
    return data;
  }
}
