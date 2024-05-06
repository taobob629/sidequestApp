import 'package:get/get.dart';

import '../../../api/wy_http.dart';
import '../../../common/web_page.dart';
import '../../../controller/user_controller.dart';
import '../../../model/game_account_model.dart';
import '../../../utils/toast_utils.dart';
import '../../dialog/dialog_confirm.dart';

class AddGameAccountCtr extends GetxController {
  var list = <GameAccountModel>[].obs;
  var selectIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();

    requestData();
  }

  void requestData() async {
    showLoading();
    final response = await http.get('/peiwan/app/new/home/lol/user/list');
    // final response = await http.get('/peiwan/app/profile/connections/list');
    dismissLoading();
    if (response.data != null) {
      list.assignAll(response.data
          .map<GameAccountModel>((item) => GameAccountModel.fromJson(item))
          .toList());
    }
  }

  void jumpWeb() async {
    final result = await Get.to(
      () => WebPage(
        title: 'Login Roit'.tr,
        url:
            'https://auth.riotgames.com/authorize?client_id=7699637b-cdd5-4a7d-b992-e78eb40ca15b&redirect_uri=https://sidequesthub.com/proxy/web/extra/appRoitLogin&response_type=code&scope=openid+offline_access+cpid&state=${UserController.find.userProfile.uk}',
      ),
    );
    dismissLoading();
    if (result != null) {
      showToast('登录成功');
      requestData();
    }
  }

  void deleteAccount(int? id) async {
    Get.dialog(
      ConfirmDialog(
        title: "Confirm Delete",
        info: "Are you sure to delete this account?",
        onConfirm: () async {
          showLoading();
          final response =
              await http.get('/peiwan/app/profile/connections/delete?id=$id');
          dismissLoading();
          Get.back();
          requestData();
        },
      ),
    );
  }

  void selectAccount(int i) async {
    selectIndex.value = i;
    Get.back(result: true);
  }
}
