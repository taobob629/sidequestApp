/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:get/get.dart';

import '../../../../common/base_tab_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../utils/storage_manager.dart';
import '../login/login_page.dart';

class SocialTabController extends GetxController {
  List<String> tabs = ['Social Feed'.tr, 'Messages'.tr];
  var selectTopTabIndex = 0.obs;

  void clickTopTab(int i) {
    if (i == 1) {
      var account = StorageManager.getToken();
      if (account.isEmpty) {
        Get.to(() => LoginPage());
      } else {
        selectTopTabIndex.value = i;
      }
      return;
    }
    selectTopTabIndex.value = i;
  }
}
