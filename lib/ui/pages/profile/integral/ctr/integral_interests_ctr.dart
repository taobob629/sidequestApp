import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../model/integral_coupon_model.dart';
import '../../../../../model/integral_lv_model.dart';
import '../../../../../utils/toast_utils.dart';

class IntegralInterestsCtr extends GetxController {
  final ScrollController scrollController = ScrollController();

  var currentVIPIndex = 0.obs;
  var integralCouponModel = IntegralCouponModel(
      couponList: [], presentGrade: PresentGrade(couponList: [])).obs;
  var integralLvList = <IntegralLvModel>[].obs;

  void changeIndex(int index) {
    currentVIPIndex.value = index;
    double itemOffset = index * 80.w;

    // Scroll to the calculated offset with smooth animation
    scrollController.animateTo(
      itemOffset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onInit() {
    super.onInit();

    currentVIPIndex.value = (Get.arguments ?? 1) - 1;
    requestData();
  }

  void requestData() async {
    showLoading();
    final responseList = await Future.wait([
      http.get('/web/app/integral/queryAppGradeCouponList'),
      http.get('/web/app/integral/type/integral_grade',
          queryParameters: {'dictType': 'integral_grade'}),
    ]);
    dismissLoading();
    integralCouponModel.value =
        IntegralCouponModel.fromJson(responseList[0].data);
    integralLvList.value = responseList[1]
        .data
        .map<IntegralLvModel>((item) => IntegralLvModel.fromJson(item))
        .toList();
  }
}
