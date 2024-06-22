import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';
import 'package:sq_hub_app/ui/dialog/dialog_select_tea_time.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';

import '../api/coupon_api.dart';
import '../api/hubs_api.dart';
import '../config/icon_font.dart';
import '../model/bubble_confirm_order_model.dart';
import '../model/coupon_model.dart';
import '../model/pay_order_model.dart';
import '../ui/dialog/dialog_confirm_store.dart';
import '../ui/pages/order/detail/view.dart';
import '../utils/navigator_helper.dart';
import '../utils/toast_utils.dart';

class BubbleConfirmOrderCtr extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  var discount = "0.0".obs;
  var totalPrice = "0".obs;
  CouponsListModel? selectCouponModel;

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

    totalPrice.value = TabBubbleTeaCtr.find.totalPrice.value;
    discount.value = TabBubbleTeaCtr.find.discount.value;
    tabController = TabController(length: tabs.length, vsync: this);
  }

  void selectCoupon(CouponsListModel couponModel) async {
    selectCouponModel = couponModel;
    showLoading();
    final result = await CouponApi.calculateOrder(
      storeId: TabBubbleTeaCtr.find.currentSelectStore.value.id ?? 0,
      goodsList: TabBubbleTeaCtr.find.getGoodsListMap(),
      couponId: selectCouponModel?.id,
    );
    dismissLoading();

    if (result != null) {
      discount.value = result;
      totalPrice.value = totalPrice.value.minus(result);
    }
  }

  bool isWithinBusinessHours(String openTime) {
    final timeParts = openTime.split(" - ");
    startHour = int.parse(timeParts[0].split(':')[0]);
    startMin = int.parse(timeParts[0].split(':')[1]);
    endHour = int.parse(timeParts[1].split(':')[0]);
    endMin = int.parse(timeParts[1].split(':')[1]);

    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    // 处理跨天情况
    bool isOpenCrossDay = endHour < startHour;

    if (isOpenCrossDay) {
      // 营业时间跨天
      return (currentHour > startHour ||
              (currentHour == startHour && currentMinute >= startMin)) ||
          (currentHour < endHour ||
              (currentHour == endHour && currentMinute < endMin));
    } else {
      // 营业时间未跨天
      return (currentHour > startHour ||
              (currentHour == startHour && currentMinute >= startMin)) &&
          (currentHour < endHour ||
              (currentHour == endHour && currentMinute < endMin));
    }
  }

  void calStoreOpenTime() {
    if (TabBubbleTeaCtr.find.currentSelectStore.value.openTime == null) {
      showError("The current store's business hours were not obtained.");
      Get.back();
    }
    if (!isWithinBusinessHours(
        TabBubbleTeaCtr.find.currentSelectStore.value.openTime!)) {
      showError('The store is closed at the current time.');
      Get.back();
    }

    DateTime nowTime = DateTime.now();
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
    if (!isWithinBusinessHours(
        TabBubbleTeaCtr.find.currentSelectStore.value.openTime!)) {
      showError('The store is closed at the current time.');
      Get.back();
    }
    final result = await showCustom(DialogConfirmStore());
    if (result != null) {
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
            ? ((DateTime.now().millisecondsSinceEpoch) ~/ 1000).toString()
            : ((selectPickupTime.millisecondsSinceEpoch) ~/ 1000).toString(),
        couponId: selectCouponModel?.id,
      );
      dismissLoading();
      if (model.orderInfo?.statusValue != 1) {
        Get.back();
        Get.back();
        // 余额支付失败，需要跳转到那边去；
        PayOrderModel payOrderModel = PayOrderModel();

        payOrderModel.goodsPrice = TabBubbleTeaCtr.find.totalPrice.value;
        payOrderModel.totalAmount = model.orderInfo?.subTotal.toString() ?? "0";
        payOrderModel.orderId = model.orderInfo?.id.toString() ?? '0';
        payOrderModel.type = PayType.PW_BUBBLE_TEA_PAY;

        NavigatorHelper.gotoPayPage(payOrderModel);
        TabBubbleTeaCtr.find.clearTea();
      } else {
        TabBubbleTeaCtr.find.clearTea();
        Get.offUntil(
            GetPageRoute(
              settings: RouteSettings(arguments: model.orderInfo?.id),
              page: () => OrderDetailPage(),
            ),
            (route) => route.isFirst);
      }
    }
  }
}
