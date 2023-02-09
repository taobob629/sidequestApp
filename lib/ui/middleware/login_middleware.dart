/*
  strip_middleware
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/ui/splash/bindings.dart';
import 'package:wy/ui/splash/view.dart';
import 'package:wy/utils/storage_manager.dart';

class LoginMiddleWare extends GetMiddleware {
  final UserController userController = Get.find<UserController>();

  LoginMiddleWare();

  @override
  int? priority = 0;

  @override
  void onPageDispose() {}

  @override
  GetPage? onPageCalled(GetPage? page) {
    var firstUse = StorageManager.getFirstUse();
    if (firstUse) {
      return GetPage(name: AppPages.SPLASH, page: () => SplashPage(), binding: SplashPageBinding());
    }
    var account = StorageManager.getToken();
    if (account.isEmpty) {
      return GetPage(name: AppPages.Login, page: () => LoginPage());
    }
    return page;
  }
}
