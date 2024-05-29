class BubbleTeaAdModel {
  int? id;
  String? name;
  String? link;
  String? url;
  int? position;
  String? content;
  String? enabled;
  String? createTime;
  dynamic expire;
  int? sort;
  dynamic storeId;
  int? duration;
  dynamic type;

  BubbleTeaAdModel({
    this.id,
    this.name,
    this.link,
    this.url,
    this.position,
    this.content,
    this.enabled,
    this.createTime,
    this.expire,
    this.sort,
    this.storeId,
    this.duration,
    this.type,
  });

  factory BubbleTeaAdModel.fromJson(Map<String, dynamic> json) => BubbleTeaAdModel(
    id: json["id"],
    name: json["name"],
    link: json["link"],
    url: json["url"],
    position: json["position"],
    content: json["content"],
    enabled: json["enabled"],
    createTime: json["createTime"],
    expire: json["expire"],
    sort: json["sort"],
    storeId: json["storeId"],
    duration: json["duration"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "link": link,
    "url": url,
    "position": position,
    "content": content,
    "enabled": enabled,
    "createTime": createTime,
    "expire": expire,
    "sort": sort,
    "storeId": storeId,
    "duration": duration,
    "type": type,
  };
}
