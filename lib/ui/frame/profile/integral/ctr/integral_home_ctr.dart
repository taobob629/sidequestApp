import 'package:get/get.dart';
import 'package:wy/api/wy_http.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../../model/integral_checkin_model.dart';
import '../../../../../model/integral_goods_model.dart';
import '../../../../../model/integral_task_model.dart';

class IntegralHomeCtr extends GetxController {
  var integralCheckInModel = IntegralCheckInModel(
    checkList: [],
    nexIntegralNumber: 0,
    integralTotal: 0,
    lv: 1,
  ).obs;
  var integralTaskModel = IntegralTaskModel().obs;
  var goods = [].obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final responseList = await Future.wait([
      http.get('/web/app/integral/queryCheckInList'),
      http.get('/web/app/integral/queryIntegralTaskList'),
      http.get('/web/app/integral/pointGoods'),
    ]);

    dismissLoading();
    integralCheckInModel.value =
        IntegralCheckInModel.fromJson(responseList[0].data);
    integralTaskModel.value = IntegralTaskModel.fromJson(responseList[1].data);
    Map<String, dynamic> goodsMap = responseList[2].data;
    final list = goodsMap.values.toList();
    if (list.isNotEmpty) {
      goods.value = list[0];
    }
  }

  void checkIn() async {
    showLoading();
    final response = await http.post('/web/app/integral/addCheckIn');
    dismissLoading();
    if (response.data['code'] == 200) {
      showToast(response.data['msg']);
    }
  }
}
