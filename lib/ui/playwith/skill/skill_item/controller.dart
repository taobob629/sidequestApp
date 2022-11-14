import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/model/game_service_model.dart';
import 'package:wy/model/play_detail_model.dart';
import 'package:wy/model/skill_config_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/skill/skill_item/bindings.dart';
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
  Rxn<SkillItemConfigModel>? _skillModel = Rxn();

  SkillItemConfigModel? get skillModel => _skillModel?.value;

  set skillModel(SkillItemConfigModel? value) {
    _skillModel?.value = value;
  }

  RxBool _status = RxBool(false);

  bool get status => _status.value;

  set status(bool value) {
    _status.value = value;
  }

  double price = 0;

  @override
  void onInit() {
    super.onInit();
    initParams();
    initData();
  }
  void initParams() {
    teContent.text=Get.arguments['name']??'';
    price=Get.arguments['price']??0;
    status=Get.arguments['enabled']==1?true:false;
  }
  initData() async {
    skillModel = await UserApi.skillItemConfig(Get.arguments['skillid']);
  }

  @override
  void onClose() {
    teContent.dispose();
    super.onClose();
  }

  addGame() {
    var name = teContent.text;
    if(name.isEmpty){
      EasyLoading.showToast('please input'.tr);
      return;
    }
    if(price==0){
      EasyLoading.showToast('Please enter the price'.tr);
      return;
    }
    EasyLoading.show();
    UserApi.addSkillItem(Map<String, dynamic>()
      ..['name'] = name
      ..['skillid'] = Get.arguments['skillid']
      ..['id'] = Get.arguments['id']
      ..['skillName'] = Get.arguments['name']
      ..['price'] = price
      ..['enabled'] = status ? 1 : 0);
    Get.back(result: true);
    EasyLoading.dismiss();
  }


}
