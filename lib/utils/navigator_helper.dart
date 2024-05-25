import 'dart:convert';

import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/profile/address/list/address_page.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../api/post_api.dart';
import '../api/profile_api.dart';
import '../api/wy_http.dart';
import '../common/address_model.dart';
import '../common/web_page.dart';
import '../controller/user_controller.dart';
import '../model/coupon_model.dart';
import '../model/pay_order_model.dart';
import '../model/task_model.dart';
import '../ui/pages/booking/booking_page.dart';
import '../ui/pages/events/event/event_page.dart';
import '../ui/pages/home/news_page.dart';
import '../ui/pages/pay/pay_page.dart';
import '../ui/pages/playwith/play_balance_page.dart';
import '../ui/pages/profile/balance/balance_page.dart';
import '../ui/pages/profile/coupon/coupon_page.dart';
import '../ui/pages/profile/edit/edit_profile_page.dart';
import '../ui/pages/profile/other_profile/other_profile_page.dart';
import '../ui/pages/profile/task/detail/task_detail_page.dart';
import '../ui/pages/search/search_page.dart';
import '../ui/pages/service/skill/list/view.dart';
import '../ui/pages/shop/product/product_page.dart';
import '../ui/pages/social/post/post_detail_page.dart';
import '../ui/pages/social/post/release_post_page.dart';

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

  static void toOtherProfile(uid, {gid}) {
    if (Get.isRegistered<OtherProfileController>()) {
      Get.back();
    }
    showLoading();
    ProfileApi.getPlayerInfo(playerId: uid.toString(), gid: gid)
        .then((playerInfo) {
          Get.to(() => OtherProfilePage(),
              arguments: playerInfo..uid = int.tryParse(uid.toString()) ?? 0);
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
          Get.to(() => PostDetailPage(), arguments: postItem);
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
        userController.switchLogin();
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

  static void gotoCouponPage({
    int couponType = 0,
    int tab = 0,
    PayOrderModel? payOrderModel,
    Map<String, dynamic>? preOrder,
    Function(CouponsListModel)? onSelect,
    Function? whenComplete,
    bool showTabbar = true,
  }) {
    Get.to(() => CouponPage(
          couponType: couponType,
          payOrderModel: payOrderModel,
          preOrder: preOrder,
          tab: tab,
          showTabbar: showTabbar,
        ))?.then((model) {
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
        switch (page) {
          case "news":
            Get.to(() => NewsPage(id: id));
            break;
          case "neproductws":
            Get.to(() => ProductPage(productId: id));
            break;
          case "activity":
            Get.to(() => EventPage(id: id, type: 1));
            break;
          case "match":
            Get.to(() => EventPage(id: id, type: 2));
            break;
          case "coin_topup":
            Get.to(() => PlayBalancePage());
            break;
          case "create_post":
            Get.to(() => ReleasePostPage());
            break;
          case "task":
            showLoading();
            var response =
                await http.get('/app/client/task/task?id=${map['id']}');
            dismissLoading();
            if (response.data != null) {
              TaskOutModel outModel = TaskOutModel.fromJson(response.data);
              if (outModel.tasks.isNotEmpty) {
                Get.to(() => TaskDetailPage(), arguments: {
                  'model': outModel.tasks.first,
                  'skipFlag': true,
                });
              } /*else {
                showErrorWidget('data is empty'.tr);
              }*/
            }
            break;
        }
      }
      if (page == "balance") {
        double amount = map["amount"] == null ? 0.0 : map["amount"] * 1.0;
        Get.to(() => BalancePage(
              amount: amount,
            ));
      } else if (page == "booking") {
        Get.to(() => BookingPage());
      } else if (page == "coin") {
        Get.to(() => PlayBalancePage(), arguments: Map()..['page'] = 0);
      } else if (page == "sidekick_service") {
        Get.to(() => SkillListPage());
      }
    }
  }
}
