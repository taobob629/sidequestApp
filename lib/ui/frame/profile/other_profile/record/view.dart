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
import 'package:wy/res/index.dart';
import 'package:wy/ui/frame/profile/other_profile/record/widget/record_header_widget.dart';
import 'package:wy/utils/index.dart';
import '../../../../../config/icon_font.dart';
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
                        visible: controller.countDownNum > 0,
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
                    GestureDetector(
                      child: ImageUtil.assetImage('profile/record', width: 85.w, height: 85.w),
                      onLongPressStart: (LongPressStartDetails details) {
                        flog('onLongPressStart $details');
                        //
                        controller.startRecord();
                      },
                      onLongPress: (){
                        flog('onLongPress ');
                      },
                      onLongPressDown: (LongPressDownDetails details){
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
                    Dimens.dVerticalNomarl,
                    Text(
                      'Long press recording',
                      style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 14.sp),
                    )
                  ],
                ))
          ],
        ));
  }
}
