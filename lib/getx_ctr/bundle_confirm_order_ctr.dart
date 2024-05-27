import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/getx_ctr/tab_bubble_tea_ctr.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';

import '../api/coupon_api.dart';
import '../api/hubs_api.dart';
import '../config/icon_font.dart';
import '../model/bubble_confirm_order_model.dart';
import '../model/bundles_detail_model.dart';
import '../model/chage_rule_model.dart';
import '../model/coupon_model.dart';
import '../model/pay_order_model.dart';
import '../ui/pages/home/tab_bundles_page.dart';
import '../ui/pages/order/detail/view.dart';
import '../utils/navigator_helper.dart';
import '../utils/toast_utils.dart';

class BundleConfirmOrderCtr extends GetxController {
  CouponsListModel? selectCouponModel;
  var discount = "0.0".obs;

  void selectCoupon(CouponsListModel couponModel) async {
    selectCouponModel = couponModel;
    showLoading();
    List<Map<String, dynamic>> goodsList = [];
    TabBundlesPageController.find.selectList.forEach((element) {
      Map<String, dynamic> map = {
        "id": element.id,
        "num": element.count.value,
        "commodityId": element.commodityId,
      };
      goodsList.add(map);
    });

    final result = await CouponApi.calculateOrder(
      storeId: TabBundlesPageController.find.currentSelectStore.value.id ?? 0,
      goodsList: goodsList,
      couponId: TabBubbleTeaCtr.find.selectCouponModel?.id,
    );
    dismissLoading();

    if (result != null) {
      discount.value = result;
      TabBundlesPageController.find.totalPrice.value =
          TabBundlesPageController.find.yhTotalPrice.minus(result);
    }
  }

  void payment() async {
    showLoading();
    List<Map<String, dynamic>> goodsList = [];
    TabBundlesPageController.find.selectList.forEach((element) {
      Map<String, dynamic> map = {
        "id": element.id,
        "num": element.count.value,
        "commodityId": element.commodityId,
      };
      goodsList.add(map);
    });

    BubbleConfirmOrderModel model = await HubsApi.confirmBundleOrder(
      storeId: TabBundlesPageController.find.currentSelectStore.value.id ?? 0,
      goodsList: goodsList,
      couponId: selectCouponModel?.id,
    );
    dismissLoading();
    TabBundlesPageController.find.clearTea();
    if (model.orderInfo?.statusValue != 1) {
      // 余额支付失败，需要跳转到那边去；
      PayOrderModel payOrderModel = PayOrderModel();

      payOrderModel.goodsPrice = TabBundlesPageController.find.totalPrice.value;
      payOrderModel.totalAmount =
          TabBundlesPageController.find.totalPrice.value;
      payOrderModel.orderId = model.orderInfo?.id.toString() ?? '0';
      payOrderModel.type = PayType.PW_BUBBLE_TEA_PAY;

      Get.back();
      NavigatorHelper.gotoPayPage(
        payOrderModel,
        offPage: true,
      );
    } else {
      TabBundlesPageController.find.clearTea();
      Get.offUntil(
          GetPageRoute(
            settings: RouteSettings(arguments: model.orderInfo?.id),
            page: () => OrderDetailPage(),
          ),
          (route) => route.isFirst);
    }
  }
}
