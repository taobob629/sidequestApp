import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/index.dart';

import '../qr_login_page.dart';

class QrLoginFromWidget extends GetView<QrLoginPageController> {
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(15.r),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
            gradient: LinearGradient(
              colors: [
                Color(0xFF92E9B7),
                Color(0xFF8CBEFD),
                Color(0xFFC09EFD),
                Color(0xFFEEB7A9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Column(
          children: [
            Row(
              children: [
                ImageUtil.networkImage(
                    url: userController.userProfile.avatar,
                    width: 48,
                    height: 48,
                    border: 24),
                16.horizontalSpace,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userController.userProfile.nickName,
                      style: TextStyle(
                          color: AppColor.primary, fontFamily: FONT_MEDIUM),
                    ),
                    5.verticalSpace,
                    Text(
                      userController.userProfile.email,
                      style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 12.sp,
                          fontFamily: FONT_LIGHT),
                    ),
                  ],
                ),
                Spacer(),
                ImageUtil.assetImage('logo_mirror', width: 26.w),
              ],
            ),
            16.verticalSpace,
            Divider(
              height: 1.h,
              color: Colors.white,
            ),
            10.verticalSpace,
            rowItem('Device', 'test'),
            rowItem('Price', 'test'),
            rowItem('Available for Gaming Free Time', 'test'),
            rowItem('Discount', 'test'),
            rowItem('Remaining Balance', 'test'),
            rowItem('Remaining Gaming Free Time', 'test'),
            rowItem('Remaining Credit Duration', 'test'),
            rowItem('Estimated Exhausted Time', 'test'),
          ],
        ),
      );

  rowItem(String label, String content) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.tr,
            style: TextStyle(color: Color(0xFF5E5D64), fontSize: 12.sp),
          ),
          Text(
            '$content',
            style: TextStyle(
                color: AppColor.primary,
                fontSize: 12.sp,
                fontFamily: FONT_MEDIUM),
          ),
        ],
      ),
    );
  }
}
