import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/game_service_model.dart';
import 'package:wy/model/skill_item_model.dart';
import 'package:wy/model/skill_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/service/add/add_game_page.dart';
import 'package:wy/utils/utils.dart';

/*
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class SkillListPageController extends GetxController {
  static const int INIT = 0;
  static const int FINISH = 1;
  RxInt _pageState = RxInt(INIT);

  int get pageState => _pageState.value;

  set pageState(int value) {
    _pageState.value = value;
  }

  RxList<SkillModel> _list = RxList();

  List<SkillModel> get list => _list.value;

  set list(List<SkillModel> value) {
    _list.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  initData() async {
    list = await UserApi.myauthlist();
    pageState = FINISH;
  }

  onRefresh() async {
    pageState = INIT;
    list = await UserApi.myauthlist();
    pageState = FINISH;
  }

  addSkillItem(SkillModel data, {SkillItemModel? skillItemModel}) async {
    if (data.status != SkillModel.PASS) {
      return;
    }
    if (skillItemModel == null) {
      Get.toNamed(AppPages.AddSkillItem,
              arguments: Map<String, dynamic>()
                ..['skillName'] = data.skillName
                ..['gameId'] = data.skillid
                ..['service'] = data
                ..['levelId'] = data.levelid)
          ?.then((res) {
        if (res) onRefresh();
      });
      return;
    }
    Get.toNamed(AppPages.SkillItem,
            arguments: Map()
              ..['id'] = skillItemModel?.id
              ..['price'] = skillItemModel?.price
              ..['enabled'] = skillItemModel?.enabled
              ..['name'] = skillItemModel?.name
              ..['skillid'] = data.skillid
              ..['levelid'] = data.levelid
              ..['skillAuthid'] = data.id
              ..['skillName'] = data.skillName)
        ?.then((res) {
      if (res) onRefresh();
    });
  }

  void addGame() {
    Get.to(() => AddGamePage({}))?.then((res) {
      flog('res$res');
      if (res != null) onRefresh();
    });
  }
}
