import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/model/game_service_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/sidekick/tabs/tab_sidekick/controller.dart';
import 'package:wy/utils/utils.dart';

import '../../utils/toast_utils.dart';

/*
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class MoreGamesPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  UserController userController = Get.find<UserController>();
  RxList<GameServiceModel> _services = RxList();

  List<GameServiceModel> get services => _services.value;

  set services(List<GameServiceModel> value) {
    _services.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    flog('onInit.....');
    initData();
  }

  initData() async {
    var result = await IndexApi.getMoreGames(pwid: 0);
    _services.addAll(result);
    tabController =
        TabController(vsync: this, length: services.length, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  focus(GameInfo gameInfo) async {
    showLoading();
    var response = await IndexApi.focusGame(gameid: gameInfo.gameid);
    dismissLoading();
    showToast(response.statusMessage ?? '');
    if (response.statusCode == 200) {
      gameInfo.changeFocus();
    }
    Get.find<TabSideKickController>().initMyGames();
  }
}
