import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';
import 'package:sq_hub_app/ui/dialog/dialog_select_tea_time.dart';

import '../api/hubs_api.dart';
import '../common/dialog_date_time_picker.dart';
import '../config/icon_font.dart';
import '../utils/toast_utils.dart';

class BubbleConfirmOrderCtr extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;

  late List<Widget> tabs = [
    Text(
      'Eat In'.tr,
      style: TextStyle(
        fontFamily: FONT_MEDIUM,
        fontSize: 10.sp,
      ),
      maxLines: 1,
    ),
    Text(
      'Takeaway'.tr,
      style: TextStyle(
        fontFamily: FONT_MEDIUM,
        fontSize: 10.sp,
      ),
      maxLines: 1,
    )
  ];

  // 0:eatin; 1:take away
  int eatin = 0;

  int startHour = 12;
  int endHour = 23;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: tabs.length, vsync: this);
  }

  void calStoreOpenTime() {
    RegExp regExp = RegExp(r'(\d{2}):\d{2}');
    Iterable<Match> matches = regExp.allMatches(
        TabBubbleTeaCtr.find.currentSelectStore.value.openTime ?? '');
    if (matches.length == 2) {
      startHour = int.parse(matches.elementAt(0).group(1)!);
      endHour = int.parse(matches.elementAt(1).group(1)!);
      DateTime nowTime = DateTime.now();
      if (nowTime.hour >= endHour && nowTime.minute > 0) {
        showError('The store is closed at the current time.');
        Get.back();
      }
    }
  }

  void selectTime() async {
    // 使用正则表达式提取数字
    DateTime nowTime = DateTime.now();
    if (startHour < nowTime.hour) {
      startHour = nowTime.hour;
    }

    final value = await Get.dialog(
      DialogSelectTeaTime(
        startHour: startHour,
        endHour: endHour,
        startMin: 0,
        endMin: 0,
      ),
      barrierColor: Colors.black26,
    );
    if (value != null) {}
  }

  void payment() async {
    DateTime nowTime = DateTime.now();
    if (nowTime.hour >= endHour && nowTime.minute > 0) {
      showError('The store is closed at the current time.');
      Get.back();
      return;
    }
    showLoading();
    List<Map<String, dynamic>> goodsList = [];
    TabBubbleTeaCtr.find.selectTeaList.forEach((element) {
      List<String> toppingList = [];
      if (element.selectTopping.length == 1) {
        toppingList.add(element.selectTopping[0].name);
      } else if (element.selectTopping.length == 2) {
        toppingList.add(element.selectTopping[0].name);
        toppingList.add(element.selectTopping[1].name);
      }

      Map<String, dynamic> map = {
        "id": element.id,
        "num": element.count,
        "commodityId": element.commodityId,
        "specifications": jsonEncode({
          "CupSize": element.selectSize?.name,
          "Ice": element.selectIce?.name,
          "Sugar": element.selectSugar?.name,
          "DrinkExtra": toppingList,
          "FoodExtra": []
        }),
      };
      goodsList.add(map);
    });

    await HubsApi.confirmOrder(
      storeId: TabBubbleTeaCtr.find.currentSelectStore.value.id ?? 0,
      goodsList: goodsList,
      eatin: eatin.toString(),
      arrivalTime: ((DateTime.now().millisecondsSinceEpoch) ~/ 1000).toString(),
    );
    dismissLoading();

    // PayOrderModel payOrderModel = PayOrderModel();
    //
    // payOrderModel.goodsPrice = TabBubbleTeaCtr.find.totalPrice.value;
    // payOrderModel.totalAmount = TabBubbleTeaCtr.find.totalPrice.value;
    // payOrderModel.type = -1;
    //
    // NavigatorHelper.gotoPayPage(payOrderModel);
  }
}
