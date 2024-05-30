class GameModel {
  String? type;
  List<GameItemModel> list;

  GameModel({
    this.type,
    required this.list,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
    type: json["type"],
    list: json["list"] == null ? [] : List<GameItemModel>.from(json["list"]!.map((x) => GameItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class GameItemModel {
  String? image;
  String? name;
  List<String> stores = [];
  int? type;

  GameItemModel({
    this.image,
    this.name,
    this.type,
    required this.stores,
  });

  factory GameItemModel.fromJson(Map<String, dynamic> json) => GameItemModel(
    image: json["image"],
    name: json["name"],
    type: json["type"],
    stores: json["stores"] == null ? [] : List<String>.from(json["stores"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "type": type,
  };
}

class SimpleGameModel {
  SimpleGameModel({
    this.name,
    this.icon,
    this.thumb,
    this.id,
    this.image,
  });

  SimpleGameModel.fromJson(dynamic json) {
    name = json['name'];
    icon = json['icon'];
    thumb = json['thumb'];
    image = json['image'];
    id = json['id'].toString();

  }

  String? name;
  String? icon;
  String? thumb;
  String? image;
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
    map['thumb'] = thumb;
    map['image'] = image;
    return map;
  }
}
