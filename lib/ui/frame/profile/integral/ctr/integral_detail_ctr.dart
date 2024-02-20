import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../../model/beans/order_status_bean.dart';
import '../../../../../model/integral_checkin_model.dart';
import '../../../../../model/integral_task_model.dart';

class IntegralDetailCtr extends GetxController {

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final responseList = await http.get('/sidekick/integral/queryIntegralDetailList');
    dismissLoading();
  }
}
