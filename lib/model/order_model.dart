
import 'dart:convert';

import 'product_item_model.dart';

class OrderModel {
  late List<ProductItemModel> products = [];
  late String orderId = "";
  late String totalAmount = "0";
  late String discountAmount = "0";
  late String createTime = "";
  late int status = 0;

  OrderModel();

  OrderModel.fromJson(Map<String, dynamic> json) {
    products = jsonDecode(json["products"]).map<ProductItemModel>((item) => ProductItemModel.fromJson(item)).toList();
    orderId = json["orderId"];
    totalAmount = json["totalAmount"];
    createTime = json["createTime"];
    discountAmount = json["discountAmount"];
    status = json["status"];
  }
}