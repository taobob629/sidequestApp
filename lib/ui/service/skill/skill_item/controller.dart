import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/model/skill_config_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';

import '../../../../model/booking_model.dart';
import '../../../../utils/toast_utils.dart';

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

  var promotionSwitch = true.obs;

  List<BookingSelectModel> promotionList = [];
  var currentPromotion = BookingSelectModel().obs;

  List<BookingSelectModel> discountList = [];
  var currentDiscount = BookingSelectModel().obs;

  List<BookingSelectModel> orderFreeList = [];
  var currentOrderFree = BookingSelectModel().obs;

  List<BookingSelectModel> xAndYList = [];
  var currentBuyX = BookingSelectModel().obs;
  var currentGetY = BookingSelectModel().obs;

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

    if (skillModel?.discount != null) {
      if (jsonDecode(skillModel!.discount!)['enable'] == 1) {
        promotionSwitch.value = true;
      } else {
        promotionSwitch.value = false;
      }
    } else {
      promotionSwitch.value = false;
    }

    BookingSelectModel model = BookingSelectModel();
    model.id = 0;
    model.name = "Discount";
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "1st Order Free";
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "Buy X Get Y Free";
    promotionList.add(model);
    currentPromotion.value = promotionList[0];

    model = BookingSelectModel();
    model.id = 0;
    model.name = "5% Off";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "10% Off";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "15% Off";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 3;
    model.name = "20% Off";
    discountList.add(model);
    currentDiscount.value = discountList[0];

    model = BookingSelectModel();
    model.id = 0;
    model.name = "30% Off";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "50% Off";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "80% Off";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 3;
    model.name = "100% Off";
    orderFreeList.add(model);
    currentOrderFree.value = orderFreeList[0];

    for (int i = 1; i <= 10; i++) {
      model = BookingSelectModel();
      model.id = i;
      model.name = "$i";
      xAndYList.add(model);
    }

    currentBuyX.value = currentGetY.value = xAndYList[0];
  }

  @override
  void onClose() {
    teContent.dispose();
    super.onClose();
  }

  addGame() async {
    var name = teContent.text;
    if (name.isEmpty) {
      showToast('please input'.tr);
      return;
    }
    if (price == 0) {
      showToast('Please enter the price'.tr);
      return;
    }
    double priceRangeMax = skillModel?.priceRangeMax ?? 0;
    double priceRangeMin = skillModel?.priceRangeMin ?? 0;
    if (price < priceRangeMin || price > priceRangeMax) {
      showError('the service price not in the price range');
      return;
    }

    Map discount = {};
    if (currentPromotion.value.id == 0) {
      // Discount
      discount = {
        'type': 1,
        'discount': currentDiscount.value.name.split('%')[0],
        'enable': promotionSwitch.value ? 1 : 0,
      };
    } else if (currentPromotion.value.id == 1) {
      // 1st OrderFree
      discount = {
        'type': 3,
        'discount': currentOrderFree.value.name.split('%')[0],
        'enable': promotionSwitch.value ? 1 : 0,
      };
    } else if (currentPromotion.value.id == 2) {
      // Buy X Get Y
      discount = {
        'type': 2,
        'buy': currentBuyX.value.name,
        'get': currentGetY.value.name,
        'enable': 1,
      };
    }

    showLoading();
    var response = await UserApi.addSkillItem(Map<String, dynamic>()
      ..['name'] = name
      ..['skillId'] = Get.arguments['skillid']
      ..['id'] = id
      ..['skillName'] = Get.arguments['skillName']
      ..['price'] = price
      ..['discount'] = json.encode(discount)
      ..['unit'] = Get.arguments['unit']
      ..['levelId'] = Get.arguments['levelid']
      ..['skillAuthid'] = Get.arguments['skillAuthid']
      ..['enabled'] = status ? 1 : 0);
    dismissLoading();
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
            showLoading();
            await UserApi.deleteSkillItem(id);
            dismissLoading();
            Get.back();
            Get.back(result: true);
          },
          concelBtn: 'CANCEL'.tr,
        ),
        barrierColor: Colors.black26);
  }
}
