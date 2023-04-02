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
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/other_profile/other_profile_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/icon_text.dart';
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
        // controller.play();
      },
    );
  }

  UserController userController = UserController.find;

  playWidget() {
    var user = controller.player.value?.uid;
    var loginUser = userController.userProfile?.value?.pwId;
    var voice = controller.player.value.voice;
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
        //判断是不是本人
        if (voice.isEmpty) {
          if (user != loginUser) {
            return Center(
              child: Text(
                'No Voice'.tr,
                style: TextStyle(fontSize: 12.sp),
              ),
            );
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => controller.play(),
              child: ImageUtil.assetImage('profile/icon_voice_record', height: 14),
            ),
            GestureDetector(
              onTap: () => controller.play(),
              child: ImageUtil.assetImage('profile/icon_voice', height: 14),
            ),
            if (user == loginUser)
              GestureDetector(
                onTap: () => controller.toRecordPage(),
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: ImageUtil.assetImage('ic_edit', width: 14),
                ),
              )
          ],
        );
    }
  }
}
