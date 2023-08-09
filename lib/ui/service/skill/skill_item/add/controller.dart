import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/api/game_api.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/model/skill_model.dart';

import '../../../../../model/booking_model.dart';
import '../../../../../utils/toast_utils.dart';

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
  Rxn<PriceRangeModel?> _priceRange = Rxn();

  PriceRangeModel? get priceRange => _priceRange.value;

  set priceRange(PriceRangeModel? value) {
    _priceRange.value = value;
  }

  RxDouble _price = RxDouble(0);
  String unit = "";

  double get price => _price.value;

  set price(double value) {
    _price.value = value;
  }

  var promotionSwitch = false.obs;

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
    gameId = Get.arguments['gameId'];
    levelId = Get.arguments['levelId'];
    model = Get.arguments['service'];
  }

  initData() async {
    var result = await GamesApi.getPriceRange(gameId,
        levelId: levelId, addServiceItem: true);
    priceRanges.clear();
    priceRanges.addAll(result?.priceRange ?? []);
    if (priceRanges.isEmpty) {
      showToast('Can\'nt Add More Types'.tr);
      Get.back();
      return;
    }
    priceRange = priceRanges.first;
    price = priceRange?.gameCoinMin ?? 0;
    unit = priceRange?.unit ?? "";

    BookingSelectModel model = BookingSelectModel();
    model.id = 0;
    model.name = "Discount".tr;
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "1st Order Discount".tr;
    promotionList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "Buy X Get Y Free".tr;
    promotionList.add(model);
    currentPromotion.value = promotionList[0];

    model = BookingSelectModel();
    model.id = 0;
    model.name = "5% OFF";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "10% OFF";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 2;
    model.name = "15% OFF";
    discountList.add(model);
    model = BookingSelectModel();
    model.id = 3;
    model.name = "20% OFF";
    discountList.add(model);
    currentDiscount.value = discountList[0];

    model = BookingSelectModel();
    model.id = 0;
    model.name = "30% OFF";
    orderFreeList.add(model);
    model = BookingSelectModel();
    model.id = 1;
    model.name = "50% OFF";
    orderFreeList.add(model);
    // model = BookingSelectModel();
    // model.id = 2;
    // model.name = "80% OFF";
    // orderFreeList.add(model);
    // model = BookingSelectModel();
    // model.id = 3;
    // model.name = "100% Off";
    // orderFreeList.add(model);
    currentOrderFree.value = orderFreeList[0];

    for (int i = 1; i <= 10; i++) {
      model = BookingSelectModel();
      model.id = i;
      model.name = "$i";
      xAndYList.add(model);
    }

    currentBuyX.value = currentGetY.value = xAndYList[0];
  }

  onConfirm() async {
    if (teContent.text.isEmpty) {
      showToast('Please Input a name'.tr);
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
        'enable': promotionSwitch.value ? 1 : 0,
      };
    }

    showLoading();
    var response = await UserApi.addSkillItem(Map<String, dynamic>()
      ..['name'] = teContent.text
      ..['skillid'] = model?.skillid
      ..['unit'] = unit
      ..['skillAuthid'] = model?.id
      ..['id'] = null
      ..['skillName'] = model?.skillName
      ..['price'] = price
      ..['discount'] = json.encode(discount)
      ..['levelId'] = model?.levelid
      ..['enabled'] = 1);
    dismissLoading();
    if (response.statusCode == 200) {
      Get.back(result: true);
    }
  }

  onTypeChange(PriceRangeModel? item) {
    priceRange = item;
    price = priceRange?.gameCoinMin ?? 0;
    unit = item?.unit ?? '';
  }

  @override
  void onClose() {
    teContent.dispose();
    super.onClose();
  }
}
