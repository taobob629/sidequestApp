/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/order_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/model/order_detail.dart';
import 'package:wy/utils/utils.dart';

class OrderRefoundController extends BasePageController {
  RxList<RefoundReasonModel> list = RxList();
  TextEditingController etCommnetController=TextEditingController();
  late OrderDetailModel order;
  @override
  void onInit() {
    super.onInit();
    order=Get.arguments;
    flog('order $order');
    initReasons();
  }

  //获取退款理由
  initReasons() async {
    var result = await OrderApi.getRefoundReasons();
    list.addAll(result);
  }
}
