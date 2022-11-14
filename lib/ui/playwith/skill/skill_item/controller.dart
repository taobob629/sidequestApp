import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/model/game_service_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/utils.dart';

/*
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class SkillItemPageController extends GetxController {
  TextEditingController teContent = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    flog('onInit.....');
    initData();
  }

  initData() {}

  @override
  void onClose() {
    super.onClose();
  }

  addSkillItem(GameInfo gameInfo) async {
    EasyLoading.show();
    var response = await IndexApi.focusGame(gameid: gameInfo.gameid);
    EasyLoading.showToast(response.statusMessage ?? '');
    if (response.statusCode == 200) {
      gameInfo.changeFocus();
    }
    EasyLoading.dismiss();
  }
}
