import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/utils/toast_utils.dart';

import 'ctr/integral_detail_ctr.dart';

class IntegralDetailPage extends StatelessWidget {
  final ctr = Get.put(IntegralDetailCtr());

  @override
  Widget build(BuildContext context) => BaseScaffold(
        title: "Details".tr,
        body: Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    40.verticalSpace,
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: '${ctr.integralGoodsDetailModel.value.pic}',
                        fit: BoxFit.cover,
                        height: 120.w,
                        errorWidget: (c, m, e) =>
                            Image.asset(ImageUtils.default_logo),
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
                      margin: EdgeInsets.only(top: 36.h),
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text:
                                  "${ctr.integralGoodsDetailModel.value.price} ",
                              style: TextStyle(
                                color: AppColor.yellow,
                                fontSize: 20.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                              children: [
                                TextSpan(
                                  text: "Points".tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontFamily: FONT_LIGHT,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            'Mouse 50% off coupon',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                          Text(
                            '--------------------------------------------------------------------------------------------------------------------------------------------',
                            style: TextStyle(
                              color: hexColor('3C3C43'),
                              fontSize: 10.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                            maxLines: 1,
                          ),
                          6.verticalSpace,
                          ...ctr.integralGoodsDetailModel.value.coupons.map(
                            (e) => orderWidget(e.couponName ?? ''),
                          ),
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
                        bottom: 48.h,
                      ),
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kindly Reminder',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                          10.verticalSpace,
                          orderWidget(
                              'Points once exchanged cannot be refunded. After successful exchange, you can view and use them in [My - Wallet - Coupons].'),
                          10.verticalSpace,
                          orderWidget(
                              'Points once exchanged cannot be refunded. After successful exchange, you can view and use them in [My - Wallet - Coupons].'),
                          10.verticalSpace,
                          orderWidget(
                              'Points once exchanged cannot be refunded. After successful exchange, you can view and use them in [My - Wallet - Coupons].'),
                        ],
                      ),
                    ),
                    ColorfulButton(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          ctr.integralGoodsDetailModel.value.enoughPoint == true
                              ? "${ctr.integralGoodsDetailModel.value.price} points"
                              : "Insufficient points, earn points".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "DIN",
                          ),
                        ),
                      ),
                      height: 50.h,
                      onTap: () =>
                          ctr.integralGoodsDetailModel.value.enoughPoint == true
                              ? Get.dialog(
                                  pointsPayWidget(),
                                )
                              : Get.back(),
                    ),
                  ],
                ),
              ),
            )),
      );

  Widget orderWidget(String desc) => Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
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
        ),
      );

  Widget pointsPayWidget() => Center(
        child: Container(
          width: 260.w,
          height: 300.h,
          child: Stack(
            children: [
              Container(
                width: 260.w,
                height: 260.h,
                margin: EdgeInsets.only(top: 40.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    60.verticalSpace,
                    Text(
                      'Consume points',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    30.verticalSpace,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'You will consume ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${ctr.integralGoodsDetailModel.value.price} ',
                            style: TextStyle(
                              color: Color(0xFFFFB20E),
                              fontSize: 13.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                          TextSpan(
                            text: 'points to redeem the benefit.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => ctr.confirm(),
                      child: Container(
                        height: 40.h,
                        margin: EdgeInsets.only(
                          left: 15.w,
                          right: 15.w,
                          top: 30.h,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFF760E),
                                  Color(0xFFFFB20E)
                                ])),
                        child: Text(
                          'Confirm exchange',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Image.asset(
                  ImageUtils.integral_detail_dialog_icon,
                  fit: BoxFit.contain,
                  width: 190.w,
                  height: 90.h,
                ),
              ),
            ],
          ),
        ),
      );
}
