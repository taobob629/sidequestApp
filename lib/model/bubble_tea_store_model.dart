class BubbleTeaStoreModel {
  int? id;
  String? name;
  String? address;
  String? telephone;
  String? headImage;
  String? images;
  String? email;
  String? openTime;
  dynamic remark;
  int? manager;
  dynamic managerName;
  int? booking;
  String? map;
  String? album;
  dynamic areaVoList;
  dynamic userPhone;

  BubbleTeaStoreModel({
    this.id,
    this.name,
    this.address,
    this.telephone,
    this.headImage,
    this.images,
    this.email,
    this.openTime,
    this.remark,
    this.manager,
    this.managerName,
    this.booking,
    this.map,
    this.album,
    this.areaVoList,
    this.userPhone,
  });

  factory BubbleTeaStoreModel.fromJson(Map<String, dynamic> json) => BubbleTeaStoreModel(
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
    userPhone: json["userPhone"],
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
    "userPhone": userPhone,
  };
}
