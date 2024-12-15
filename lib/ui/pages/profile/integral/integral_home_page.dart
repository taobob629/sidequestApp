import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/model/integral_info_model.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../image_utils.dart';
import '../../../../widget/progress_bar/animation_progress_bar.dart';
import '../task/task_page.dart';
import 'ctr/integral_home_ctr.dart';
import 'integral_detail_page.dart';
import 'integral_interests_page.dart';
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
                          Obx(() => ExtendedImage.network(
                                '${t.integralInfoModel.value.pointInfo?.memberPhoto}',
                                width: 40.w,
                                height: 40.w,
                                shape: BoxShape.circle,
                                fit: BoxFit.cover,
                                loadStateChanged: (ExtendedImageState state) {
                                  switch (state.extendedImageLoadState) {
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  onTap: () =>
                                      Get.to(() => IntegralRecordPage()),
                                  child: Row(
                                    children: [
                                      Obx(() => Text(
                                            'Points:${t.integralInfoModel.value.pointInfo?.pointsTotal}',
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
                          ),
                          Obx(() => GestureDetector(
                                onTap: () => Get.to(
                                  () => IntegralInterestsPage(),
                                  arguments: t.integralInfoModel.value.pointInfo
                                      ?.expGrade,
                                ),
                                child: Image.asset(
                                  'assets/images/integral_lv${t.integralInfoModel.value.pointInfo?.expGrade == 0 ? (t.integralInfoModel.value.pointInfo?.expGrade ?? 0) + 1 : t.integralInfoModel.value.pointInfo?.expGrade}_icon.webp',
                                  scale: 2,
                                ),
                              )),
                          15.horizontalSpace,
                        ],
                      ),
                      Obx(() => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => Get.to(
                              () => IntegralInterestsPage(),
                              arguments:
                                  t.integralInfoModel.value.pointInfo?.expGrade,
                            ),
                            child: Text(
                              'Need ${(t.integralInfoModel.value.pointInfo?.nextExperience ?? 0) - (t.integralInfoModel.value.pointInfo?.experience ?? 0)} xp to level up to Lv${(t.integralInfoModel.value.pointInfo?.expGrade ?? 0) + 1}.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontFamily: 'DIN',
                              ),
                            ),
                          )),
                      6.verticalSpace,
                      Obx(() => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => Get.to(
                              () => IntegralInterestsPage(),
                              arguments:
                                  t.integralInfoModel.value.pointInfo?.expGrade,
                            ),
                            child: SizedBox(
                              width: 200.w,
                              child: FAProgressBar(
                                size: 6.h,
                                currentValue: (t.integralInfoModel.value
                                            .pointInfo?.experience ??
                                        0) /
                                    (t.integralInfoModel.value.pointInfo
                                            ?.nextExperience ??
                                        0),
                                progressGradient: LinearGradient(colors: [
                                  hexColor('#FF760E'),
                                  hexColor('#FFB20E')
                                ]),
                                backgroundColor: hexColor('#45494B'),
                              ),
                            ),
                          )),
                      30.verticalSpace,
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
                                      onTap: () => Get.to(
                                        () => IntegralInterestsPage(),
                                        arguments: t.integralInfoModel.value
                                            .pointInfo?.expGrade,
                                      ),
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
                                            child: Text(
                                              'My Benefits'.tr,
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
                        padding: EdgeInsets.all(15.r),
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
                        leftText: "Task Center",
                        marginLeft: 0,
                        marginRight: 0,
                        onTap: () => Get.to(() => TaskPage())
                            ?.then((value) => UserController.find.updateInfo()),
                      ),
                      taskCenterWidget(),
                      titleWidget(
                        leftText: "Points Redemption",
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
      : Row(
          children: [
            if (t.integralInfoModel.value.webSign.isNotEmpty)
              Expanded(
                child: weekCheckInWidget(t.integralInfoModel.value.webSign[0]),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.webSign.length > 1)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.webSign[1],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.webSign.length > 2)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.webSign[2],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.webSign.length > 3)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.webSign[3],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.webSign.length > 4)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.webSign[4],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.webSign.length > 5)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.webSign[5],
                ),
              ),
            8.horizontalSpace,
            if (t.integralInfoModel.value.webSign.length > 6)
              Expanded(
                child: weekCheckInWidget(
                  t.integralInfoModel.value.webSign[6],
                ),
              ),
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
        padding: EdgeInsets.all(15.r),
        child: Obx(() => Column(
              children: [
                if (t.integralTaskModel.value.rows.isNotEmpty)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Get.to(() => IntegralTaskDetailPage(),
                        arguments: t.integralTaskModel.value.rows[0].id),
                    child: Row(
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
                                imageUrl:
                                    '${t.integralTaskModel.value.rows[0].icon}',
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
                            '${t.integralTaskModel.value.rows[0].description}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          height: 30.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 4.h,
                          ),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(1.00, 0.00),
                              end: Alignment(-1, 0),
                              colors: [Color(0xFFFF760E), Color(0xFFFFB20E)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 4.h),
                                child: Image.asset(
                                  ImageUtils.integral_checkin_icon,
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              ),
                              3.horizontalSpace,
                              Text(
                                'x${t.integralTaskModel.value.rows[0].pointsNum}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'DIN',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                if (t.integralTaskModel.value.rows.length > 1)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Get.to(() => IntegralTaskDetailPage(),
                        arguments: t.integralTaskModel.value.rows[1].id),
                    child: Container(
                      margin: EdgeInsets.only(top: 15.h),
                      child: Row(
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
                                  imageUrl:
                                      '${t.integralTaskModel.value.rows[1].icon}',
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
                              '${t.integralTaskModel.value.rows[1].description}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 4.h,
                            ),
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(1.00, 0.00),
                                end: Alignment(-1, 0),
                                colors: [Color(0xFFFF760E), Color(0xFFFFB20E)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 4.h),
                                  child: Image.asset(
                                    ImageUtils.integral_checkin_icon,
                                    width: 20.w,
                                    height: 20.w,
                                  ),
                                ),
                                3.horizontalSpace,
                                Text(
                                  'x${t.integralTaskModel.value.rows[1].pointsNum}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'DIN',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                if (t.integralTaskModel.value.rows.length > 2)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Get.to(() => IntegralTaskDetailPage(),
                        arguments: t.integralTaskModel.value.rows[2].id),
                    child: Container(
                      margin: EdgeInsets.only(top: 15.h),
                      child: Row(
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
                                  imageUrl:
                                      '${t.integralTaskModel.value.rows[2].icon}',
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
                              '${t.integralTaskModel.value.rows[2].description}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 4.h,
                            ),
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(1.00, 0.00),
                                end: Alignment(-1, 0),
                                colors: [Color(0xFFFF760E), Color(0xFFFFB20E)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 4.h),
                                  child: Image.asset(
                                    ImageUtils.integral_checkin_icon,
                                    width: 20.w,
                                    height: 20.w,
                                  ),
                                ),
                                3.horizontalSpace,
                                Text(
                                  'x${t.integralTaskModel.value.rows[2].pointsNum}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'DIN',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            )),
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
                  color: t.isSameDay(model.day)
                      ? hexColor('#FFB20E')
                      : Colors.transparent,
                  width: 1.w,
                ),
              ),
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
                    width: 28.w,
                    height: 28.w,
                  ),
                ],
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
}) =>
    Container(
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
