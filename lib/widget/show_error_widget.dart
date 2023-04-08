import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../config/icon_font.dart';
import '../image_utils.dart';

void showErrorWidget(String message) {
  final overlayState = Overlay.of(Get.context!);
  final overlayEntry = OverlayEntry(
    builder: (BuildContext context) => Center(
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          color: Color(0xffFFCB0E),
          borderRadius: BorderRadius.circular(15.r),
        ),
        padding: EdgeInsets.only(top: 5.h, bottom: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  ImageUtils.iconError,
                  width: 18.w,
                  height: 18.w,
                ),
                7.horizontalSpace,
                Text(
                  'Oops!'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
            Container(
              width: 248.w,
              decoration: BoxDecoration(
                color: Color(0xff080808),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.r),
                  bottomRight: Radius.circular(15.r),
                ),
              ),
              margin: EdgeInsets.only(top: 5.h),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
              alignment: Alignment.center,
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  overlayState?.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3)).then((_) {
    overlayEntry.remove();
  });
}
