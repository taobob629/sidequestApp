import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../api/profile_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/game_detail_model.dart';
import '../../../model/player_info_mdoel.dart';
import '../../../model/rating_comment_model.dart';
import '../../../service/voice_player.dart';
import '../main_page.dart';
import '../profile/play_order/play_order_page.dart';

class GameHomeCtr extends GetxRefreshController<RatingCommentModel> {
  String liveid = "";
  int gameId = 0;
  String skillId = "";
  String avatar = "";
  String nickName = "";
  String voice = "";
  String uk = "";
  String price = "0.0";
  String unit = "";
  int age = 0;
  int sex = 0;
  int total = 0;
  bool isSelf = false;
  String gameName = "";
  String discount = "";

  bool ifShow = false;
  String gameInfoId = "gameInfoId";
  GameDetailModel? model;
  double mutilGameHeight = 0;

  AudioManager audioManager = AudioManager.instance;

  @override
  void onInit() {
    if (Get.arguments is Map) {
      liveid = Get.arguments["liveid"].toString();
      skillId = Get.arguments["skillId"].toString();
      avatar = Get.arguments["avatar"].toString();
      nickName = Get.arguments["nickName"].toString();
      price = Get.arguments["price"].toString();
      unit = Get.arguments["unit"].toString();
      uk = Get.arguments["uk"].toString();
      age = Get.arguments["age"] ?? 0;
      sex = Get.arguments["sex"] ?? 0;
      gameId = Get.arguments["gameId"] ?? 0;
      gameName = Get.arguments["gameName"] ?? "";
      voice = Get.arguments["voice"] ?? "";
    }
    isSelf = UserController.find.userProfile.pwId.toString() == liveid;
    super.onInit();

    _requestData();
  }

  @override
  void onClose() {
    super.onClose();
    AudioManager.instance.stop();
  }

  void editService(ServiceItem serviceItem) async {
    var uk = await Get.to(() {
      return MulitablePlayOrderPage(
        serviceItemList: [serviceItem],
        discount: getItemDiscount(serviceItem.discount),
      );
    });
    // flog('$res', 'Get.to(()=>PlayOrder');
    if (uk != null) {
      if (uk == 0) {
        Get.back();
        MainPageController.find.currentIndex.value = 3;
        MainPageController.find.controller.jumpToPage(3);
      }
    }
  }

  void showOrHideGame() {
    if (model?.serviceItem.length == 1) {
      editService(model!.serviceItem.first);
      return;
    }
    ifShow = !ifShow;
    mutilGameHeight = ifShow
        ? mutilGameHeight = 44.h * (model?.serviceItem.length ?? 0) + 15.h
        : 0;
    update([gameInfoId]);
  }

  void _requestData() async {
    model = await ProfileApi.serviceDetailById(gameId);

    if ((model?.serviceItem.length ?? 0) > 1) {
      mutilGameHeight = ifShow
          ? mutilGameHeight = 44.h * (model?.serviceItem.length ?? 0) + 15.h
          : 0;
    }
    for (int i = 0; i < model!.serviceItem.length; i++) {
      if (model!.serviceItem[i].discount != '' &&
          jsonDecode(model!.serviceItem[i].discount)['enable'] == 1) {
        discount = model!.serviceItem[i].discount;
        break;
      }
    }

    update([gameInfoId]);
  }

  @override
  Future<List<RatingCommentModel>> loadData({int pageNum = 1}) async {
    var response =
        await ProfileApi.othersCommentsList(liveid: liveid, skillId: skillId);
    total = response["total"];
    return response["rows"]
        .map<RatingCommentModel>((e) => RatingCommentModel.fromJson(e))
        .toList();
  }

  String getDiscount() {
    if (model == null || discount == '') {
      return '';
    }
    if (discount.contains('type')) {
      dynamic result = jsonDecode(discount);
      int type = result['type'];
      if (type == 1) {
        return 'Discount ${result['discount']}% OFF';
      } else if (type == 2) {
        return 'Buy ${result['buy']} Get ${result['get']}';
      } else if (type == 3) {
        return '1st Order Free ${result['discount']}% OFF';
      }
    }
    return discount;
  }

  String getItemDiscount(String discount) {
    if (discount.isEmpty) {
      return '';
    }
    for (int i = 0; i < model!.serviceItem.length; i++) {
      if (model!.serviceItem[i].discount != '' &&
          jsonDecode(model!.serviceItem[i].discount)['enable'] == 1) {
        discount = model!.serviceItem[i].discount;
        break;
      }
    }

    if (discount.contains('type')) {
      dynamic result = jsonDecode(discount);
      int type = result['type'];
      if (type == 1) {
        return 'Discount ${result['discount']}% OFF';
      } else if (type == 2) {
        return 'Buy ${result['buy']} Get ${result['get']}';
      } else if (type == 3) {
        return '1st Order Free ${result['discount']}% OFF';
      }
    }
    return discount;
  }
}
