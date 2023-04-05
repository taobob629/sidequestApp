/**
    author:mac
    创建日期:2023/4/5
    描述:
 */
/**
    author:mac
    创建日期:2023/4/5
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/frame/profile/other_profile/record/controller.dart';

class CountDownWidget extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Obx(() => Text('${controller.countDownShow()}',
                style: TextStyle(
                  fontFamily: FONT_MEDIUM,
                  fontSize: 33.sp,
                ))),
            10.verticalSpace,
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Record for at least ',
                  style: TextStyle(color: Color(0xffB2B9C9), fontSize: 12.sp)),
              TextSpan(text: '10 ', style: TextStyle(color: AppColor.textYellow, fontSize: 12.sp)),
              TextSpan(
                  text: 'seconds ', style: TextStyle(color: Color(0xffB2B9C9), fontSize: 12.sp))
            ]))
          ],
        ));
  }
}
