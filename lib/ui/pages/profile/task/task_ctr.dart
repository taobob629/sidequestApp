import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/getx_refresh_controller.dart';

import '../../../../api/wy_http.dart';
import '../../../../model/task_model.dart';
import '../../../../utils/toast_utils.dart';

class TaskCtr extends GetxRefreshController<TaskModel>
    with GetSingleTickerProviderStateMixin {

  var ifScaleBig1 = true.obs;

  TaskOutModel? outModel;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<List<TaskModel>> loadData({int pageNum = 1}) async {
    showLoading();
    List<TaskModel> list = [];

    int type = ifScaleBig1.value ? 0 : 1;
    var response = await http.get(
      '/sideQuest/app/sq/user/questTask',
      queryParameters: {
        'type': type
      }
    );
    dismissLoading(status: SmartStatus.loading);

    if (response.data == null) {
      return list;
    }
    outModel = TaskOutModel.fromJson(response.data);
    list = outModel?.tasks ?? [];

    return list;
  }
}
