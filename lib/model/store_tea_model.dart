class StoreTeaModel {
  int? id;
  int? storeId;
  int? commodityId;
  String? selfAttr;
  String? timeRange;
  String? printers;
  int? categoryId;
  dynamic brief;
  int? isOnSale;
  dynamic sortOrder;
  dynamic picUrl;
  dynamic isNew;
  dynamic isHot;
  dynamic unit;
  dynamic memberPrice;
  String? retailPrice;
  dynamic detail;
  dynamic tax;
  dynamic orderByColumn;
  dynamic isAsc;
  int? storage;
  String? historySelfAttr;
  dynamic specifications;
  int? threshold;
  int? subCategory;
  int? vipOnly;
  int? voucher;
  dynamic material;
  dynamic categoryName;
  String? name;
  dynamic onSale;
  String? image;

  StoreTeaModel({
    this.id,
    this.storeId,
    this.commodityId,
    this.selfAttr,
    this.timeRange,
    this.printers,
    this.categoryId,
    this.brief,
    this.isOnSale,
    this.sortOrder,
    this.picUrl,
    this.isNew,
    this.isHot,
    this.unit,
    this.memberPrice,
    this.retailPrice,
    this.detail,
    this.tax,
    this.orderByColumn,
    this.isAsc,
    this.storage,
    this.historySelfAttr,
    this.specifications,
    this.threshold,
    this.subCategory,
    this.vipOnly,
    this.voucher,
    this.material,
    this.categoryName,
    this.name,
    this.onSale,
    this.image,
  });

  factory StoreTeaModel.fromJson(Map<String, dynamic> json) => StoreTeaModel(
    id: json["id"],
    storeId: json["storeId"],
    commodityId: json["commodityId"],
    selfAttr: json["selfAttr"],
    timeRange: json["timeRange"],
    printers: json["printers"],
    categoryId: json["categoryId"],
    brief: json["brief"],
    isOnSale: json["isOnSale"],
    sortOrder: json["sortOrder"],
    picUrl: json["picUrl"],
    isNew: json["isNew"],
    isHot: json["isHot"],
    unit: json["unit"],
    memberPrice: json["memberPrice"],
    retailPrice: json["retailPrice"],
    detail: json["detail"],
    tax: json["tax"],
    orderByColumn: json["orderByColumn"],
    isAsc: json["isAsc"],
    storage: json["storage"],
    historySelfAttr: json["historySelfAttr"],
    specifications: json["specifications"],
    threshold: json["threshold"],
    subCategory: json["subCategory"],
    vipOnly: json["vipOnly"],
    voucher: json["voucher"],
    material: json["material"],
    categoryName: json["categoryName"],
    name: json["name"],
    onSale: json["onSale"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "storeId": storeId,
    "commodityId": commodityId,
    "selfAttr": selfAttr,
    "timeRange": timeRange,
    "printers": printers,
    "categoryId": categoryId,
    "brief": brief,
    "isOnSale": isOnSale,
    "sortOrder": sortOrder,
    "picUrl": picUrl,
    "isNew": isNew,
    "isHot": isHot,
    "unit": unit,
    "memberPrice": memberPrice,
    "retailPrice": retailPrice,
    "detail": detail,
    "tax": tax,
    "orderByColumn": orderByColumn,
    "isAsc": isAsc,
    "storage": storage,
    "historySelfAttr": historySelfAttr,
    "specifications": specifications,
    "threshold": threshold,
    "subCategory": subCategory,
    "vipOnly": vipOnly,
    "voucher": voucher,
    "material": material,
    "categoryName": categoryName,
    "name": name,
    "onSale": onSale,
    "image": image,
  };
}
