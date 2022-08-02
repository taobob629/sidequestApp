
import 'dart:convert';

import 'package:wy/config/app_config.dart';
import 'package:wy/model/product_item_model.dart';

class ProductDetailModel {
  late int id = 0;
  late List<String> imageList = [];
  late String info = "";
  late String price = "0.0";
  late String name = "";
  late String coverImage = "";
  late String tax = "0";
  late List<ProductItemModel> combos = [];

  ProductDetailModel();

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    info = json['info'] == null ? "" :  json['info'];
    imageList = (json['imageList'] as List).map<String>((e) => e.toString()).toList();
    if(imageList.length == 0){
      imageList.add(AppConfig.noImage);
    }
    coverImage = json['image'] == null ? AppConfig.noImage:json['image'];
    price = json['price'];
    name = json['name'];

    combos = json['combos'] == null ? []:(jsonDecode(json['combos']) as List).map((e) => ProductItemModel.fromJson(e)).toList();
  }
}