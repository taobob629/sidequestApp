import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../model/integral_model.dart';
import '../../../../../utils/toast_utils.dart';

class IntegralInterestsCtr extends GetxController {
  final ScrollController scrollController = ScrollController();

  var currentVIPIndex = 0.obs;
  var integralModel = IntegralModel(levelConfigVoList: []).obs;
  var levelCoupons = <LevelCoupon>[].obs;
  var contentList = <dynamic>[].obs;
  // true显示，false隐藏
  var showOrHideCoupon = false.obs;

  @override
  void onInit() {
    super.onInit();

    currentVIPIndex.value = (Get.arguments ?? 1) - 1;
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
            .value.levelConfigVoList[currentVIPIndex.value].levelCoupons ==
        null) {
      levelCoupons.clear();
      return;
    }
    List<dynamic> decodedJson = jsonDecode(integralModel
        .value.levelConfigVoList[currentVIPIndex.value].levelCoupons!);
    final result =
        decodedJson.map((json) => LevelCoupon.fromJson(json)).toList();
    levelCoupons.assignAll(result);
  }

  List<LevelCoupon> getContentCoupons(String? coupons) {
    if (coupons == null) return [];
    List<dynamic> decodedJson = jsonDecode(coupons);
    final result =
        decodedJson.map((json) => LevelCoupon.fromJson(json)).toList();
    return result;
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

  void redeemCoupon(int id) async {
    showLoading();
    final result = await http.post('/app/point/add/coupon', data: {
      "level":
          integralModel.value.levelConfigVoList[currentVIPIndex.value].level,
      "couponId": id,
    });
    dismissLoading();
    if (result.data) {
      showToast("Redeem Successful".tr);
    }
    requestData();
  }
}
