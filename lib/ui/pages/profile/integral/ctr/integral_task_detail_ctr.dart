import 'package:get/get.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../model/integral_task_detail_model.dart';
import '../../../../../utils/toast_utils.dart';

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
