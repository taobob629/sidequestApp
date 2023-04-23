import '../other_profile/mdoel/player_info_mdoel.dart';

class GameDetailModel {
  GameDetailModel({
    required this.voice,
    required this.serviceItem,
    required this.backGround,
    required this.rejectReason,
    required this.gameName,
    required this.server,
    required this.intro,
    required this.style,
    required this.stars,
    required this.platform,
    required this.status,
    required this.position,
  });

  String voice;
  List<ServiceItem> serviceItem;
  String backGround;
  String rejectReason;
  String gameName;
  String server;
  String intro;
  String style;
  String position;
  double stars;
  String platform;
  int status;

  factory GameDetailModel.fromJson(Map<String, dynamic> json) => GameDetailModel(
    voice: json["voice"],
    serviceItem: List<ServiceItem>.from(json["serviceItem"].map((x) => ServiceItem.fromJson(x))),
    backGround: json["backGround"],
    rejectReason: json["rejectReason"],
    position: json["position"] ?? '',
    gameName: json["gameName"],
    server: json["Server"] ?? '',
    intro: json["intro"] ?? '',
    style: json["Style"] ?? '',
    stars: json["stars"]?.toDouble(),
    platform: json["platform"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "voice": voice,
    "serviceItem": List<dynamic>.from(serviceItem.map((x) => x.toJson())),
    "backGround": backGround,
    "rejectReason": rejectReason,
    "gameName": gameName,
    "Server": server,
    "intro": intro,
    "Style": style,
    "stars": stars,
    "position": position,
    "platform": platform,
    "status": status,
  };
}