import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/colorful_button.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../api/index_api.dart';
import '../../controller/user_controller.dart';
import '../../model/promotion_item_model.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/toast_utils.dart';

class SignSuccessDialog extends StatelessWidget {
  String? points;
  String? title;
  String? congratulations;

  SignSuccessDialog({
    this.points,
    this.title,
    this.congratulations,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 260.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  ImageUtils.sign_success_icon,
                  height: 100.h,
                  fit: BoxFit.fill,
                ),
                Center(
                  child: Image.asset(
                    ImageUtils.sign_coin_icon,
                    width: 80.w,
                    height: 70.h,
                  ).marginOnly(top: 40.h),
                )
              ],
            ),
            Text(
              '---------------------------------------------------------------------------------------------------------',
              style: TextStyle(
                color: hexColor('#1A1A1A'),
                fontFamily: FONT_MEDIUM,
              ),
              maxLines: 1,
            ),
            Text(
              title ?? 'Sign-in successful'.tr,
              style: TextStyle(
                color: hexColor('#1A1A1A'),
                fontSize: 20.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ).paddingOnly(top: 12.h),
            Text(
              congratulations ?? 'congratulations, you have earned'.tr,
              style: TextStyle(
                color: hexColor('#1A1A1A'),
                fontSize: 12.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ).paddingOnly(top: 12.h),
            Text(
              '$points',
              style: TextStyle(
                color: hexColor('#FF9729'),
                fontSize: 12.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
            ColorfulButton(
              width: 224.w,
              height: 40.h,
              borderRadius: 10.r,
              child: Text(
                "Got it!".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              onTap: () => dismissLoading(),
            ).marginOnly(top: 20.h, bottom: 26.h),
          ],
        ),
      );
}
