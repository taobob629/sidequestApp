import 'package:get/get.dart';
import 'package:sq_hub_app/api/order_api.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../../../model/order_detail_new_model.dart';

class OrderDetailCtr extends GetxController {

  var model = OrderDetailNewModel(items: []).obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    model.value = await OrderApi.orderDetailNew(Get.arguments);
    dismissLoading();
  }
}