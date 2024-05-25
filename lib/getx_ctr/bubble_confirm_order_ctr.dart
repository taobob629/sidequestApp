import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';
import 'package:sq_hub_app/ui/dialog/dialog_select_tea_time.dart';

import '../api/hubs_api.dart';
import '../common/dialog_date_time_picker.dart';
import '../config/icon_font.dart';
import '../model/bubble_confirm_order_model.dart';
import '../model/pay_order_model.dart';
import '../ui/pages/order/detail/view.dart';
import '../utils/navigator_helper.dart';
import '../utils/toast_utils.dart';

class BubbleConfirmOrderCtr extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;

  late List<Widget> tabs = [
    FittedBox(
      child: Text(
        'Eat In'.tr,
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 10.sp,
        ),
        maxLines: 1,
      ),
    ),
    FittedBox(
      child: Text(
        'Takeaway'.tr,
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 10.sp,
        ),
        maxLines: 1,
      ),
    )
  ];

  // 0:eatin; 1:take away
  var eatin = 0.obs;

  int startHour = 12;
  int startMin = 0;
  int endHour = 23;
  int endMin = 0;

  var selectHour = "12".obs;
  var selectMin = "00".obs;

  late DateTime selectPickupTime;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: tabs.length, vsync: this);
  }

  void calStoreOpenTime() {
    // 定义正则表达式模式来匹配时间格式
    RegExp regExp = RegExp(r'(\d{2}):(\d{2})');
    // 使用正则表达式查找所有匹配项
    Iterable<RegExpMatch> matches = regExp.allMatches(
        TabBubbleTeaCtr.find.currentSelectStore.value.openTime ?? '');
    // 提取匹配项中的数字
    List<int> times = [];
    for (RegExpMatch match in matches) {
      times.add(int.parse(match.group(1)!)); // 小时
      times.add(int.parse(match.group(2)!)); // 分钟
    }

    if (times.length == 4) {
      startHour = times[0];
      startMin = times[1];
      endHour = times[2];
      endMin = times[3];

      DateTime nowTime = DateTime.now();
      if (nowTime.hour >= endHour && nowTime.minute > endMin) {
        showError('The store is closed at the current time.');
        Get.back();
      }
      if (nowTime.hour > startHour) {
        selectHour.value =
            nowTime.hour < 10 ? "0${nowTime.hour}" : "${nowTime.hour}";
        if (nowTime.minute > startMin) {
          selectMin.value =
              nowTime.minute < 10 ? "0${nowTime.minute}" : "${nowTime.minute}";
        } else {
          selectMin.value = startMin < 10 ? "0$startMin" : "$startMin";
        }
      } else {
        selectHour.value = startHour < 10 ? "0$startHour" : "$startHour";
        selectMin.value = startMin < 10 ? "0$startMin" : "$startMin";
      }

      selectPickupTime = DateTime(
        nowTime.year,
        nowTime.month,
        nowTime.day,
        startHour,
        0,
      );
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
    if (value != null) {
      selectHour.value = value["selectHour"] < 10
          ? "0${value["selectHour"]}"
          : "${value["selectHour"]}";
      selectMin.value = value["selectMin"] < 10
          ? "0${value["selectMin"]}"
          : "${value["selectMin"]}";

      selectPickupTime = DateTime(
        nowTime.year,
        nowTime.month,
        nowTime.day,
        value["selectHour"],
        value["selectMin"],
      );
    }
  }

  void payment() async {
    DateTime nowTime = DateTime.now();
    if (nowTime.hour >= endHour && nowTime.minute > endMin) {
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

    BubbleConfirmOrderModel model = await HubsApi.confirmOrder(
      storeId: TabBubbleTeaCtr.find.currentSelectStore.value.id ?? 0,
      goodsList: goodsList,
      eatin: eatin.value.toString(),
      arrivalTime: eatin.value == 0
          ? ((nowTime.millisecondsSinceEpoch) ~/ 1000).toString()
          : ((selectPickupTime.millisecondsSinceEpoch) ~/ 1000).toString(),
      couponId: TabBubbleTeaCtr.find.selectCouponModel?.id,
    );
    dismissLoading();
    Get.back();
    if (model.orderInfo?.statusValue != 1) {
      // 余额支付失败，需要跳转到那边去；
      PayOrderModel payOrderModel = PayOrderModel();

      payOrderModel.goodsPrice = TabBubbleTeaCtr.find.totalPrice.value;
      payOrderModel.totalAmount = TabBubbleTeaCtr.find.totalPrice.value;
      payOrderModel.orderId = model.orderInfo?.id.toString() ?? '0';
      payOrderModel.type = PayType.PW_BUBBLE_TEA_PAY;

      NavigatorHelper.gotoPayPage(payOrderModel);
    } else {
      TabBubbleTeaCtr.find.clearTea();
      Get.to(() => OrderDetailPage(), arguments: model.orderInfo?.id);
    }
  }
}
