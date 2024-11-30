import 'package:get/get.dart';
import 'package:sq_hub_app/api/order_api.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../../../common/base_controller.dart';
import '../../../../model/order_detail_new_model.dart';

class OrderDetailCtr extends BasePageController {

  var model = OrderDetailNewModel(items: [], reward: 0).obs;

  @override
  void onInit() {
    super.onInit();

    pageState = PageState.initialing;
    requestData();
  }

  void requestData() async {
    showLoading();
    model.value = await OrderApi.orderDetailNew(Get.arguments);
    dismissLoading();
    pageState = PageState.sucess;
  }
}