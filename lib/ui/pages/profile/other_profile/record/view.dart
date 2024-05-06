/**
    author:mac
    创建日期:2023/3/30
    描述:
 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/profile/other_profile/record/widget/record_header_widget.dart';

import '../../../../../common/styles.dart';
import '../../../../../config/icon_font.dart';
import '../../../../../res/dimens.dart';
import '../../../../../utils/permission_util.dart';
import '../../../../../utils/utils.dart';
import 'controller.dart';
import 'widget/count_down_widget.dart';

class RecordViewPage extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Voice Record'.tr),
        ),
        body: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: 20.h,
                child: Column(
                  children: [
                    RecordHeaderWidget(),
                    CountDownWidget(),
                    Obx(() => Visibility(
                        visible: controller.isRecording,
                        child: Container(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Lottie.asset(
                            'assets/anim/waves.json',
                            width: Get.width,
                            height: 35.h,
                            fit: BoxFit.contain,
                          ),
                        )))
                  ],
                )),
            Positioned(
                left: 0,
                right: 0,
                bottom: 210.h,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Visibility(
                            visible: controller.recordFileUrl?.isNotEmpty == true,
                            child: InkWell(
                              onTap: () => controller.delete(),
                              child: Container(
                                width: 45.w,
                                height: 45.w,
                                padding: EdgeInsets.all(14).w,
                                decoration: itemDecoration(radius: 45.w / 2),
                                child: Image.asset(ImageUtils.ic_delete2,
                                    fit: BoxFit.scaleDown, width: 16.w, height: 16.w),
                              ),
                            ))),
                        50.horizontalSpace,
                        GestureDetector(
                          child: Image.asset(ImageUtils.record, width: 85.w, height: 85.w),
                          onLongPressStart: (LongPressStartDetails details) {
                            flog('onLongPressStart $details');
                            //检查权限
                            PermissionUtil.microphone(() => controller.startRecord()
                            );
                          },
                          onLongPress: () {
                            flog('onLongPress ');
                          },
                          onLongPressDown: (LongPressDownDetails details) {
                            flog('LongPressDownDetails  ');
                          },
                          onLongPressCancel: () {
                            flog('onLongPressCancel ');
                          },
                          onLongPressEnd: (LongPressEndDetails details) {
                            flog('onLongPressEnd $details');
                          },
                          onLongPressUp: () {
                            controller.stopRecord();
                            flog('onLongPressUp');
                          },
                        ),
                        50.horizontalSpace,
                        Obx(() => Visibility(
                            visible: controller.recordFileUrl?.isNotEmpty == true,
                            child: InkWell(
                              onTap: () => controller.onOk(),
                              child: Container(
                                width: 45.w,
                                height: 45.w,
                                padding: EdgeInsets.all(14).w,
                                decoration: itemDecoration(radius: 45.w / 2),
                                child: Image.asset(ImageUtils.ic_ok,
                                    fit: BoxFit.scaleDown, width: 16.w, height: 16.w),
                              ),
                            )))
                      ],
                    ),
                    Dimens.dVerticalNomarl,
                    Text(
                      'Press and hold to record'.tr,
                      style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 14.sp),
                    )
                  ],
                ))
          ],
        ));
  }
}
