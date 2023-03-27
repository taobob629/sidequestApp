import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/base_scaffold.dart';

import '../../../image_utils.dart';
import '../../common/colorful_button.dart';
import '../view/sphere_rotation.dart';
import '../view/tag/simple_tags.dart';
import 'controller.dart';

class SideKickMatchingPage extends StatelessWidget {
  final _ctr = Get.put(SideKickMatchingController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: 'Sidekick Match',
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 280.w,
                margin: EdgeInsets.only(bottom: 20.h, top: 20.h),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        ImageUtils.picDengDaiHuaMian,
                        width: 280.w,
                        height: 280.w,
                      ),
                    ),
                    RotatingBallWidget(
                      marginX: 106,
                      marginY: 106,
                      seconds: 3,
                      imgSrc: ImageUtils.iconYuanBai,
                    ),
                    RotatingBallWidget(
                      marginX: 106,
                      marginY: 106,
                      seconds: 2,
                      imgSrc: ImageUtils.iconYuanFen,
                    ),
                    RotatingBallWidget(
                      marginX: 140,
                      marginY: 140,
                      seconds: 4,
                      imgSrc: ImageUtils.iconYuanLan,
                    ),
                    RotatingBallWidget(
                      marginX: 72,
                      marginY: 72,
                      seconds: 2,
                      imgSrc: ImageUtils.iconYuanLv,
                    ),
                    RotatingBallWidget(
                      marginX: 50,
                      marginY: 50,
                      seconds: 1,
                      imgSrc: ImageUtils.iconYuanLv02,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Waiting for ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: FONT_MEDIUM),
                  ),
                  Obx(
                    () => Text(
                      _ctr.countTime.value,
                      style: TextStyle(
                        color: Color(0xffFFCB0E),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ),
                ],
              ),
              _matchingRequirementsWidget(),
            ],
          ),
        ));
  }

  Widget _matchingRequirementsWidget() => Container(
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  ImageUtils.iconZhuansghi,
                  width: 17.w,
                  height: 17.w,
                ),
                10.horizontalSpace,
                Text(
                  'Matching Requirements'.tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: FONT_MEDIUM),
                )
              ],
            ),
            Container(
              height: 1.h,
              color: Color(0xff2D2E3A),
              margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
            ),
            _commonWidget('Categroy'.tr, 'pc'),
            20.verticalSpace,
            _commonWidget('Game'.tr, 'League of Legends'.tr),
            20.verticalSpace,
            _commonWidget('Price Range'.tr, '10.00~ 20.00'.tr, showIcon: true),
            20.verticalSpace,
            _commonWidget(
              'Unit'.tr,
              '/Game'.tr,
            ),
            20.verticalSpace,
            _commonWidget(
              'Language'.tr,
              'English,Français '.tr,
            ),
            20.verticalSpace,
            SimpleTags(
              content: _ctr.others,
              wrapSpacing: 10.w,
              wrapRunSpacing: 10.h,
              onTagPress: null,
              tagContainerPadding:
                  EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
              tagTextStyle:
                  TextStyle(color: Color(0xffFFCB0E), fontSize: 12.sp),
              tagSelectTextStyle:
                  TextStyle(color: Color(0xffFFCB0E), fontSize: 12.sp),
              tagContainerDecoration: BoxDecoration(
                color: Color(0xff3a3627),
                border: Border.all(color: Color(0xffFFCB0E), width: 0.5.w),
                borderRadius: BorderRadius.circular(20.r),
              ),
              tagContainerSelectDecoration: BoxDecoration(
                color: Color(0xff3a3627),
                border: Border.all(color: Color(0xffFFCB0E), width: 0.5.w),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            Container(
              height: 1.h,
              color: Color(0xff2D2E3A),
              margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
            ),
            Text(
              'I want the sound to cute',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: FONT_MEDIUM),
            ),
            20.verticalSpace,
            ColorfulButton(
              child: Text(
                "Stop Matching".tr,
                style: TextStyle(
                    color: Colors.white, fontFamily: "DIN", fontSize: 18.sp),
              ),
              height: 40.h,
              borderRadius: 20.r,
              onTap: () => _ctr.stopMatching(),
            ),
          ],
        ),
      );

  Widget _commonWidget(String leftStr, String rightStr,
          {bool showIcon = false}) =>
      Row(
        children: [
          Text(
            leftStr,
            style: TextStyle(
                color: Colors.white, fontSize: 14.sp, fontFamily: FONT_MEDIUM),
          ),
          Expanded(child: SizedBox()),
          if (showIcon)
            Image.asset(
              "assets/images/coin_red.webp",
              width: 15.w,
              height: 15.w,
            ),
          5.horizontalSpace,
          Text(
            rightStr,
            style: TextStyle(
                color: Colors.white, fontSize: 14.sp, fontFamily: FONT_MEDIUM),
          ),
        ],
      );
}
