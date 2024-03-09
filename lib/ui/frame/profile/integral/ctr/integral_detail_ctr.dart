import 'dart:convert';

import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../../model/integral_goods_detail_model.dart';

class IntegralDetailCtr extends GetxController {

  var integralGoodsDetailModel = IntegralGoodsDetailModel(coupons: []).obs;
  int? id;

  @override
  void onInit() {
    super.onInit();

    id = Get.arguments;
    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/web/app/integral/goodDetail', queryParameters: {
      "goodId": id,
    });
    integralGoodsDetailModel.value = IntegralGoodsDetailModel.fromJson(response.data);
    dismissLoading();
  }

  void confirm() async {
    showLoading();
    final response = await http.get('/web/app/integral/redeemGood', queryParameters: {
      "goodId": id,
    });
    dismissLoading();
    Get.back();
    if (response.data != null && response.data['code'] != 200) {
      return;
    }
    showToast("Successful");
    Get.back();
  }
}
