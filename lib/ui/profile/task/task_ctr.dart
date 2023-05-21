import 'package:get/get.dart';

import '../../../api/wy_http.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../model/task_model.dart';

class TaskCtr extends GetxRefreshController<TaskModel>
    with GetSingleTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<List<TaskModel>> loadData({int pageNum = 1}) async {
    List<TaskModel> list = [];
    var response = await http.get(
      '/app/client/task/list',
    );

    if (response.data == null) {
      return list;
    }
    list = response.data
        .map<TaskModel>((item) => TaskModel.fromJson(item))
        .toList();

    return list;
  }
}
