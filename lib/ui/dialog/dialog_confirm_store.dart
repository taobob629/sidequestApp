import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/utils/toast_utils.dart';

import '../../getx_ctr/tab_bubble_tea_ctr.dart';

class DialogConfirmStore extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Container(
        decoration: ShapeDecoration(
          color: Color(0xFF23201C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        width: 1.sw - 40.w,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.w500,
              ),
            ),
            20.verticalSpace,
            Text(
              '${TabBubbleTeaCtr.find.currentSelectStore.value.name}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.w700,
              ),
            ),
            16.verticalSpace,
            Text(
              '${TabBubbleTeaCtr.find.currentSelectStore.value.address}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10.sp,
                fontFamily: FONT_MEDIUM,
                fontWeight: FontWeight.w500,
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                Text(
                  'In operation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF31BE48),
                    fontSize: 13.sp,
                    fontFamily: FONT_LIGHT,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${TabBubbleTeaCtr.find.currentSelectStore.value.openTime}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontFamily: FONT_LIGHT,
                      fontWeight: FontWeight.w400,
                    ),
                  ).paddingOnly(left: 14.w),
                ),
                Image.asset(
                  ImageUtils.distance_icon,
                  scale: 2,
                ),
                Text(
                  TabBubbleTeaCtr.find.minDistances.value >= 1000
                      ? "${(TabBubbleTeaCtr.find.minDistances.value / 1000).toStringAsFixed(2)}km"
                      : "${TabBubbleTeaCtr.find.minDistances.value.toStringAsFixed(2)}m",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFB20E),
                    fontSize: 12.sp,
                    fontFamily: FONT_LIGHT,
                    fontWeight: FontWeight.w400,
                  ),
                ).paddingOnly(left: 8.w),
              ],
            ),
            30.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => dismissLoading(),
                  child: Container(
                    width: 140.w,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.w, color: Color(0xFFFFB20E)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFB20E),
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.41,
                      ),
                    ),
                  ),
                ),
                18.horizontalSpace,
                InkWell(
                  onTap: () => SmartDialog.dismiss(result: "confirm"),
                  child: Container(
                    width: 140.w,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFB20E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Confirm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.41,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
