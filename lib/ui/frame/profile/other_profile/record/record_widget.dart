/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/profile/other_profile/other_profile_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/views.dart';

class RecordWidget extends GetView<OtherProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 158,
        height: 26,
        margin: EdgeInsets.only(left: 20, bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: LinearGradient(colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)]),
            boxShadow: [BoxShadow(blurRadius: 8, spreadRadius: 0.5, offset: Offset(0, 3.5))]),
        child: Obx(() => playWidget()),
      ),
      onTap: () {
        controller.play();
        // Get.toNamed(AppPages.Record);
      },
    );
  }

  playWidget() {
    flog('playWidget---');
    switch (controller.playState) {
      case PlayState.loadding:
        return Lottie.asset(
          'assets/anim/loadding.json',
          width: 158.w,
          height: 14.h,
          fit: BoxFit.contain,
        );
      case PlayState.playing:
        return Lottie.asset(
          'assets/anim/voice_record.json',
          // width: 158.w,
          height: 14.h,
          fit: BoxFit.contain,
        );
      case PlayState.idle:
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ImageUtil.assetImage('profile/icon_voice_record', height: 14),
            ImageUtil.assetImage('profile/icon_voice', height: 14),
          ],
        );
    }
  }
}
