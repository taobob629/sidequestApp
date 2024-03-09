class IntegralCouponModel {
  List<CouponList> couponList;
  PresentGrade presentGrade;

  IntegralCouponModel({
    required this.couponList,
    required this.presentGrade,
  });

  factory IntegralCouponModel.fromJson(Map<String, dynamic> json) => IntegralCouponModel(
    couponList: json["couponList"] == null ? [] : List<CouponList>.from(json["couponList"]!.map((x) => CouponList.fromJson(x))),
    presentGrade: json["presentGrade"] == null ? PresentGrade(couponList: []) : PresentGrade.fromJson(json["presentGrade"]),
  );

  Map<String, dynamic> toJson() => {
    "couponList": couponList == null ? [] : List<dynamic>.from(couponList.map((x) => x.toJson())),
    "presentGrade": presentGrade.toJson(),
  };
}

class PresentGrade {
  String? gradeName;
  String? gradeExplain;
  int? integralTotal;
  int? nextIntegralNumber;
  List<CouponList> couponList;

  PresentGrade({
    this.gradeName,
    this.gradeExplain,
    required this.couponList,
    this.integralTotal,
    this.nextIntegralNumber,
  });

  factory PresentGrade.fromJson(Map<String, dynamic> json) => PresentGrade(
    gradeName: json["gradeName"],
    gradeExplain: json["gradeExplain"],
    couponList: json["couponList"] == null ? [] : List<CouponList>.from(json["couponList"]!.map((x) => CouponList.fromJson(x))),
    nextIntegralNumber: json["nextIntegralNumber"] ?? 0,
    integralTotal: json["integralTotal"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "gradeName": gradeName,
    "gradeExplain": gradeExplain,
    "couponList": couponList == null ? [] : List<dynamic>.from(couponList!.map((x) => x.toJson())),
    "integralTotal": integralTotal,
    "nextIntegralNumber": nextIntegralNumber,
  };
}

class CouponList {
  int? id;
  String? name;
  String? description;
  int? type;
  String? code;
  String? useLimit;
  int? discount;
  dynamic limitStore;
  String? productId;
  String? startTime;
  String? expireTime;
  int? total;
  int? usedCount;
  dynamic content;
  int? freeTime;
  int? level;
  int? clientType;
  String? msg;
  int? extend;
  int? length;
  int? repeatedly;
  dynamic manualcode;
  CreateBy? createBy;
  int? deleted;
  int? expireBasedOn;
  int? creditDiscount;
  int? couponUsage;
  int? responseCode;
  dynamic note;
  int? storeCoupon;
  dynamic stores;

  CouponList({
    this.id,
    this.name,
    this.description,
    this.type,
    this.code,
    this.useLimit,
    this.discount,
    this.limitStore,
    this.productId,
    this.startTime,
    this.expireTime,
    this.total,
    this.usedCount,
    this.content,
    this.freeTime,
    this.level,
    this.clientType,
    this.msg,
    this.extend,
    this.length,
    this.repeatedly,
    this.manualcode,
    this.createBy,
    this.deleted,
    this.expireBasedOn,
    this.creditDiscount,
    this.couponUsage,
    this.responseCode,
    this.note,
    this.storeCoupon,
    this.stores,
  });

  factory CouponList.fromJson(Map<String, dynamic> json) => CouponList(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    code: json["code"],
    useLimit: json["useLimit"],
    discount: json["discount"],
    limitStore: json["limitStore"],
    productId: json["productId"],
    startTime: json["startTime"],
    expireTime: json["expireTime"],
    total: json["total"],
    usedCount: json["usedCount"],
    content: json["content"],
    freeTime: json["freeTime"],
    level: json["level"],
    clientType: json["clientType"],
    msg: json["msg"],
    extend: json["extend"],
    length: json["length"],
    repeatedly: json["repeatedly"],
    manualcode: json["manualcode"],
    createBy: createByValues.map[json["createBy"]]!,
    deleted: json["deleted"],
    expireBasedOn: json["expireBasedOn"],
    creditDiscount: json["creditDiscount"],
    couponUsage: json["couponUsage"],
    responseCode: json["responseCode"],
    note: json["note"],
    storeCoupon: json["storeCoupon"],
    stores: json["stores"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": type,
    "code": code,
    "useLimit": useLimit,
    "discount": discount,
    "limitStore": limitStore,
    "productId": productId,
    "startTime": startTime,
    "expireTime": expireTime,
    "total": total,
    "usedCount": usedCount,
    "content": content,
    "freeTime": freeTime,
    "level": level,
    "clientType": clientType,
    "msg": msg,
    "extend": extend,
    "length": length,
    "repeatedly": repeatedly,
    "manualcode": manualcode,
    "createBy": createByValues.reverse[createBy],
    "deleted": deleted,
    "expireBasedOn": expireBasedOn,
    "creditDiscount": creditDiscount,
    "couponUsage": couponUsage,
    "responseCode": responseCode,
    "note": note,
    "storeCoupon": storeCoupon,
    "stores": stores,
  };
}

enum CreateBy {
  ADMIN
}

final createByValues = EnumValues({
  "admin": CreateBy.ADMIN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
