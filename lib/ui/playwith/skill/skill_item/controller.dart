import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/model/skill_config_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';

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
  var id;

  SkillItemConfigModel? get skillModel => _skillModel?.value;

  set skillModel(SkillItemConfigModel? value) {
    _skillModel?.value = value;
  }

  RxBool _status = RxBool(true);

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
    id = Get.arguments['id']; //id不为空表示是编辑
  }

  initData() async {
    if (id == null) {
      skillModel = await UserApi.skillItemConfig(Get.arguments['skillAuthid']);
    } else {
      skillModel = await UserApi.skillItemDetail(id);
    }
    price = skillModel?.price ?? 0;
    status = skillModel?.enabled == 1 ? true : false;
    teContent.text = skillModel?.name ?? '';
  }

  @override
  void onClose() {
    teContent.dispose();
    super.onClose();
  }

  addGame() async {
    var name = teContent.text;
    if (name.isEmpty) {
      EasyLoading.showToast('please input'.tr);
      return;
    }
    if (price == 0) {
      EasyLoading.showToast('Please enter the price'.tr);
      return;
    }
    double priceRangeMax = skillModel?.priceRangeMax ?? 0;
    double priceRangeMin = skillModel?.priceRangeMin ?? 0;
    if (price < priceRangeMin || price > priceRangeMax) {
      EasyLoading.showError('the service price not in the price range');
      return;
    }
    EasyLoading.show();
    var response = await UserApi.addSkillItem(Map<String, dynamic>()
      ..['name'] = name
      ..['skillId'] = Get.arguments['skillid']
      ..['id'] = id
      ..['skillName'] = Get.arguments['skillName']
      ..['price'] = price
      ..['levelId'] = Get.arguments['levelid']
      ..['skillAuthid'] = Get.arguments['skillAuthid']
      ..['enabled'] = status ? 1 : 0);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      Get.back(result: true);
    }
  }

  delete() {
    Get.dialog(
        ConfirmDialog(
          title: "Confirm".tr,
          info: "Are you sure to delete this?".tr,
          onConfirm: () async {
            EasyLoading.show();
            await UserApi.deleteSkillItem(id);
            EasyLoading.dismiss();
            Get.back();
            Get.back(result: true);

          },
          concelBtn: 'CANCEL'.tr,
        ),
        barrierColor: Colors.black26);
  }
}
