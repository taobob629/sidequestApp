
import 'dart:convert';

import '../config/app_config.dart';

class ProductItemModel {
  late int id = 0;
  late String name = "";
  late String image = "";
  late String price = "0";
  late bool hot = false;
  late String tax = "0";
  late List<ProductItemModel> combos = [];

  late int count = 1;

  double getTax(){
    return double.parse(tax);
  }

  double getPrice(){
    return double.parse(price);
  }


  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is ProductItemModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => name.hashCode;


  ProductItemModel();

  ProductItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] == null ? "" : json['name'];
    image = json['image'] == null ? AppConfig.noImage : json['image'];
    price = json['price'] == null ? "0" : json['price'];
    hot = json['hot'] == null ? false:json['hot'];
    tax = json['tax'] == null ? "0" : json['tax'];
    count = json['count']== null ? 1 : json['count'];
    combos = json['combos'] == null ? []:(jsonDecode(json['combos']) as List).map((e) => ProductItemModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['hot'] = this.hot;
    data['tax'] = this.tax;
    data['count'] = this.count;
    data['combos'] = jsonEncode(this.combos);
    return data;
  }
}