import 'package:get/get.dart';
import 'package:wy/utils/toast_utils.dart';

import '../../../../api/wy_http.dart';
import '../../../../model/task_detail_model.dart';
import '../../../../model/task_model.dart';

class TaskDetailCtr extends GetxController {
  TaskDetailModel? model;
  late TaskModel taskModel;
  late bool skipFlag;

  @override
  void onInit() {
    super.onInit();

    Map map = Get.arguments as Map;
    taskModel = map['model'];
    skipFlag = map['skipFlag'];

    _requestData(true);
  }

  void _requestData(bool ifShowLoading) async {
    if (ifShowLoading) {
      showLoading();
    }
    ;
    var response = await http.get(
      '/app/client/task/taskDetail?id=${taskModel.id}&type=${taskModel.type}',
    );
    model = TaskDetailModel.fromJson(response.data);
    update();
    dismissLoading();
  }

  void receive(int drawId) async {
    showLoading();
    await http.get(
      '/app/client/task/draw?id=$drawId',
    );
    _requestData(false);
  }

  bool ifShowExpired(int draw, int state) {
    if (draw == 0) {
      if (state>0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
