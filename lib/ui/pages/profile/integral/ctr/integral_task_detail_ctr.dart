import 'dart:convert';

import 'package:get/get.dart';
import 'package:sq_hub_app/utils/utils.dart';

import '../../../../../api/wy_http.dart';
import '../../../../../model/integral_goods_detail_model.dart';
import '../../../../../model/integral_task_detail_model.dart';
import '../../../../../utils/toast_utils.dart';

class IntegralTaskDetailCtr extends GetxController {

  var model = IntegralTaskDetailModel(taskDetailList: []).obs;
  int? id;

  @override
  void onInit() {
    super.onInit();

    id = Get.arguments;
    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/app/point/task/info', queryParameters: {
      "id": id,
    });
    dismissLoading();
    model.value = IntegralTaskDetailModel.fromJson(response.data);
  }
}
