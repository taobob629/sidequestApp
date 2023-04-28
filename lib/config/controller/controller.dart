/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initEasyLoadding();
  }

  initEasyLoadding() {
    // 全局配置SmartDialog的参数
    SmartDialog.config.toast = SmartConfigToast(alignment: Alignment.center);
    SmartDialog.config.loading = SmartConfigLoading(clickMaskDismiss: true);
  }
}
