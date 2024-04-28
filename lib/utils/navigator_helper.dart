import 'dart:convert';

import 'package:get/get.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../api/profile_api.dart';
import '../api/wy_http.dart';
import '../common/web_page.dart';
import '../model/coupon_model.dart';
import '../model/pay_order_model.dart';
import '../ui/pages/pay/pay_page.dart';
import '../ui/pages/profile/coupon/coupon_page.dart';
import '../ui/pages/profile/coupon/tab_view.dart';
import '../ui/pages/home/news_page.dart';

class NavigatorHelper {
  NavigatorHelper._();

  static void gotoPayPage(PayOrderModel payOrderModel,
      {bool offPage = false, Function? whenComplete}) {
    // showInfo('Please recharge via our store till');
    if (offPage) {
      Get.off(() => PayPage(payOrderModel: payOrderModel))?.then((value) {
        if (value != null && value == true) {
          whenComplete?.call();
        }
      });
    } else {
      Get.to(() => PayPage(payOrderModel: payOrderModel))?.then((value) {
        if (value != null && value == true) {
          whenComplete?.call();
        }
      });
    }
  }

  static Future<void> gotoConfigTarget(String content) async {
    Map<String, dynamic> map = jsonDecode(content);
    if (map["type"] == "h5") {
      String? url = map["target"];
      String? title = map["title"];
      Get.to(() => WebPage(
            title: title,
            url: url,
          ));
    } else if (map["type"] == "page") {
      String? page = map["target"];
      int? id = map["id"];
      if (id != null) {
        switch (page) {
          case "news":
            Get.to(() => NewsPage(id: id));
            break;
        }
      }
    }
  }

  static void gotoCouponPage(
      {int couponType = 0,
      int tab = 0,
      PayOrderModel? payOrderModel,
      Map<String, dynamic>? preOrder,
      Function(CouponModel)? onSelect,
      Function? whenComplete}) {
    Get.to(() => CouponPage(
          couponType: couponType,
          payOrderModel: payOrderModel,
          preOrder: preOrder,
          tab: tab,
        ))?.then((model) {
      if (model != null) {
        onSelect?.call(model);
      }
    }).whenComplete(() => whenComplete?.call());
  }

  static void gotoCouponTabPage(
      {int couponType = 0,
      PayOrderModel? payOrderModel,
      Function(CouponModel)? onSelect,
      Function? whenComplete}) {
    Get.to(() => CouponTabPage())?.then((model) {
      if (model != null) {
        onSelect?.call(model);
      }
    }).whenComplete(() => whenComplete?.call());
  }
}
