/**
    author:mac
    创建日期:2023/4/5
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../../../config/icon_font.dart';
import '../../../../../../controller/user_controller.dart';
import '../../../../../../res/dimens.dart';
import '../../../../../../service/voice_player.dart';
import '../../../../../../widget/voice_widget.dart';
import '../controller.dart';

class RecordHeaderWidget extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.recordFileUrl.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(ImageUtils.app_logo, width: 42.w, height: 42.w),
              Dimens.dVerticalNomarl,
              Text(
                'Introduce yourself in one'.tr + '\n' + 'sentence!'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 16.sp),
              )
            ],
          )
        : VoiceWidget(
            width: 210.w,
            needEdit: false,
            play: () => AudioManager.instance.play(controller.recordFileUrl),
            pwId: UserController.find.userProfile.pwId,
            voice: controller.recordFileUrl));
  }
}
