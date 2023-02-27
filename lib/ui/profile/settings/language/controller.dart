import 'dart:ui';

import 'package:get/get.dart';
import 'package:wy/config/lang/translations.dart';
import 'package:wy/utils/index.dart';

/**
    author:mac
    创建日期:2023/2/27
    描述:
 */
class LanguagePageController extends GetxController {
  Rxn<Locale> _curLan = Rxn();

  Locale? get curLan => _curLan.value;

  set curLan(Locale? value) {
    _curLan.value = value;
  }
@override
  void onInit() {
    super.onInit();
    curLan=Get.locale??ENGLISH;
  }
  void updateLanguage(Locale local) {
    if (local.languageCode == Get.locale?.languageCode) {
      Get.back();
    }
    StorageManager.setLocal(local?.languageCode);
    Get.updateLocale(local);
    Get.back();
  }
}
