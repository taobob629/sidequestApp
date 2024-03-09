import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../../model/beans/order_status_bean.dart';
import '../../../../../model/integral_checkin_model.dart';
import '../../../../../model/integral_task_detail_model.dart';
import '../../../../../model/integral_task_model.dart';

class IntegralTaskDetailCtr extends GetxController {

  var integralTaskDetailModel = IntegralTaskDetailModel().obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final response =
        await http.get('/web/app/integral/getInfo', queryParameters: {
      'id': Get.arguments,
    });
    integralTaskDetailModel.value = IntegralTaskDetailModel.fromJson(response.data);
    dismissLoading();
  }
}
