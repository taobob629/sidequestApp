import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/base_scaffold.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../config/app_color.dart';
import '../../../getx_ctr/bubble_confirm_order_ctr.dart';
import '../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../widget/container_tab_indicator.dart';

class BubbleConfirmOrderPage extends StatelessWidget {
  final ctr = Get.put(BubbleConfirmOrderCtr());

  @override
  Widget build(BuildContext context) => BaseScaffold(
        title: 'Confirm Order'.tr,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Center(
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              margin: EdgeInsets.only(left: 16.w),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: 1.sw,
              height: 200.h,
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 18.h,
              ),
              decoration: ShapeDecoration(
                color: Color(0xFF141517),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 230.w,
                      height: 148.h,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Color(0xFF231E13), Color(0x00141517)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 36.w,
                    top: 7.h,
                    width: 38.w,
                    height: 38.h,
                    child: Image.asset(ImageUtils.tea_icon),
                  ),
                  Positioned(
                    right: 8.w,
                    top: 32.h,
                    width: 25.w,
                    height: 25.h,
                    child: Image.asset(ImageUtils.tea_app_logo_icon),
                  ),
                  Positioned(
                    right: 14.w,
                    top: 18.h,
                    left: 14.w,
                    bottom: 22.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sidequest Hub Coventry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          'UNIT 12 CATHEDRAL LANES SHOPPING CENTRE, Broadgate, Coventry CV1 1LL',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w400,
                            height: 1.8,
                          ),
                        ).paddingOnly(right: 45.w),
                        15.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dining methods'.tr,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              width: 160.w,
                              height: 34.h,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.w, color: Color(0xFFFFB20E)),
                                  borderRadius: BorderRadius.circular(60.r),
                                ),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  tabBarTheme: Theme.of(context)
                                      .tabBarTheme
                                      .copyWith(
                                        labelColor: Colors.white,
                                        // 设置想要的选中标签文本颜色
                                        unselectedLabelColor: AppColor.yellow,
                                      ),
                                ),
                                child: TabBar(
                                  controller: ctr.tabController,
                                  tabs: ctr.tabs,
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  indicator: ContainerTabIndicator(
                                    height: 34.h,
                                    width: 80.w,
                                    radius: BorderRadius.circular(64.r),
                                    colors: [AppColor.yellow, AppColor.yellow],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        20.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Meal pickup time'.tr,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '10 : 00'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1.sw,
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              decoration: ShapeDecoration(
                color: Color(0xFF141517),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              padding: EdgeInsets.only(
                left: 14.w,
                right: 14.w,
                top: 18.h,
                bottom: 22.h,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (c, i) => i == 2 ? footerWidget() : itemWidget(i),
                separatorBuilder: (c, i) => 10.verticalSpace,
                itemCount: TabBubbleTeaCtr.find.selectTeaList.length,
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 44.w,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: ShapeDecoration(
            color: hexColor('4C3608'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.r),
            ),
          ),
          child: Row(
            children: [
              14.horizontalSpace,
              Text(
                '£${TabBubbleTeaCtr.find.totalPrice.value}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Discount：-0.0 ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.6),
                          size: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => ctr.payment(),
                child: Container(
                  width: 100.w,
                  height: 44.w,
                  decoration: ShapeDecoration(
                    color: hexColor('FFB20E'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Payment'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget itemWidget(int i) => Row(
        children: [
          ImageUtil.networkImage(
            url: "${TabBubbleTeaCtr.find.selectTeaList[i].image}",
            width: 65.w,
            height: 65.w,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${TabBubbleTeaCtr.find.selectTeaList[i].name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                6.verticalSpace,
                Visibility(
                  visible: TabBubbleTeaCtr.find.selectTeaList[i].brief != null,
                  child: Text(
                    '${TabBubbleTeaCtr.find.selectTeaList[i].brief}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '£${TabBubbleTeaCtr.find.selectTeaList[i].retailPrice}',
                style: TextStyle(
                  color: Color(0xFFFFB20E),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ),
              6.verticalSpace,
              Text(
                'X${TabBubbleTeaCtr.find.selectTeaList[i].count}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      );

  Widget footerWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
            margin: EdgeInsets.symmetric(vertical: 16.h),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Coupon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: "Currently unavailable".tr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 14.sp,
                        ).paddingOnly(left: 14.w),
                      ),
                    ]),
              ),
            ],
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
            margin: EdgeInsets.symmetric(vertical: 16.h),
          ),
          Row(
            children: [
              Spacer(),
              RichText(
                text: TextSpan(
                  text: "2".tr,
                  style: TextStyle(
                    color: AppColor.yellow,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    WidgetSpan(child: 6.horizontalSpace),
                    TextSpan(
                      text: "item in total".tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    WidgetSpan(child: 6.horizontalSpace),
                    TextSpan(
                      text: "£18".tr,
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: 20.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
}
