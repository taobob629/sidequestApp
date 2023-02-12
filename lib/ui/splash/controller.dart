import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/login_model.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */
class SplashPageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  toLogin() {
    Get.toNamed(AppPages.CHOOSE_GAME);
   // Get.toNamed(AppPages.Login);
  }

  toRegister() {
    Get.toNamed(AppPages.REGISTER,
        arguments: Map()
          ..['type'] = 1
          ..['loginModel'] = LoginModel());
  }
}
