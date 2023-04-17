/**
    author:mac
    创建日期:2023/4/17
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/index.dart';
import 'package:wy/service/voice_player.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/order/refound/view.dart';
import 'package:wy/ui/service/add/add_game_page.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/profile/voice_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/stadium_button.dart';
import 'package:wy/widget/tips_widget.dart';

import '../controller.dart';

class BioPage extends GetView<AddGamePageController> {
  var textStyle1 = TextStyle(fontFamily: FONT_LIGHT, fontSize: 12.sp);

  TextStyle text_style() => TextStyle(
      color: textColor, fontSize: 14.sp, fontFamily: FONT_LIGHT, overflow: TextOverflow.ellipsis);

  var textColor = Color(0xFFB2B9C9);

  @override
  Widget build(BuildContext context) => ScaffoldWidget(
      appBar: AppBar(
        title: Text('Bio'.tr),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   padding: EdgeInsets.only(bottom: 10).h,
            //   child: TipsWidegt(
            //     title: 'Bio'.tr,
            //     tips: '',
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(left: 20.w, right: 10.w),
              child: Column(
                children: [
                  InputView(
                    maxLength: 15,
                    decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
                    controller:controller.teServiceIntro,
                    label: 'Service Intro'.tr,
                    tips: 'Please input Service Intro'.tr,
                    margin: EdgeInsets.only(top: 2).h,
                    padding: EdgeInsets.only(bottom: 8.h),
                    height: 45.h,
                  ),
                  16.verticalSpace,
                  InputView(
                    maxLength: 15,
                    decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
                    controller: TextEditingController(),
                    label: 'Voice Recording'.tr,
                    tips: 'Please input Service Intro'.tr,
                    margin: EdgeInsets.only(top: 2).h,
                    padding: EdgeInsets.only(bottom: 8.h),
                    autoHeight: true,
                    customInput: Obx(() => controller.voiceUrl.isEmpty
                        ? InkWell(
                            onTap: () => controller.toRecordPage(context),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
                              padding: itemPaddingNormal,
                              height: 45.h,
                              child: Obx(() => Text(
                                    '${controller.voiceUrl.isEmpty ? '+ Add Voice' : '${controller.voiceUrl}'}'
                                        .tr,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 13.sp,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(minHeight: 45.h),
                            padding: EdgeInsets.only(left: 15, right: 15).w,
                            decoration: innerDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Voice',
                                  style: text_style(),
                                ),
                                Spacer(),
                                VoiceWidget(
                                  maginBottom: 0,
                                  pwId: UserController.find.userProfile.pwId,
                                  voice: controller.voiceUrl,
                                  play: () => AudioManager.instance.play(controller.voiceUrl),
                                  toRecordPage: () => UserController.find.toRecordPage(context),
                                )
                              ],
                            ),
                          )),
                  ),
                  16.verticalSpace,
                  Obx(() => controller.background.isNotEmpty
                      ? Container(
                          height: Get.width - 30,
                          width: Get.width - 30,
                          child: Stack(
                            children: [
                              Positioned(
                                  child: ImageUtil.networkImage(
                                      url: controller.background, fit: BoxFit.cover, border: 10.r,width: Get.width-30,height: Get.width-30)),
                              Positioned(
                                child: IconButton(
                                  icon: ImageUtil.assetImage('ic_delete', width: 30),
                                  onPressed: () {
                                    controller.deleteBackground();
                                  },
                                ),
                                top: -10,
                                right: -10,
                              ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 105.h,
                                width: 105.h,
                                padding: EdgeInsets.all(30).r,
                                decoration: BoxDecoration(
                                    color: Color(0xFF2D2E3C),
                                    borderRadius: BorderRadius.all(Radius.circular(10).r)),
                                child: ImageUtil.assetImage(
                                  'add_pic',
                                  imageType: IMG_PNG,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              onTap: () {
                                controller.selectBackground(context);
                              },
                            )
                          ],
                        ))
                ],
              ),
            )
          ],
        ),
      ),
      btnBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrivacyCheck(
            controller: controller.privacyCheckController,
            type: TYPE_ADD_BANK,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16).w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: StadiumButton(
                  'Previous'.tr,
                  textStyle: const TextStyle(color: AppColor.yellow, fontSize: 16),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.yellow,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20).r)),
                  onTap: () {
                    Get.back();
                  },
                )),
                16.horizontalSpace,
                Expanded(
                    child: StadiumButton(
                  'Submit'.tr,
                  onTap: () {
                    if (controller.privacyCheckController.check()) controller.updateService();
                  },
                )),
              ],
            ),
          )
        ],
      ));
}
