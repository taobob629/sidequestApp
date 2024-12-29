import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../model/integral_model.dart';
import '../../../../../utils/toast_utils.dart';

class IntegralInterestsCtr extends GetxController {
  final ScrollController scrollController = ScrollController();

  var currentVIPIndex = 0.obs;
  int currentUserVipLevel = 0;

  var integralModel = IntegralModel(levelConfigVoList: []).obs;
  var levelCoupons = <CouponsModel>[].obs;
  var contentList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();

    currentUserVipLevel = Get.arguments ?? 0;
    currentVIPIndex.value = currentUserVipLevel > 0 ? currentUserVipLevel - 1 : currentUserVipLevel;
    requestData();
  }

  void requestData() async {
    showLoading();
    final result = await http.get('/app/point/level/config');
    dismissLoading();
    integralModel.value = IntegralModel.fromJson(result.data);
    getCoupons();
    getContentList();
  }

  void getCoupons() {
    if (integralModel.value.levelConfigVoList.isEmpty) {
      levelCoupons.clear();
      return;
    }
    if (integralModel
        .value.levelConfigVoList[currentVIPIndex.value].coupons.isEmpty) {
      levelCoupons.clear();
      return;
    }
    levelCoupons.assignAll(
        integralModel.value.levelConfigVoList[currentVIPIndex.value].coupons);
  }

  void getContentList() {
    if (integralModel.value.levelConfigVoList.isEmpty) {
      contentList.clear();
      return;
    }
    if (integralModel.value.levelConfigVoList[currentVIPIndex.value].content ==
        null) {
      contentList.clear();
      return;
    }
    List<dynamic> decodedJson = jsonDecode(
        integralModel.value.levelConfigVoList[currentVIPIndex.value].content!);
    contentList.assignAll(decodedJson);
  }

  void changeIndex(int index) {
    currentVIPIndex.value = index;
    getCoupons();
    getContentList();
  }

  void redeemCoupon(CouponsModel model) async {
    if (model.state == 0) {
      showLoading();
      final result = await http.post('/app/point/add/coupon', data: {
        "level":
            integralModel.value.levelConfigVoList[currentVIPIndex.value].level,
        "couponId": model.id,
        "num": model.num,
        "couponCode": model.code,
      });
      dismissLoading();
      if (result.data) {
        showToast("Redeem Successful".tr);
      }
      requestData();
    }
  }
}
