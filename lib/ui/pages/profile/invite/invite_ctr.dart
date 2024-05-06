import 'package:get/get.dart';

import '../../../../api/wy_http.dart';
import '../../../../model/invite_model.dart';
import '../../../../utils/toast_utils.dart';

class InviteCtr extends GetxController {
  String? title;

  var model = InviteModel().obs;

  @override
  void onInit() {
    super.onInit();

    title = Get.arguments as String?;

    requestData();
  }

  void requestData() async {
    showLoading();
    var response = await http.get('/app/client/task/userInvent');
    dismissLoading();

    model.value = InviteModel.fromJson(response.data);
  }
}
