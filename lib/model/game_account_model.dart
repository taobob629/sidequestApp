class GameAccountModel {
  Riot? riot;

  GameAccountModel({
    this.riot,
  });

  factory GameAccountModel.fromJson(Map<String, dynamic> json) =>
      GameAccountModel(
        riot: json["Riot"] == null ? null : Riot.fromJson(json["Riot"]),
      );

  Map<String, dynamic> toJson() => {
        "Riot": riot?.toJson(),
      };
}

class Riot {
  List<User>? users;
  String? url;

  Riot({
    this.users,
    this.url,
  });

  factory Riot.fromJson(Map<String, dynamic> json) => Riot(
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "url": url,
      };
}

class User {
  String? lolname;

  User({
    this.lolname,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        lolname: json["lolname"],
      );

  Map<String, dynamic> toJson() => {
        "lolname": lolname,
      };
}
