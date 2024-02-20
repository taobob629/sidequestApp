import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../../model/beans/order_status_bean.dart';
import '../../../../../model/integral_checkin_model.dart';
import '../../../../../model/integral_task_model.dart';

class IntegralHomeCtr extends GetxController {
  var checkInList = <IntegralCheckInModel>[].obs;
  var integralTaskModel = IntegralTaskModel().obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final responseList = await Future.wait([
      http.get('/sidekick/integral/queryCheckInList'),
      http.get('/sidekick/integral/queryIntegralTaskList'),
    ]);

    dismissLoading();
    checkInList.value = responseList[0].data
        .map<IntegralCheckInModel>(
            (item) => IntegralCheckInModel.fromJson(item))
        .toList();
    integralTaskModel.value = IntegralTaskModel.fromJson(responseList[1].data);
  }

  void checkIn() async {
    showLoading();
    final response = await http.post('/sidekick/integral/addCheckIn');
    dismissLoading();
    if (response.data['code'] == 200) {
      showToast(response.data['msg']);
    }
  }
}
