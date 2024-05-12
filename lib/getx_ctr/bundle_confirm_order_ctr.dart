import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';

import '../config/icon_font.dart';
import '../model/bundles_detail_model.dart';
import '../model/chage_rule_model.dart';
import '../model/pay_order_model.dart';
import '../ui/pages/home/tab_bundles_page.dart';
import '../utils/navigator_helper.dart';

class BundleConfirmOrderCtr extends GetxController {

  void payment() async {
    PayOrderModel payOrderModel = PayOrderModel();

    payOrderModel.goodsPrice = TabBundlesPageController.find.totalPrice.value;
    payOrderModel.totalAmount = TabBundlesPageController.find.totalPrice.value;
    payOrderModel.type = -1;

    NavigatorHelper.gotoPayPage(payOrderModel);
  }
}
