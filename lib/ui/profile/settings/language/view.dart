/**
    author:mac
    创建日期:2023/2/27
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/config/lang/translations.dart';
import 'package:wy/ui/profile/settings/language/controller.dart';
import 'package:wy/utils/image_util.dart';

class LanguagePage extends GetView<LanguagePageController> {
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
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontFamily: FONT_MEDIUM),
                ),
                // subtitle: Text(
                //   '${getSubtitle(local.languageCode)}',
                //   style: TextStyle(
                //       color: AppColor.textSubtitle, fontSize: 13.sp, fontFamily: FONT_MEDIUM),
                // ),
                trailing: Obx(() => ImageUtil.assetImage(
                    '${controller.curLan == local ? 'rg_select' : 'rg_unselect'}',
                    imageType: IMG_PNG)),
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
