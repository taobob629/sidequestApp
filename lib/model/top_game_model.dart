class TopGameModel {
  String? image;
  String? name;
  String? desc;
  dynamic trend;
  String? id;
  String? icon;
  String? thumb;

  TopGameModel({
    this.image,
    this.name,
    this.desc,
    this.trend,
    this.id,
    this.icon,
    this.thumb,
  });

  factory TopGameModel.fromJson(Map<String, dynamic> json) => TopGameModel(
        image: json["image"],
        name: json["name"],
        desc: json["desc"],
        trend: json["trend"],
        id: json["id"]?.toString(),
        icon: json["icon"],
        thumb: json["thumb"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "desc": desc,
        "trend": trend,
        "id": id,
        "icon": icon,
        "thumb": thumb,
      };
}
