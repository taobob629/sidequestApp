import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sq_hub_app/model/integral_info_model.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../model/integral_task_model.dart';
import '../../../../widget/gradient_border_widget.dart';
import '../../../../widget/progress_bar/animation_progress_bar.dart';
import 'ctr/integral_home_ctr.dart';
import 'integral_detail_page.dart';
import 'integral_record_page.dart';
import 'integral_redemption_page.dart';
import 'integral_task_detail_page.dart';

class IntegralHomePage extends StatelessWidget {
  final t = Get.put(IntegralHomeCtr());

  @override
  Widget build(BuildContext context) => Obx(
        () => t.isLoading.value
            ? Container()
            : SingleChildScrollView(
                controller: t.scrollController,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
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
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Obx(() => ExtendedImage.network(
                                          '${t.integralInfoModel.value.pointInfo?.memberPhoto}',
                                          width: 40.w,
                                          height: 40.w,
                                          shape: BoxShape.circle,
                                          fit: BoxFit.cover,
                                          loadStateChanged:
                                              (ExtendedImageState state) {
                                            switch (
                                                state.extendedImageLoadState) {
                                              case LoadState.failed:
                                                return ExtendedImage.asset(
                                                  ImageUtils.default_logo,
                                                  width: 40.w,
                                                  height: 40.w,
                                                  shape: BoxShape.circle,
                                                  fit: BoxFit.cover,
                                                );
                                            }
                                          },
                                        )),
                                    10.horizontalSpace,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(() => Text(
                                              '${t.integralInfoModel.value.pointInfo?.nickName}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontFamily: FONT_MEDIUM,
                                              ),
                                            )),
                                        6.verticalSpace,
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () => Get.to(
                                              () => IntegralRecordPage()),
                                          child: Row(
                                            children: [
                                              Obx(() => Text(
                                                    'Points:${t.integralInfoModel.value.pointInfo?.points}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFF9CA3AF),
                                                      fontSize: 16.sp,
                                                      fontFamily: FONT_MEDIUM,
                                                    ),
                                                  )),
                                              3.horizontalSpace,
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Color(0xFF9CA3AF),
                                                size: 13.sp,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Obx(() => GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => t.toInterestsPage(),
                                      child: Text(
                                        '${t.integralInfoModel.value.pointInfo?.desc}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontFamily: 'DIN',
                                        ),
                                      ).paddingOnly(top: 20.h),
                                    )),
                                6.verticalSpace,
                                Obx(() => GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => t.toInterestsPage(),
                                      child: SizedBox(
                                        width: 200.w,
                                        child: FAProgressBar(
                                          size: 6.h,
                                          currentValue: (t
                                                      .integralInfoModel
                                                      .value
                                                      .pointInfo
                                                      ?.experience ??
                                                  0)
                                              .toDouble(),
                                          maxValue: (t
                                                      .integralInfoModel
                                                      .value
                                                      .pointInfo
                                                      ?.nextExperience ??
                                                  1)
                                              .toDouble(),
                                          progressGradient: LinearGradient(
                                              colors: [
                                                hexColor('#FF760E'),
                                                hexColor('#FFB20E')
                                              ]),
                                          backgroundColor: hexColor('#45494B'),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Obx(() => GestureDetector(
                                    onTap: () => t.toInterestsPage(),
                                    child: Image.asset(
                                      'assets/images/integral_lv${t.integralInfoModel.value.pointInfo?.expGrade ?? 0}_icon.webp',
                                      scale: 2,
                                    ),
                                  )),
                              10.verticalSpace,
                              t.integralInfoModel.value.pointInfo
                                          ?.expGradeState ==
                                      1
                                  ? InkWell(
                                      onTap: () => t.upgrade(),
                                      child: GradientBorderWidget(
                                        child: Text(
                                          'Upgrade'.tr,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: hexColor('#FFB20E'),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(40.r),
                                      ),
                                      child: GradientBorderWidget(
                                        colors: [Colors.grey, Colors.grey],
                                        child: Text(
                                          'Upgrade'.tr,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color:
                                                Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          15.horizontalSpace,
                        ],
                      ),
                      20.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60.h,
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.00, -1.00),
                                  end: Alignment(0, 1),
                                  colors: [
                                    Color(0xFF202026),
                                    Color(0xFF202026)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: ShapeDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF4E2828),
                                          Color(0xFF202026)
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 10.w,
                                    bottom: 0,
                                    child: Image.asset(
                                      ImageUtils.integral_benefit_bottom_icon,
                                      width: 32.w,
                                      height: 12.h,
                                    ),
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => t.toInterestsPage(),
                                      child: Row(
                                        children: [
                                          10.horizontalSpace,
                                          Image.asset(
                                            ImageUtils.integral_benefit_icon,
                                            width: 26.w,
                                            height: 26.w,
                                          ),
                                          4.horizontalSpace,
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  'My Benefits'.tr,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.sp,
                                                    fontFamily: 'DIN',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                badges.Badge(
                                                  showBadge: t.integralInfoModel
                                                          .value.couponNum! >
                                                      0,
                                                  badgeContent: Text(
                                                    '${t.integralInfoModel.value.couponNum}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                  badgeColor: Color(0xffFF4848),
                                                  position:
                                                      badges.BadgePosition(
                                                    end: -14,
                                                    top: -6,
                                                  ),
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    ''.tr,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                      fontFamily: 'DIN',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Image.asset(
                                            ImageUtils.integral_arrow_icon,
                                          ),
                                          4.horizontalSpace,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: Container(
                              height: 60.h,
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.00, -1.00),
                                  end: Alignment(0, 1),
                                  colors: [
                                    Color(0xFF202026),
                                    Color(0xFF202026)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: ShapeDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF4E2828),
                                          Color(0xFF202026)
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 10.w,
                                    bottom: 0,
                                    child: Image.asset(
                                      ImageUtils
                                          .integral_points_mall_bottom_icon,
                                      width: 32.w,
                                      height: 12.h,
                                    ),
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => Get.to(
                                        () => IntegralRedemptionPage(),
                                        arguments: t.integralInfoModel.value
                                            .pointInfo?.pointsTotal,
                                      ),
                                      child: Row(
                                        children: [
                                          10.horizontalSpace,
                                          Image.asset(
                                            ImageUtils.integral_point_mall_icon,
                                            width: 26.w,
                                            height: 26.w,
                                          ),
                                          8.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              'Points Mall'.tr,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontFamily: 'DIN',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Image.asset(
                                            ImageUtils.integral_arrow_icon,
                                          ),
                                          6.horizontalSpace,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      15.verticalSpace,
                      Container(
                        width: 1.sw,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [Color(0xFF202026), Color(0xFF202026)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        padding: EdgeInsets.all(10.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Row(
                                  children: [
                                    InkWell(
                                      onTap: () => t.isAppTab.value = true,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: t.isAppTab.value
                                              ? Colors.yellow
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 3.h),
                                        child: Text(
                                          "App check-in".tr,
                                          style: TextStyle(
                                            color: t.isAppTab.value
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13.sp,
                                            fontFamily: "DIN",
                                          ),
                                        ),
                                      ),
                                    ),
                                    14.horizontalSpace,
                                    InkWell(
                                      onTap: () => t.isAppTab.value = false,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: !t.isAppTab.value
                                              ? Colors.yellow
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 3.h),
                                        child: Text(
                                          "Store check-in".tr,
                                          style: TextStyle(
                                            color: !t.isAppTab.value
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13.sp,
                                            fontFamily: "DIN",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            10.verticalSpace,
                            signInfoWidget(),
                          ],
                        ),
                      ),
                      titleWidget(
                        leftText: "Task Center".tr,
                        marginLeft: 0,
                        marginRight: 0,
                        viewAllText: '',
                        taskCenterKey: t.taskCenterKey,
                      ),
                      Container(
                        height: 30.h,
                        margin: EdgeInsets.only(bottom: 14.h),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemBuilder: (c, i) => Obx(() => GestureDetector(
                                onTap: () => t.selectTaskCenterTab(i),
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 14.w),
                                  decoration: BoxDecoration(
                                    color: t.taskCenterIndex.value == i
                                        ? hexColor('#FFB20E')
                                        : hexColor('#212127'),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    t.taskCenterTab[i]["name"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                  ),
                                ),
                              )),
                          separatorBuilder: (c, i) => 10.horizontalSpace,
                          itemCount: t.taskCenterTab.length,
                        ),
                      ),
                      taskCenterWidget(),
                      titleWidget(
                        leftText: "Points Redemption".tr,
                        marginLeft: 0,
                        marginRight: 0,
                        onTap: () => Get.to(
                          () => IntegralRedemptionPage(),
                          arguments:
                              t.integralInfoModel.value.pointInfo?.pointsTotal,
                        ),
                      ),
                      Obx(() => GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 3 columns
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 15.0.w,
                              mainAxisSpacing: 15.0.h,
                            ),
                            itemBuilder: (context, index) =>
                                pointsRedemptionWidget(t.goods[index]),
                            itemCount: t.goods.length > 4 ? 4 : t.goods.length,
                          )),
                    ],
                  ),
                ),
              ),
      );

  Widget signInfoWidget() => Obx(() => t.isAppTab.value
      ? Row(
          children: [
            if (t.integralInfoModel.value.appSign.isNotEmpty)
              Expanded(
                child: weekCheckInWidget(t.integralInfoModel.value.appSign[0]),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.appSign.length > 1)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.appSign[1],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.appSign.length > 2)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.appSign[2],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.appSign.length > 3)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.appSign[3],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.appSign.length > 4)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.appSign[4],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.appSign.length > 5)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.appSign[5],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.appSign.length > 6)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.appSign[6],
                ),
              ),
          ],
        )
      : Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last week'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            Text(
                              t.integralInfoModel.value.webSign[0].state == 1
                                  ? 'checked in'.tr
                                  : 'not checked'.tr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14.sp,
                                fontFamily: 'DIN',
                              ),
                            ).paddingSymmetric(vertical: 4.h),
                            Text(
                              t.integralInfoModel.value.webSign.isNotEmpty
                                  ? '+${t.integralInfoModel.value.webSign[0].point}'
                                  : '+0',
                              style: TextStyle(
                                color: hexColor('#FFB20E'),
                                fontSize: 14.sp,
                                fontFamily: 'DIN',
                              ),
                            ),
                          ],
                        ),
                        t.integralInfoModel.value.webSign.isNotEmpty
                            ? Image.asset(
                                t.integralInfoModel.value.webSign[0].state == 1
                                    ? ImageUtils.integral_checkin_icon
                                    : ImageUtils.integral_checkin_grey_icon,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                ImageUtils.integral_store_check_yellow_icon,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              ),
                      ],
                    ),
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: Container(
                    width: 155.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          hexColor('#FFB20E').withOpacity(0.1),
                          hexColor('#5D61EC').withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: hexColor('#DFB93C'),
                        width: 1.w,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current week'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                ),
                              ),
                              Text(
                                t.integralInfoModel.value.webSign[1].state == 1
                                    ? 'checked in'.tr
                                    : 'not checked'.tr,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14.sp,
                                  fontFamily: 'DIN',
                                ),
                              ).paddingSymmetric(vertical: 4.h),
                              Text(
                                t.integralInfoModel.value.webSign.length > 1
                                    ? '+${t.integralInfoModel.value.webSign[1].point}'
                                    : '+0',
                                style: TextStyle(
                                  color: hexColor('#FFB20E'),
                                  fontSize: 14.sp,
                                  fontFamily: 'DIN',
                                ),
                              ),
                            ],
                          ),
                        ),
                        t.integralInfoModel.value.webSign.length > 1
                            ? Image.asset(
                                t.integralInfoModel.value.webSign[1].state == 1
                                    ? ImageUtils.integral_checkin_icon
                                    : ImageUtils.integral_checkin_grey_icon,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                ImageUtils.integral_store_check_yellow_icon,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Visit and log in to any PC station at any SideQuest store to check in'
                  .tr,
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12.sp,
                fontFamily: 'DIN',
                fontWeight: FontWeight.w400,
              ),
            ).paddingOnly(top: 10.h),
          ],
        ));

  Widget pointsRedemptionWidget(dynamic good) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Get.to(() => IntegralDetailPage(), arguments: good['id']),
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF202026),
              borderRadius: BorderRadius.circular(15.r)),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: '${good['picUrl']}',
                fit: BoxFit.cover,
                width: 106.w,
                height: 106.w,
              ),
              15.verticalSpace,
              Container(
                width: 1.sw,
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  '${good['name']}',
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
                        text: "${good['points']}\n",
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

  Widget taskCenterWidget() => Container(
        width: 1.sw,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF202026), Color(0xFF202026)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
        child: Obx(() => Column(
              children: [
                if (!t.showOrHideTaskCenter.value &&
                    t.integralTaskList.length <= 3)
                  lessTaskCenterWidget(),
                if (!t.showOrHideTaskCenter.value &&
                    t.integralTaskList.length > 3)
                  lessTaskCenterWidget(),
                if (t.showOrHideTaskCenter.value)
                  ...t.integralTaskList
                      .map((e) => commonTaskCenterWidget(e))
                      .toList(),
                if (t.showOrHideTaskCenter.value)
                  Obx(() => InkWell(
                        onTap: () => t.showOrHideTaskCenter.value =
                            !t.showOrHideTaskCenter.value,
                        child: Image.asset(
                          t.showOrHideTaskCenter.value
                              ? ImageUtils.order_less_icon
                              : ImageUtils.order_more_icon,
                          scale: 1.5,
                        ).marginOnly(bottom: 15.h),
                      )),
              ],
            )),
      );

  Widget commonTaskCenterWidget(IntegralTaskModel task) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Get.to(() => IntegralTaskDetailPage(), arguments: task.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: ShapeDecoration(
                    color: Color(0x19F097FF),
                    shape: OvalBorder(),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: CachedNetworkImage(
                        imageUrl: '${task.icon}',
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                        placeholder: (c, url) => Image.asset(
                          ImageUtils.default_logo,
                          width: 20.w,
                        ),
                        errorWidget: (c, c1, c2) =>
                            Image.asset(ImageUtils.default_logo),
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    '${task.taskName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Visibility(
                  visible:
                      task.nowTaskDetail?.myNum == task.nowTaskDetail?.maxNum,
                  child: Container(
                    width: 82.w,
                    height: 30.h,
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                    ),
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(1.00, 0.00),
                        end: Alignment(-1, 0),
                        colors: [Color(0xFF2C2E3B), Color(0xFF2C2E3B)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Completed'.tr,
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
            Container(
              margin: EdgeInsets.only(
                top: 9.h,
                left: 42.w,
                bottom: 4.h,
              ),
              child: FAProgressBar(
                size: 6.h,
                currentValue: (task.nowTaskDetail?.myNum ?? 0).toDouble(),
                maxValue: (task.nowTaskDetail?.maxNum ?? 100).toDouble(),
                progressGradient: LinearGradient(
                    colors: [hexColor('#FFB20E'), hexColor('#5D61EC')]),
                backgroundColor: hexColor('#45494B'),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 4.h,
                    left: 42.w,
                  ),
                  child: Image.asset(
                    ImageUtils.integral_checkin_icon,
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                3.horizontalSpace,
                Expanded(
                  child: Text(
                    'x${task.pointsNum}',
                    style: TextStyle(
                      color: hexColor('#FFB20E'),
                      fontSize: 14.sp,
                      fontFamily: 'DIN',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  '${(task.nowTaskDetail?.myNum ?? 0)}/${(task.nowTaskDetail?.maxNum ?? 100)}',
                  style: TextStyle(
                    color: hexColor('ffffff'),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: hexColor('#2C2E3B'),
              margin: EdgeInsets.only(top: 12.h),
            )
          ],
        ).marginOnly(bottom: 14.h),
      );

  Widget lessTaskCenterWidget() => Column(
        children: [
          if (t.integralTaskList.isEmpty)
            Image.asset(
              ImageUtils.empty,
              width: 43.w,
              height: 43.w,
            ).marginOnly(bottom: 15.h),
          if (t.integralTaskList.isNotEmpty)
            commonTaskCenterWidget(t.integralTaskList[0]),
          if (t.integralTaskList.length > 1)
            commonTaskCenterWidget(t.integralTaskList[1]),
          if (t.integralTaskList.length > 2)
            commonTaskCenterWidget(t.integralTaskList[2]),
          if (t.integralTaskList.length > 3)
            Obx(() => InkWell(
                  onTap: () => t.showOrHideTaskCenter.value =
                      !t.showOrHideTaskCenter.value,
                  child: Image.asset(
                    t.showOrHideTaskCenter.value
                        ? ImageUtils.order_less_icon
                        : ImageUtils.order_more_icon,
                    scale: 1.5,
                  ).marginOnly(bottom: 15.h),
                )),
        ],
      );

  Widget weekCheckInWidget(Sign model, {Function? onTap}) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => t.checkIn(),
        child: Column(
          children: [
            Container(
              width: 100.w,
              height: 70.h,
              margin: EdgeInsets.only(bottom: 6.h),
              decoration: BoxDecoration(
                color: Color(0xFF2C2C33),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1.w,
                ),
              ),
              child: GradientBorderWidget(
                colors: t.isToday(model)
                    ? null
                    : [Colors.transparent, Colors.transparent],
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'x${model.point}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'DIN',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    8.verticalSpace,
                    Image.asset(
                      t.getCheckInIcon(model),
                      width: 34.w,
                      height: 34.w,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '${model.day}',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12.sp,
                fontFamily: 'DIN',
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      );
}

Widget titleWidget({
  required String leftText,
  double marginTop = 20,
  double? marginLeft,
  double? marginRight,
  Function? onTap,
  String viewAllText = "View all",
  Key? taskCenterKey,
}) =>
    Container(
      key: taskCenterKey,
      margin: EdgeInsets.only(
        left: marginLeft ?? 15.w,
        right: marginRight ?? 15.w,
        top: marginTop,
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
          Text(
            leftText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: FONT_MEDIUM,
              color: Colors.white,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () => onTap?.call(),
            child: Text(
              viewAllText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: FONT_MEDIUM,
                color: hexColor("FFB20E"),
              ),
            ),
          ),
        ],
      ),
    );
