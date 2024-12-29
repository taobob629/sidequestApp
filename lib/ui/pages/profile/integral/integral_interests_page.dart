import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../model/integral_model.dart';
import '../../../../widget/progress_bar/animation_progress_bar.dart';
import '../../../dialog/dialog_confirm.dart';
import '../task/task_page.dart';
import 'coupon_tip_dialog.dart';
import 'ctr/integral_interests_ctr.dart';

class IntegralInterestsPage extends StatelessWidget {
  final ctr = Get.put(IntegralInterestsCtr());

  @override
  Widget build(BuildContext context) => Obx(() => ctr
          .integralModel.value.levelConfigVoList.isEmpty
      ? Container()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
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
            Container(
              height: 160.h,
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${ctr.integralModel.value.levelConfigVoList[index].name}',
                              style: TextStyle(
                                color: Color(0xFFB2BAC7),
                                fontSize: 22.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              'Experience:${ctr.integralModel.value.levelConfigVoList[index].threshold}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 13.sp,
                                fontFamily: FONT_LIGHT,
                              ),
                            ),
                            4.verticalSpace,
                            SizedBox(
                              width: 120.w,
                              child: FAProgressBar(
                                size: 4.h,
                                currentValue: (ctr
                                            .integralModel
                                            .value
                                            .levelConfigVoList[index]
                                            .nowExperience *
                                        100) /
                                    (ctr.integralModel.value
                                        .levelConfigVoList[index].threshold),
                                progressColor: hexColor('ffffff'),
                                backgroundColor: hexColor('242531'),
                              ),
                            ),
                            6.verticalSpace,
                            Text(
                              ctr.currentUserVipLevel != (index + 1)
                                  ? "Only ${(ctr.integralModel.value.levelConfigVoList[index].threshold) - (ctr.integralModel.value.levelConfigVoList[index].nowExperience)} EXP left to reach Level ${ctr.integralModel.value.levelConfigVoList[index].level}"
                                  : "You've achieved the this level",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 12.sp,
                                fontFamily: FONT_LIGHT,
                              ),
                            ),
                            6.verticalSpace,
                            GestureDetector(
                              onTap: () => Get.back(result: true),
                              child: Container(
                                height: 26.h,
                                margin: EdgeInsets.only(bottom: 6.h),
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: ShapeDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r)),
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
            ),
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
                    20.verticalSpace,
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (c, i) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          color: hexColor('#2D2D34'),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  i % 2 == 0
                                      ? ImageUtils.icon_invitation
                                      : ImageUtils.icon_bubble,
                                  width: 40.w,
                                  height: 40.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${ctr.contentList[i]['title']}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: FONT_MEDIUM,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            ctr.contentList[i]['notes'] != null,
                                        child: 10.verticalSpace,
                                      ),
                                      Visibility(
                                        visible:
                                            ctr.contentList[i]['notes'] != null,
                                        child: Text(
                                          '${ctr.contentList[i]['notes']}',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontFamily: FONT_MEDIUM,
                                            color: hexColor('#FFB20E'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: ctr.contentList[i]["description"] !=
                                          null &&
                                      ctr.contentList[i]["description"] != "",
                                  child: InkWell(
                                    onTap: () => ctr.contentList[i]
                                                    ["description"] !=
                                                null &&
                                            ctr.contentList[i]["description"] !=
                                                ""
                                        ? Get.dialog(
                                            CouponTipDialog(
                                              info: ctr.contentList[i]
                                                  ["description"],
                                            ),
                                            barrierColor: Colors.black38,
                                          )
                                        : null,
                                    child: Icon(
                                      Icons.error_outline,
                                      size: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (c, i) => 10.verticalSpace,
                      itemCount: ctr.contentList.length,
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
                          Visibility(
                            visible: ctr.levelCoupons.isNotEmpty,
                            child: Container(
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
                                ],
                              ),
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 30.h),
                            itemBuilder: (c, i) =>
                                couponItemWidget(ctr.levelCoupons[i]),
                            separatorBuilder: (c, i) => 10.verticalSpace,
                            itemCount: ctr.levelCoupons.length,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));

  Widget couponItemWidget(CouponsModel model) => Container(
        width: 1.sw,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.00, -0.04),
            end: Alignment(1, 0.04),
            colors: [Color(0xFF302D26), Color(0xFF2D2D34)],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFF524B41)),
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
                  borderRadius: BorderRadius.circular(24.r),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  Visibility(
                    visible: model.description != null,
                    child: 8.verticalSpace,
                  ),
                  Visibility(
                    visible: model.description != null,
                    child: Text(
                      '${model.description}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontFamily: FONT_LIGHT,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'X${model.num}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontFamily: FONT_LIGHT,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => ctr.redeemCoupon(model),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(1.00, 0.00),
                              end: Alignment(-1, 0),
                              colors: model.state == 0
                                  ? [Color(0xFFFFB20E), Color(0xFFFF760E)]
                                  : [Colors.grey, Colors.grey],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Claim',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
