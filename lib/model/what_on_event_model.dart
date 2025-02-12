class WhatOnEventModel {
  List<Join> joins;
  String? image;
  String? uniqueness;
  final int id;
  final int matchDiff;
  String? time;
  String? title;
  String? thirdLink;

  WhatOnEventModel({
    required this.joins,
    this.image,
    this.uniqueness,
    required this.id,
    required this.matchDiff,
    this.time,
    this.title,
    this.thirdLink,
  });

  factory WhatOnEventModel.fromJson(Map<String, dynamic> json) => WhatOnEventModel(
    joins: json["joins"] == null ? [] : List<Join>.from(json["joins"]!.map((x) => Join.fromJson(x))),
    image: json["image"],
    uniqueness: json["uniqueness"],
    id: json["id"] ?? 0,
    matchDiff: json["matchDiff"] ?? 0,
    time: json["time"],
    title: json["title"],
    thirdLink: json["thirdLink"],
  );

  Map<String, dynamic> toJson() => {
    "joins": List<dynamic>.from(joins.map((x) => x.toJson())),
    "image": image,
    "uniqueness": uniqueness,
    "id": id,
    "matchDiff": matchDiff,
    "time": time,
    "title": title,
    "thirdLink": thirdLink,
  };
}

class Join {
  String? photo;

  Join({
    this.photo,
  });

  factory Join.fromJson(Map<String, dynamic> json) => Join(
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "photo": photo,
  };
}
