/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:wy/api/index_api.dart';
import 'package:wy/config/lang/translations.dart';
import 'package:wy/firebase_options.dart';
import 'package:wy/utils/index.dart';

class AppController extends GetxController {

  static AppController get find => Get.find();

  @override
  void onInit() {
    super.onInit();
    Get.updateLocale(Get.locale ?? ENGLISH);
    initEasyLoadding();
    initIm();
    initConfig();
  }

  initEasyLoadding() {
    // 全局配置SmartDialog的参数
    SmartDialog.config.toast = SmartConfigToast(alignment: Alignment.center);
    SmartDialog.config.loading = SmartConfigLoading(clickMaskDismiss: true);
  }

  initIm() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.instance.getToken().then((value) => StorageManager.setPushToken(value));
  }

  bool showGoogleSingIn = false;
  String showGoogleSignInId = 'showGoogleSignInId';

  initConfig() {
    IndexApi.checkVersion().then((res) {
      flog('googleLogin ${res.googleLogin}');
      showGoogleSingIn = res.googleLogin;
      update([showGoogleSignInId]);
    });
  }
}
