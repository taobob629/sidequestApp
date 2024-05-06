// class IntegralGoodsModel {
//   List<Drink> all;
//   List<Drink> drink;
//
//   IntegralGoodsModel({
//     required this.all,
//     required this.drink,
//   });
//
//   factory IntegralGoodsModel.fromJson(Map<String, dynamic> json) => IntegralGoodsModel(
//     all: json["all"] == null ? [] : List<Drink>.from(json["all"]!.map((x) => Drink.fromJson(x))),
//     drink: json["Drink"] == null ? [] : List<Drink>.from(json["Drink"]!.map((x) => Drink.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "all": List<dynamic>.from(all.map((x) => x.toJson())),
//     "Drink": List<dynamic>.from(drink.map((x) => x.toJson())),
//   };
// }
//
// class Drink {
//   int? id;
//   dynamic goodsSn;
//   String? name;
//   int? categoryId;
//   dynamic gallery;
//   dynamic brief;
//   int? isOnSale;
//   int? sortOrder;
//   String? picUrl;
//   int? isNew;
//   int? isHot;
//   String? unit;
//   String? memberPrice;
//   String? retailPrice;
//   dynamic detail;
//   String? tax;
//   dynamic categoryName;
//   int? storage;
//   String? specifications;
//   int? num;
//   int? threshold;
//   dynamic combos;
//   int? subCategory;
//   int? voucher;
//   dynamic deleted;
//   String? material;
//   double? salePrice;
//   String? coupons;
//   int? points;
//
//   Drink({
//     this.id,
//     this.goodsSn,
//     this.name,
//     this.categoryId,
//     this.gallery,
//     this.brief,
//     this.isOnSale,
//     this.sortOrder,
//     this.picUrl,
//     this.isNew,
//     this.isHot,
//     this.unit,
//     this.memberPrice,
//     this.retailPrice,
//     this.detail,
//     this.tax,
//     this.categoryName,
//     this.storage,
//     this.specifications,
//     this.num,
//     this.threshold,
//     this.combos,
//     this.subCategory,
//     this.voucher,
//     this.deleted,
//     this.material,
//     this.salePrice,
//     this.coupons,
//     this.points,
//   });
//
//   factory Drink.fromJson(Map<String, dynamic> json) => Drink(
//     id: json["id"],
//     goodsSn: json["goodsSn"],
//     name: json["name"],
//     categoryId: json["categoryId"],
//     gallery: json["gallery"],
//     brief: json["brief"],
//     isOnSale: json["isOnSale"],
//     sortOrder: json["sortOrder"],
//     picUrl: json["picUrl"],
//     isNew: json["isNew"],
//     isHot: json["isHot"],
//     unit: json["unit"],
//     memberPrice: json["memberPrice"],
//     retailPrice: json["retailPrice"],
//     detail: json["detail"],
//     tax: json["tax"],
//     categoryName: json["categoryName"],
//     storage: json["storage"],
//     specifications: json["specifications"],
//     num: json["num"],
//     threshold: json["threshold"],
//     combos: json["combos"],
//     subCategory: json["subCategory"],
//     voucher: json["voucher"],
//     deleted: json["deleted"],
//     material: json["material"],
//     salePrice: json["salePrice"],
//     coupons: json["coupons"],
//     points: json["points"] ?? 0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "goodsSn": goodsSn,
//     "name": name,
//     "categoryId": categoryId,
//     "gallery": gallery,
//     "brief": brief,
//     "isOnSale": isOnSale,
//     "sortOrder": sortOrder,
//     "picUrl": picUrl,
//     "isNew": isNew,
//     "isHot": isHot,
//     "unit": unit,
//     "memberPrice": memberPrice,
//     "retailPrice": retailPrice,
//     "detail": detail,
//     "tax": tax,
//     "categoryName": categoryName,
//     "storage": storage,
//     "specifications": specifications,
//     "num": num,
//     "threshold": threshold,
//     "combos": combos,
//     "subCategory": subCategory,
//     "voucher": voucher,
//     "deleted": deleted,
//     "material": material,
//     "salePrice": salePrice,
//     "coupons": coupons,
//     "points": points,
//   };
// }
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
