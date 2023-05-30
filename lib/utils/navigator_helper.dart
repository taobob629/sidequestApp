import 'dart:convert';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/api_service/post_api.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/address_model.dart';
import 'package:wy/model/coupon_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/model/task_model.dart';
import 'package:wy/ui/common/web_page.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/events/event/event_page.dart';
import 'package:wy/ui/frame/profile/other_profile/other_profile_page.dart';
import 'package:wy/ui/index/news/news_page.dart';
import 'package:wy/ui/pay/pay_page.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/ui/profile/booking/booking_page.dart';
import 'package:wy/ui/profile/coupon/coupon_page.dart';
import 'package:wy/ui/profile/edit/edit_profile_page.dart';
import 'package:wy/ui/profile/task/detail/task_detail_page.dart';
import 'package:wy/ui/search/search_page.dart';
import 'package:wy/ui/shop/product/product_page.dart';
import 'package:wy/utils/toast_utils.dart';
import 'package:wy/utils/utils.dart';

import '../api_service/profile_api.dart';
import '../ui/profile/address/list/address_page.dart';

class NavigatorHelper {
  NavigatorHelper._();
  static void gotoPayPage(PayOrderModel payOrderModel, {bool offPage = false, Function? whenComplete}) {
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

  static void toOtherProfile(uid, {gid}) {
    if (Get.isRegistered<OtherProfileController>()) {
      Get.back();
    }
    showLoading();
    ProfileApi.getPlayerInfo(playerId: uid.toString(), gid: gid)
        .then((playerInfo) {
          Get.toNamed(AppPages.OtherProfile, arguments: playerInfo..uid = int.tryParse(uid.toString()) ?? 0);
        })
        .whenComplete(() => dismissLoading())
        .catchError((err) {
          print(err);
          dismissLoading();
        });
  }

  static void toPostDetail(postId) {
    showLoading();
    PostApi.getPostDetail(postsId: postId)
        .then((postItem) {
          Get.toNamed(AppPages.PostDetail, arguments: postItem);
        })
        .whenComplete(() => dismissLoading())
        .catchError((err) {
          print(err);
          dismissLoading();
        });
  }

  static void gotoSearchPage() {
    Get.to(() => SearchPage());
  }

  static void gotoEditProfilePage() {
    var userController = Get.find<UserController>();
    Get.to(() => EditProfilePage())?.then((ret) {
      if (ret != null && ret == true) {
        userController.login();
      }
    });
  }

  static Future<AddressModel?> gotoAddressPage({bool select = false}) async {
    AddressModel? model;
    await Get.to(() => AddressPage(
          select: select,
        ))?.then((value) => model = value);
    return model;
  }

  static void gotoCouponPage({int couponType = 0, PayOrderModel? payOrderModel, Map<String, dynamic>? preOrder, Function(CouponModel)? onSelect, Function? whenComplete}) {
    Get.to(() => CouponPage(
          couponType: couponType,
          payOrderModel: payOrderModel,
          preOrder: preOrder,
        ))?.then((model) {
      if (model != null) {
        onSelect?.call(model);
      }
    }).whenComplete(() => whenComplete?.call());
  }

  static void gotoCouponTabPage({int couponType = 0, PayOrderModel? payOrderModel, Function(CouponModel)? onSelect, Function? whenComplete}) {
    Get.toNamed(AppPages.COUPON_TAB_PAGE)?.then((model) {
      if (model != null) {
        onSelect?.call(model);
      }
    }).whenComplete(() => whenComplete?.call());
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
        if (page == "news") {
          Get.to(() => NewsPage(id: id));
        } else if (page == "product") {
          Get.to(() => ProductPage(productId: id));
        } else if (page == "activity") {
          Get.to(() => EventPage(id: id, type: 1));
        } else if (page == "match") {
          Get.to(() => EventPage(id: id, type: 2));
        }else if (page == "task") {
          var response = await http.get(
            '/app/client/task/list?id=$id'
          );
          if (response.data != null) {
            List<TaskModel> list = response.data
                .map<TaskModel>((item) => TaskModel.fromJson(item))
                .toList();
            if (list.isNotEmpty) {
              Get.to(() => TaskDetailPage(), arguments: list.first);
            }
          }
        }
      }
      if (page == "balance") {
        double amount = map["amount"] == null ? 0.0 : map["amount"] * 1.0;
        Get.to(() => BalancePage(
              amount: amount,
            ));
      } else if (page == "booking") {
        Get.to(() => BookingPage());
      }
    }
  }
}
