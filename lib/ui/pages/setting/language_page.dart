/**
    author:mac
    创建日期:2023/2/27
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../config/lang/translations.dart';
import '../../../utils/storage_manager.dart';

class LanguagePage extends StatelessWidget {

  final controller = Get.put(LanguagePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'.tr),
      ),
      body: ListView(
        children: languages
            .map(
              (local) => ListTile(
                onTap: () => controller.updateLanguage(local),
                title: Text(
                  getTitle(local.languageCode),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                subtitle: Text(
                  getSubtitle(local.languageCode),
                  style: TextStyle(
                      color: AppColor.textSubtitle,
                      fontSize: 13.sp,
                      fontFamily: FONT_MEDIUM),
                ),
                trailing: Obx(() => controller.curLan == local
                    ? Image.asset(
                        "assets/images/rg_select.png",
                        width: 27,
                        height: 27,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "assets/images/rg_unselect.png",
                        width: 27,
                        height: 27,
                        fit: BoxFit.contain,
                      )),
              ),
            )
            .toList(),
      ),
    );
  }

  String getTitle(String code) {
    switch (code) {
      case 'zh':
        return '中文';
      case 'en':
      default:
        return 'English';
    }
  }

  String getSubtitle(String code) {
    switch (code) {
      case 'zh':
        return '中国人';
      case 'en':
      default:
        return 'English';
    }
  }
}

class LanguagePageController extends GetxController {
  Rxn<Locale> _curLan = Rxn();

  Locale? get curLan => _curLan.value;

  set curLan(Locale? value) {
    _curLan.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    curLan = Get.locale ?? ENGLISH;
  }

  void updateLanguage(Locale local) {
    if (local.languageCode == Get.locale?.languageCode) {
      Get.back();
    }
    StorageManager.setLocal(local.languageCode);
    Get.updateLocale(local);
    Get.back();
  }
}
