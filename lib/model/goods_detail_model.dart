import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sq_hub_app/widget/tag/tag_bean.dart';

class GoodsDetailModel extends Equatable{
  String? brief;
  String? image;
  String? price;
  List<GoodsParams> cpusize;
  String? name;
  List<GoodsParams> ice;
  int? id;
  int? commodityId;
  List<GoodsParams> topping;
  List<GoodsParams> sugar;

  TagBean? selectSize;
  TagBean? selectIce;
  TagBean? selectSugar;
  List<TagBean> selectTopping = [];
  int count = 1;

  GoodsDetailModel({
    this.brief,
    this.image,
    this.price,
    required this.cpusize,
    this.name,
    required this.ice,
    this.id,
    this.commodityId,
    required this.topping,
    required this.sugar,
  });

  factory GoodsDetailModel.fromJson(Map<String, dynamic> json) =>
      GoodsDetailModel(
        brief: json["brief"],
        image: json["image"],
        price: json["price"],
        cpusize: json["cpusize"] == null
            ? []
            : List<GoodsParams>.from(
                json["cpusize"]!.map((x) => GoodsParams.fromJson(x))),
        name: json["name"],
        ice: json["ice"] == null
            ? []
            : List<GoodsParams>.from(
                json["ice"]!.map((x) => GoodsParams.fromJson(x))),
        id: json["id"],
        commodityId: json["commodityId"],
        topping: json["topping"] == null
            ? []
            : List<GoodsParams>.from(
                json["topping"]!.map((x) => GoodsParams.fromJson(x))),
        sugar: json["sugar"] == null
            ? []
            : List<GoodsParams>.from(
                json["sugar"]!.map((x) => GoodsParams.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "brief": brief,
        "image": image,
        "price": price,
        "cpusize": List<dynamic>.from(cpusize.map((x) => x.toJson())),
        "name": name,
        "ice": List<dynamic>.from(ice.map((x) => x.toJson())),
        "id": id,
        "commodityId": commodityId,
        "topping": List<dynamic>.from(topping.map((x) => x.toJson())),
        "sugar": List<dynamic>.from(sugar.map((x) => x.toJson())),
      };

  GoodsDetailModel.deepCopy(GoodsDetailModel original)
      : this.brief = original.brief,
        this.image = original.image,
        this.price = original.price,
        this.cpusize = original.cpusize.map((item) => GoodsParams.deepCopy(item)).toList(),
        this.name = original.name,
        this.ice = original.ice.map((item) => GoodsParams.deepCopy(item)).toList(),
        this.id = original.id,
        this.commodityId = original.commodityId,
        this.topping = original.topping.map((item) => GoodsParams.deepCopy(item)).toList(),
        this.sugar = original.sugar.map((item) => GoodsParams.deepCopy(item)).toList(),
        this.selectSize = original.selectSize != null ? TagBean.deepCopy(original.selectSize!) : null,
        this.selectIce = original.selectIce != null ? TagBean.deepCopy(original.selectIce!) : null,
        this.selectSugar = original.selectSugar != null ? TagBean.deepCopy(original.selectSugar!) : null,
        this.selectTopping = original.selectTopping.map((item) => TagBean.deepCopy(item)).toList(),
        this.count = original.count;

  @override
  List<Object?> get props => [brief, image, price, cpusize, name, ice, id,  commodityId, topping, sugar, selectSize, selectIce, selectSugar, selectTopping];

  bool equalsIgnoringCount(GoodsDetailModel other) {
    return other.brief == brief &&
        other.image == image &&
        other.price == price &&
        listEquals(other.cpusize, cpusize) &&
        other.name == name &&
        listEquals(other.ice, ice) &&
        other.id == id &&
        other.commodityId == commodityId &&
        listEquals(other.topping, topping) &&
        listEquals(other.sugar, sugar) &&
        other.selectSize == selectSize &&
        other.selectIce == selectIce &&
        other.selectSugar == selectSugar &&
        listEquals(other.selectTopping, selectTopping);
  }
}

class GoodsParams extends Equatable {
  double price;
  String name;

  GoodsParams({
    required this.price,
    required this.name,
  });

  factory GoodsParams.fromJson(Map<String, dynamic> json) => GoodsParams(
        price: json["price"] ?? 0.0,
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "name": name,
      };

  GoodsParams.deepCopy(GoodsParams original)
      : this.price = original.price,
        this.name = original.name;

  @override
  List<Object?> get props => [price, name];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoodsParams &&
        other.price == price &&
        other.name == name;
  }

  @override
  int get hashCode => price.hashCode ^ name.hashCode;
}
