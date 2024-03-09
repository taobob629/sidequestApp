import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/common/colorful_button.dart';

import 'ctr/integral_task_detail_ctr.dart';

class IntegralTaskDetailPage extends StatelessWidget {

  final ctr = Get.put(IntegralTaskDetailCtr());

  @override
  Widget build(BuildContext context) => Obx(() => Container(
    width: 1.sw,
    height: 1.sh,
    child: Stack(
      children: [
        Image.asset(
          ImageUtils.integral_task_detail_top,
          fit: BoxFit.fill,
          width: 1.sw,
          height: 280.h,
        ),
        SafeArea(
          child: Container(
            height: 40.h,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 230.h,
          child: Container(
            width: 1.sw,
            height: 1.sh,
            decoration: ShapeDecoration(
              color: Color(0xFF161819),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 74.h,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff4B3B28),
                          Color(0xff161819),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.h, right: 6.w),
                          child: Image.asset(
                            ImageUtils.integral_checkin_icon,
                            height: 30.h,
                          ),
                        ),
                        Text(
                          'X${ctr.integralTaskDetailModel.value.integralNumber} Points'.tr,
                          style: TextStyle(
                            color: Color(0xFFFFB20E),
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Text(
                      '${ctr.integralTaskDetailModel.value.taskName}'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    decoration: ShapeDecoration(
                      color: Color(0xFF202026),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    margin: EdgeInsets.only(
                      top: 10.h,
                      left: 15.w,
                      right: 15.w,
                    ),
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        10.verticalSpace,
                        orderWidget(
                            '${ctr.integralTaskDetailModel.value.description}'),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    decoration: ShapeDecoration(
                      color: Color(0xFF202026),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    margin: EdgeInsets.only(
                      top: 10.h,
                      left: 15.w,
                      right: 15.w,
                    ),
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requirements description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        10.verticalSpace,
                        orderWidget(
                            '${ctr.integralTaskDetailModel.value.taskAskFor}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  ));

  Widget orderWidget(String desc) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 4.w,
        height: 4.w,
        margin: EdgeInsets.only(top: 6.h),
        decoration: ShapeDecoration(
          color: Color(0xFFFFB20E),
          shape: OvalBorder(),
        ),
      ),
      6.horizontalSpace,
      Expanded(
        child: Text(
          desc,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: FONT_LIGHT,
          ),
        ),
      )
    ],
  );

  Widget itemWidget({
    required String icon,
    required String name,
    required String num,
    required Color color,
  }) =>
      Expanded(
        child: Column(
          children: [
            Image.asset(
              icon,
              scale: 2.0,
              fit: BoxFit.cover,
            ),
            4.verticalSpace,
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: 'DIN',
              ),
            ),
            6.verticalSpace,
            Text(
              num,
              style: TextStyle(
                color: color,
                fontSize: 14.sp,
                fontFamily: 'DIN',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}
