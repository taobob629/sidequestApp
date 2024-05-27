import 'package:get/get.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';

class BundlesModel {
  String? brief;
  String? image;
  String? price;
  String? name;
  int? id;
  int? commodityId;
  var count = 1.obs;

  BundlesModel({
    this.brief,
    this.image,
    this.price,
    this.name,
    this.id,
    this.commodityId,
  });

  factory BundlesModel.fromJson(Map<String, dynamic> json) => BundlesModel(
    brief: json["brief"],
    image: json["image"],
    price: json["price"],
    name: json["name"],
    id: json["id"],
    commodityId: json["commodityId"],
  );

  Map<String, dynamic> toJson() => {
    "brief": brief,
    "image": image,
    "price": price,
    "name": name,
    "id": id,
    "commodityId": commodityId,
  };

  String getTotalPrice() {
    return (price ?? "0").mul(count.value.toString());
  }
}
