/*
  controller
  sidequest_hub_app
  desc: 关注和粉丝列表
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/model/attention_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/attention/list/view.dart';

class AttentionListPageController extends GetxRefreshController {
  int type;

  AttentionListPageController(this.type);

  UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    initialRefresh = true;
    super.onInit();
  }

  @override
  Future<List<AttentionModel>> loadData({int pageNum = 0}) async {
    var list;
    //return [UserInfoModel()];
    switch (type) {
      case TYPE_FANS:
        list = await UserApi.fansList(pageNum, pageSize);
        break;
      case TYPE_FOLLOW:
        list = await UserApi.attentionList(pageNum, pageSize);
        break;
    }
    return list;
  }

  Future<void> unfollow(int index, var id) async {
    EasyLoading.show();
    var response = await UserApi.attention(id);
    if (response.statusCode == 200) {
      EasyLoading.showSuccess('${response.statusMessage}');
      list.removeAt(index);
      list.refresh();
      Get.find<AttentionListPageController>(tag: 'attention_$TYPE_FANS').onRefresh();
      // Get.find<PlayDetailController>(tag: '${userController.userInfoModel.value.pwuserId}').refresh();
    }
  }

  Future<void> fanceFollow(int index, AttentionModel user) async {
    EasyLoading.show();
    var response = await UserApi.attention(user.id);
    if (response.statusCode == 200) {
      EasyLoading.showSuccess('${response.statusMessage}');
      if (user.status.value == BOTH_FOCUS) {
        user.status.value = 0;
      } else {
        user.status.value = BOTH_FOCUS;
      }
      //更新follow列表
      Get.find<AttentionListPageController>(tag: 'attention_$TYPE_FOLLOW').onRefresh();
      // Get.find<PlayDetailController>(tag: '${userController.userInfoModel.value.pwuserId}').refresh();
    }
  }
}
