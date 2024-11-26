import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../model/integral_coupon_model.dart';
import '../../../../model/integral_model.dart';
import '../../../../widget/linear_progressbar_widget.dart';
import '../task/task_page.dart';
import 'ctr/integral_interests_ctr.dart';

class IntegralInterestsPage extends StatelessWidget {
  final ctr = Get.put(IntegralInterestsCtr());

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Obx(() => Container(
                height: 160.h,
                margin: EdgeInsets.only(top: 20.h),
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Container(
                          width: 1.sw,
                          height: 130.h,
                          margin: EdgeInsets.only(top: 30.h),
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 16.h,
                          ),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.99, -0.15),
                              end: Alignment(-0.99, 0.15),
                              colors: [Color(0xFF42435C), Color(0xFF202026)],
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.50, color: Color(0xFF6C6C79)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ctr.integralModel.value.levelConfigVoList[index].name}',
                                style: TextStyle(
                                  color: Color(0xFFB2BAC7),
                                  fontSize: 22.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                              ),
                              10.verticalSpace,
                              Text(
                                'Points:${ctr.integralModel.value.levelConfigVoList[index].threshold}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 13.sp,
                                  fontFamily: FONT_LIGHT,
                                ),
                              ),
                              4.verticalSpace,
                              Transform.translate(
                                offset: Offset(-6.w, 0),
                                child: LinearProgressBar(
                                  width: 120.w,
                                  progress: ((ctr
                                                  .integralModel
                                                  .value
                                                  .levelConfigVoList[index]
                                                  .nowExperience ??
                                              0) /
                                          (ctr
                                                  .integralModel
                                                  .value
                                                  .levelConfigVoList[index]
                                                  .threshold ??
                                              0)) *
                                      100,
                                  height: 4.h,
                                  bgColor: hexColor('242531'),
                                  progressStartColor: hexColor('ffffff'),
                                  progressEndColor: hexColor('ffffff'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => TaskPage())?.then(
                                    (value) =>
                                        UserController.find.updateInfo()),
                                child: Container(
                                  height: 26.h,
                                  margin: EdgeInsets.only(top: 15.h),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  decoration: ShapeDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Go do tasks to earn points',
                                          style: TextStyle(
                                            color: Color(0xFF9CA3AF),
                                            fontSize: 11.sp,
                                            fontFamily: FONT_LIGHT,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        ImageUtils.integral_arrow_icon,
                                        scale: 1.4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20.w,
                          child: Image.asset(
                            'assets/images/integral_lv${index + 1}_icon.webp',
                            scale: 2,
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: ctr.integralModel.value.levelConfigVoList.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  loop: false,
                  index: ctr.currentVIPIndex.value,
                  onIndexChanged: (int index) => ctr.changeIndex(index),
                ),
              )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          ImageUtils.integral_level_benefit_left_icon,
                          scale: 2,
                        ),
                      ),
                      10.horizontalSpace,
                      Image.asset(
                        ImageUtils.integral_level_benefit_text_icon,
                        scale: 3,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Image.asset(
                          ImageUtils.integral_level_benefit_right_icon,
                          scale: 2,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.only(
                      left: 15.w,
                      right: 15.w,
                      top: 25.h,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 15.h,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4.w,
                                height: 14.h,
                                color: hexColor("FFB20E"),
                                margin: EdgeInsets.only(right: 8.w),
                              ),
                              Expanded(
                                child: Text(
                                  'Coupons'.tr,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontFamily: FONT_MEDIUM,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Obx(() => RichText(
                                    text: TextSpan(
                                      text: 'You can redeem ',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${ctr.levelCoupons.length}',
                                          style: TextStyle(
                                            color: hexColor("FFB20E"),
                                          ),
                                        ),
                                        TextSpan(text: ' coupons.'),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Obx(() => ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (c, i) => Container(
                                width: 1.sw,
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(-1.00, -0.04),
                                    end: Alignment(1, 0.04),
                                    colors: [
                                      Color(0xFF302D26),
                                      Color(0xFF2D2D34)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF524B41)),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 15.h,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42.w,
                                      height: 42.w,
                                      decoration: ShapeDecoration(
                                        color: Color(0x19F097FF),
                                        shape: OvalBorder(),
                                      ),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(24.r),
                                          child: Image.asset(
                                            ImageUtils.integral_coupon_icon,
                                            width: 20.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${ctr.levelCoupons[i].name}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily: FONT_MEDIUM,
                                            ),
                                          ),
                                          8.verticalSpace,
                                          Text(
                                            '${ctr.levelCoupons[i].description}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontFamily: FONT_LIGHT,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => ctr.redeemCoupon(ctr.levelCoupons[i].id),
                                      child: Container(
                                        height: 30.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: ShapeDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment(1.00, 0.00),
                                            end: Alignment(-1, 0),
                                            colors: [Color(0xFFFFB20E), Color(0xFFFF760E)],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.r),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Redeem',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontFamily: 'DIN',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              separatorBuilder: (c, i) => 10.verticalSpace,
                              itemCount: ctr.levelCoupons.length,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
