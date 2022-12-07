/*
  strip_middleware
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:get/get.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';

class LoginMiddleWare extends GetMiddleware {
  final UserController userController = Get.find<UserController>();

  LoginMiddleWare();

  @override
  int? priority = 0;

  @override
  void onPageDispose() {}

  @override
  GetPage? onPageCalled(GetPage? page) {
    flog('onPageCalled');
    var account = StorageManager.getToken();
    flog('onPageCalled $account');
    if (account.isEmpty) {
      return GetPage(name: AppPages.Login, page: () => LoginPage());
    }
    return page;
  }
}
