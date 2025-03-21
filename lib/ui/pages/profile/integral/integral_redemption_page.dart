import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import 'ctr/integral_redemption_ctr.dart';
import 'integral_detail_page.dart';
import 'integral_home_page.dart';

class IntegralRedemptionPage extends StatelessWidget {
  final _ctr = Get.put(IntegralRedemptionCtr());

  @override
  Widget build(BuildContext context) => Obx(() => _ctr.tabs.isEmpty
      ? Container()
      : Container(
          width: 1.sw,
          height: 1.sh,
          color: AppColor.background,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  ImageUtils.integral_redemption_top_icon,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  SafeArea(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My points',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 13.sp,
                          fontFamily: 'DIN',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        '${_ctr.integralInfoModel.value.pointInfo?.pointsTotal}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  titleWidget(
                    leftText: "Points Redemption",
                    marginLeft: 0,
                    marginRight: 0,
                    viewAllText: '',
                  ),
                  Container(
                    height: 30.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (c, i) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _ctr.selectTab(i),
                        child: Obx(() => Container(
                              height: 30.h,
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23).r,
                                  gradient: i == _ctr.selectStatus.value
                                      ? LinearGradient(colors: [
                                          AppColor.yellow,
                                          AppColor.yellow,
                                        ])
                                      : LinearGradient(colors: [
                                          AppColor.tabBackGround,
                                          AppColor.tabBackGround
                                        ])),
                              alignment: Alignment.center,
                              child: Text(
                                _ctr.tabs[i],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp),
                              ),
                            )),
                      ),
                      separatorBuilder: (c, i) => 10.horizontalSpace,
                      itemCount: _ctr.tabs.length,
                    ),
                  ),
                  15.verticalSpace,
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 3 columns
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 15.0.w,
                        mainAxisSpacing: 15.0.h,
                      ),
                      itemBuilder: (context, index) =>
                          pointsRedemptionWidget(index),
                      itemCount: _ctr.selectGoods.length,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));

  Widget pointsRedemptionWidget(int index) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _ctr.exchange(_ctr.selectGoods[index]['id']),
        child: Container(
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF202026), Color(0xFF202026)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: '${_ctr.selectGoods[index]['picUrl']}',
                fit: BoxFit.cover,
                width: 106.w,
                height: 106.w,
              ),
              15.verticalSpace,
              Container(
                width: 1.sw,
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  '${_ctr.selectGoods[index]['name']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontFamily: 'DIN',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              15.verticalSpace,
              Row(
                children: [
                  15.horizontalSpace,
                  RichText(
                    text: TextSpan(
                        text: "${_ctr.selectGoods[index]['points']}\n".tr,
                        style: TextStyle(
                          color: Color(0xFFFFB20E),
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                        children: [
                          TextSpan(
                              text: "Points".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontFamily: FONT_LIGHT,
                              )),
                        ]),
                  ),
                  Spacer(),
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: hexColor('4dFFB20E'),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColor.yellow,
                      size: 18.sp,
                    ),
                  ),
                  15.horizontalSpace,
                ],
              ),
            ],
          ),
        ),
      );
}
