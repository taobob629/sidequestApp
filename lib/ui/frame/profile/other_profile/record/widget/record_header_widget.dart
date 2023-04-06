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
import 'package:wy/ui/frame/profile/other_profile/record/controller.dart';
import 'package:wy/utils/index.dart';

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
        : Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 210.w,
                    height: 34.h,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        gradient: LinearGradient(colors: [Color(0xFF6B5BFF), Color(0xFF7643E3)]),
                        boxShadow: [
                          BoxShadow(blurRadius: 8, spreadRadius: 0.5, offset: Offset(0, 3.5))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageUtil.assetImage('profile/icon_voice_record', height: 14),
                        ImageUtil.assetImage('profile/icon_voice', height: 14),
                      ],
                    )),
                15.horizontalSpace,
                // InkWell(
                //   onTap: () => controller.delete(),
                //   child: ImageUtil.assetImage('ic_delete2', width: 16.w, height: 34),
                // )
              ],
            ),
          ));
  }
}
