class MatchInitModel {

  MatchInitModel({
    required this.orderId,
    required this.unit,
    required this.language,
    required this.services,
    required this.others,
  });

  int orderId;
  List<Language> unit;
  List<Language> language;
  List<Service> services;
  List<Language> others;

  factory MatchInitModel.fromJson(Map<String, dynamic> json) => MatchInitModel(
    orderId: json["orderId"],
    unit: List<Language>.from(json["unit"].map((x) => Language.fromJson(x))),
    language: List<Language>.from(json["language"].map((x) => Language.fromJson(x))),
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
    others: List<Language>.from(json["others"].map((x) => Language.fromJson(x))),
  );
}

class Language {
  Language({
    required this.name,
    required this.value,
  });

  String name;
  String value;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Language && runtimeType == other.runtimeType && name == other.name && value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

class Service {
  Service({
    required this.games,
    required this.id,
    required this.category,
  });

  List<Game> games;
  String id;
  String category;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    games: List<Game>.from(json["games"].map((x) => Game.fromJson(x))),
    id: json["id"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "games": List<dynamic>.from(games.map((x) => x.toJson())),
    "id": id,
    "category": category,
  };
}

class Game {
  Game({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
