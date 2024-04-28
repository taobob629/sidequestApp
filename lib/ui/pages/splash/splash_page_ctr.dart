import 'package:get/get.dart';

import '../../../utils/storage_manager.dart';
import '../login/login_page.dart';
import '../register/register_page.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */
class SplashPageController extends GetxController {
  @override
  void onInit() {
    StorageManager.setFirstUse(false);
    super.onInit();
  }

  toLogin() {
    Get.offAll(() => LoginPage());
  }
}
