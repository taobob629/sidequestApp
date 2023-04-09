/**
    author:mac
    创建日期:2023/4/5
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/index.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/profile/other_profile/record/controller.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/profile/voice_widget.dart';

class RecordHeaderWidget extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.recordFileUrl.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageUtil.assetImage('app_logo', width: 42.w, height: 42.w),
              Dimens.dVerticalNomarl,
              Text(
                'Introduce yourself in one \nsentence!',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 16.sp),
              )
            ],
          )
        : VoiceWidget(
            width: 210.w,
            needEdit: false,
            play: ()=>AudioManager.instance.play(controller.recordFileUrl),
            pwId: UserController.find.userProfile.pwId,
            voice: controller.recordFileUrl));
  }
}
