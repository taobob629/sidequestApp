import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/link_preview/common/utils.dart';

import '../../api/wy_http.dart';
import '../../model/game_account_model.dart';
import '../../utils/toast_utils.dart';

class AddGameAccountCtr extends GetxController {

  var gameAccountModel = GameAccountModel().obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/peiwan/app/profile/connections/list');
    dismissLoading();
    if (response.data != null) {
      gameAccountModel.value = GameAccountModel.fromJson(response.data);
    }
  }

  void jumpWeb() async {
    LinkUtils.launchURL(Get.context!, gameAccountModel.value.riot?.url ?? '');
  }

  void deleteAccount(int id) async {
    showLoading();
    final response = await http.get('/peiwan/app/profile/connections/delete?id=$id');
    dismissLoading();
  }
}
