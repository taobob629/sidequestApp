class SimpleUserInfoModel {
  int? age;
  double? distance;
  int? id;
  String? name;
  int? online;
  int? orders;
  int? sex;
  String? signature;
  double? star;
  String? thumb;
  int? userLevel;
  String? levelName;
  List<GameInfo>? games;

  SimpleUserInfoModel(
      {this.age,
      this.distance,
      this.id,
      this.name,
      this.online,
      this.orders,
      this.sex,
      this.signature,
      this.star,
      this.thumb,
      this.levelName,
        this.games=const [],
      this.userLevel});

  factory SimpleUserInfoModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserInfoModel(
      age:json['age'],
      distance: json['distance'],
      id: json['id'],
      name: json['name'],
      online: json['online'],
      orders: json['orders'],
      sex: json['sex'],
      signature: json['signature'],
      star: json['star'],
      thumb: json['thumb'],
      userLevel: json['userLevel'],
      levelName: json['levelName'],
      games: json['games'] != null ? (json['games'] as List).map((i) => GameInfo.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['distance'] = this.distance;
    data['id'] = this.id;
    data['name'] = this.name;
    data['online'] = this.online;
    data['orders'] = this.orders;
    data['sex'] = this.sex;
    data['signature'] = this.signature;
    data['star'] = this.star;
    data['thumb'] = this.thumb;
    data['userLevel'] = this.userLevel;
    data['levelName'] = this.levelName;
    return data;
  }
}

class GameInfo {
  String? ico;
  String? name;

  GameInfo({this.ico, this.name});

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      name: json['name'],
      ico: json['ico'],
    );
  }
}
