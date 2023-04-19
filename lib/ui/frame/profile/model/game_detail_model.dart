class GameDetailModel {
  GameDetailModel({
    required this.voice,
    required this.backGround,
    required this.server,
    required this.intro,
    required this.style,
    required this.position,
    required this.stars,
    required this.platform,
  });

  String voice;
  String backGround;
  String server;
  String intro;
  String style;
  String position;
  double stars;
  String platform;

  factory GameDetailModel.fromJson(Map<String, dynamic> json) => GameDetailModel(
    voice: json["voice"],
    backGround: json["backGround"],
    server: json["Server"] ?? '',
    intro: json["intro"] ?? '',
    style: json["Style"] ?? '',
    position: json["position"] ?? '',
    stars: json["stars"],
    platform: json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "voice": voice,
    "backGround": backGround,
    "Server": server,
    "intro": intro,
    "Style": style,
    "position": position,
    "stars": stars,
    "platform": platform,
  };
}
