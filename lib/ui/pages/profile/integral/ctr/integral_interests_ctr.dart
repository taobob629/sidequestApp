import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../model/integral_model.dart';
import '../../../../../utils/toast_utils.dart';
import '../../../../dialog/dialog_sign_success.dart';
import '../coupon_tip_dialog.dart';
import 'integral_home_ctr.dart';

class IntegralInterestsCtr extends GetxController {
  static IntegralInterestsCtr get find => Get.find();

  final ScrollController scrollController = ScrollController();

  var currentVIPIndex = 0.obs;
  int currentUserVipLevel = 0;

  var integralModel = IntegralModel(levelConfigVoList: []).obs;
  var levelCoupons = <CouponsModel>[].obs;
  var contentList = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    currentUserVipLevel = Get.arguments ?? 0;
    currentVIPIndex.value = 
        currentUserVipLevel > 0 ? currentUserVipLevel - 1 : currentUserVipLevel;
    requestData();
  }

  void requestData() async {
    try {
      // 优先使用IntegralHomeCtr中缓存的数据
      if (IntegralHomeCtr.cachedLevelConfigData != null) {
        integralModel.value = IntegralModel.fromJson(IntegralHomeCtr.cachedLevelConfigData);
        getCoupons();
        getContentList();
        return;
      }
      
      // 如果没有缓存数据，再请求网络
      // 不显示加载指示器，避免屏幕闪烁
      final result = await http.get('/app/point/level/config');
      integralModel.value = IntegralModel.fromJson(result.data);
      getCoupons();
      getContentList();
    } catch (e) {
      print('Error loading level config: $e');
    }
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
        showCustom(SignSuccessDialog(
          points: "${model.num} vouchers",
          congratulations: "Congratulations, you have got ",
          title: "Claim Successful".tr,
        ));
      }
      requestData();
    }
  }

  void showTipDialog(int i) async {
    showCustom(
      CouponTipDialog(
        isCal: contentList[i]['title']
            .toString()
            .toLowerCase()
            .contains("play with friends"),
        info: contentList[i],
        limitConnectionsCount: integralModel
                .value
                .levelConfigVoList[currentVIPIndex.value]
                .limitConnectionsCount ??
            0,
      ),
      alignment: contentList[i]['title']
              .toString()
              .toLowerCase()
              .contains("play with friends")
          ? Alignment.bottomCenter
          : Alignment.center,
    );
  }
}
