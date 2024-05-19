class TabCyberCafeModel {
  int id;
  String name;
  String address;
  String telephone;
  String headImage;
  dynamic images;
  String email;
  String openTime;
  String shortName;
  dynamic remark;
  int manager;
  dynamic managerName;
  int booking;
  dynamic map;
  dynamic album;
  dynamic areaVoList;

  TabCyberCafeModel({
    required this.id,
    required this.name,
    required this.address,
    required this.telephone,
    required this.headImage,
    this.images,
    required this.email,
    required this.openTime,
    required this.shortName,
    this.remark,
    required this.manager,
    this.managerName,
    required this.booking,
    this.map,
    this.album,
    this.areaVoList,
  });

  factory TabCyberCafeModel.fromJson(Map<String, dynamic> json) => TabCyberCafeModel(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    telephone: json["telephone"],
    headImage: json["headImage"],
    images: json["images"],
    email: json["email"],
    openTime: json["openTime"],
    remark: json["remark"],
    manager: json["manager"],
    managerName: json["managerName"],
    booking: json["booking"],
    map: json["map"],
    album: json["album"],
    areaVoList: json["areaVoList"],
    shortName: json["shortName"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "telephone": telephone,
    "headImage": headImage,
    "images": images,
    "email": email,
    "openTime": openTime,
    "remark": remark,
    "manager": manager,
    "managerName": managerName,
    "booking": booking,
    "map": map,
    "album": album,
    "areaVoList": areaVoList,
    "shortName": shortName,
  };
}
