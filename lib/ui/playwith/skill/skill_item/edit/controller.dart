import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/skill_config_model.dart';
import 'package:wy/model/skill_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';

/*
    controller
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class SkillItemAddPageController extends BasePageController {
  TextEditingController teContent = TextEditingController();
  RxList<PriceRangeModel> priceRanges = RxList([]); //我选择的技能列表
  var gameId;
  var levelId;
  SkillModel? model;
  RxDouble _price = RxDouble(0);

  double get price => _price.value;

  set price(double value) {
    _price.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    initParams();
    initData();
  }

  void initParams() {
    gameId = Get.arguments['gameId'];
    levelId = Get.arguments['levelId'];
    model = Get.arguments['service'];
  }

  initData() async {
    var result = await GamesApi.getPriceRange(gameId, levelId: levelId, addServiceItem: true);
    priceRanges.clear();
    priceRanges.addAll(result?.priceRange ?? []);
    if (priceRanges.isEmpty) {
      EasyLoading.showToast('Can\'nt Add More Types'.tr);
      Get.back();
      return;
    }
    price = priceRanges.first.gameCoinMin;
  }

  onConfirm() async {
    if (teContent.text.isEmpty) {
      toast('Please Input a name'.tr);
      return;
    }
    EasyLoading.show();
    var response = await UserApi.addSkillItem(Map<String, dynamic>()
      ..['name'] = teContent.text
      ..['skillId'] = model?.skillid
      ..['skillAuthid']=model?.id
      ..['id'] = null
      ..['skillName'] = model?.skillName
      ..['price'] = price
      ..['levelId'] = model?.levelid
      ..['enabled'] = 1);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      Get.back(result: true);
    }
  }

  @override
  void onClose() {
    teContent.dispose();
    super.onClose();
  }
}
