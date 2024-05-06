import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';

import '../config/icon_font.dart';
import '../model/chage_rule_model.dart';
import '../model/pay_order_model.dart';
import '../utils/navigator_helper.dart';

class ConfirmOrderCtr extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  late List<Widget> tabs = [
    Text(
      'In Store'.tr,
      style: TextStyle(
        fontFamily: FONT_LIGHT,
        fontSize: 12.sp,
      ),
      maxLines: 1,
    ),
    Text(
      'Pack'.tr,
      style: TextStyle(
        fontFamily: FONT_LIGHT,
        fontSize: 12.sp,
      ),
    )
  ];

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: tabs.length, vsync: this);
  }

  void payment() async {
    PayOrderModel payOrderModel = PayOrderModel();

    payOrderModel.goodsPrice = TabBubbleTeaCtr.find.totalPrice.value;
    payOrderModel.totalAmount = TabBubbleTeaCtr.find.totalPrice.value;
    payOrderModel.type = -1;

    NavigatorHelper.gotoPayPage(payOrderModel);
  }
}
