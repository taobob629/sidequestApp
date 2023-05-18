class CyberCafeDetailModel {
  int id;
  String name;
  String address;
  String telephone;
  String userPhone;
  String headImage;
  dynamic images;
  String email;
  String openTime;
  dynamic remark;
  int manager;
  dynamic managerName;
  int booking;
  dynamic map;
  dynamic album;
  List<AreaVoList> areaVoList;

  CyberCafeDetailModel({
    required this.id,
    required this.name,
    required this.address,
    required this.telephone,
    required this.userPhone,
    required this.headImage,
    this.images,
    required this.email,
    required this.openTime,
    this.remark,
    required this.manager,
    this.managerName,
    required this.booking,
    this.map,
    this.album,
    required this.areaVoList,
  });

  factory CyberCafeDetailModel.fromJson(Map<String, dynamic> json) => CyberCafeDetailModel(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    telephone: json["telephone"],
    userPhone: json["userPhone"],
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
    areaVoList: List<AreaVoList>.from(json["areaVoList"].map((x) => AreaVoList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "telephone": telephone,
    "userPhone": userPhone,
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
    "areaVoList": List<dynamic>.from(areaVoList.map((x) => x.toJson())),
  };
}

class AreaVoList {
  int id;
  String areaName;
  int storeId;
  dynamic storeName;
  dynamic price;
  String description;
  String machine;
  dynamic freeTime;
  dynamic startUse;
  int areaStatus;
  double bookingPrice;
  int booking;
  int computers;
  int useFree;

  AreaVoList({
    required this.id,
    required this.areaName,
    required this.storeId,
    this.storeName,
    this.price,
    required this.description,
    required this.machine,
    this.freeTime,
    this.startUse,
    required this.areaStatus,
    required this.bookingPrice,
    required this.booking,
    required this.computers,
    required this.useFree,
  });

  factory AreaVoList.fromJson(Map<String, dynamic> json) => AreaVoList(
    id: json["id"],
    areaName: json["areaName"],
    storeId: json["storeId"],
    storeName: json["storeName"],
    price: json["price"],
    description: json["description"],
    machine: json["machine"],
    freeTime: json["freeTime"],
    startUse: json["startUse"],
    areaStatus: json["areaStatus"],
    bookingPrice: json["bookingPrice"],
    booking: json["booking"],
    computers: json["computers"],
    useFree: json["useFree"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "areaName": areaName,
    "storeId": storeId,
    "storeName": storeName,
    "price": price,
    "description": description,
    "machine": machine,
    "freeTime": freeTime,
    "startUse": startUse,
    "areaStatus": areaStatus,
    "bookingPrice": bookingPrice,
    "booking": booking,
    "computers": computers,
    "useFree": useFree,
  };
}

class DescriptionBean {
  String startTime;
  String endTime;
  String price;
  int priceType;
  int week;

  DescriptionBean({
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.priceType,
    required this.week,
  });

  factory DescriptionBean.fromJson(Map<String, dynamic> json) => DescriptionBean(
    startTime: json["startTime"],
    endTime: json["endTime"],
    price: json["price"],
    priceType: json["priceType"],
    week: json["week"],
  );

  Map<String, dynamic> toJson() => {
    "startTime": startTime,
    "endTime": endTime,
    "price": price,
    "priceType": priceType,
    "week": week,
  };
}

