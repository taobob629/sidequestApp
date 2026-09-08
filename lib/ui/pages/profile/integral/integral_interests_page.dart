import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../widget/progress_bar/animation_progress_bar.dart';
import 'ctr/integral_interests_ctr.dart';

class IntegralInterestsPage extends StatelessWidget {
  final ctr = Get.put(IntegralInterestsCtr());

  @override
  Widget build(BuildContext context) =>
      Obx(() => Container(
          width: 1.sw,
          height: 1.sh,
          color: AppColor.background,
          child: ctr.integralModel.value.levelConfigVoList.isEmpty
              ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                )
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
                                  colors: [
                                    Color(0xFF42435C),
                                    Color(0xFF202026)
                                  ],
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
                                          (ctr
                                              .integralModel
                                              .value
                                              .levelConfigVoList[index]
                                              .threshold),
                                      progressColor: hexColor('ffffff'),
                                      backgroundColor: hexColor('242531'),
                                    ),
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    ctr.integralModel.value
                                        .levelConfigVoList[index].description
                                        .toString(),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
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
                      itemCount:
                          ctr.integralModel.value.levelConfigVoList.length,
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
                                      ImageUtil.networkImage(
                                        url: '${ctr.contentList[i]['icon']}',
                                        width: 40.w,
                                        height: 40.w,
                                        fit: BoxFit.cover,
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
                                              visible: ctr.contentList[i]
                                                      ['notes'] !=
                                                  null,
                                              child: 10.verticalSpace,
                                            ),
                                            Visibility(
                                              visible: ctr.contentList[i]
                                                      ['notes'] !=
                                                  null,
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
                                        visible: ctr.contentList[i]
                                                    ["description"] !=
                                                null &&
                                            ctr.contentList[i]["description"] !=
                                                "",
                                        child: InkWell(
                                          onTap: () => ctr.showTipDialog(i),
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
                          30.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
}
