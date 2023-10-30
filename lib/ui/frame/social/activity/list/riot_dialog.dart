import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../config/icon_font.dart';
import '../../../../../image_utils.dart';
import '../../../../addgame/add_game_account_ctr.dart';

class RiotDialog extends StatelessWidget {
  final ctr = Get.put(AddGameAccountCtr());

  @override
  Widget build(BuildContext context) {
    ctr.selectIndex.value = -1;
    ctr.requestData();

    return Container(
      height: 0.5.sh,
      decoration: BoxDecoration(
        color: Color(0xff262731),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 20.h,
            ),
            child: Row(
              children: [
                Image.asset(
                  ImageUtils.icon_jiangbei,
                  width: 22.w,
                  height: 22.w,
                ),
                6.horizontalSpace,
                Text(
                  'Join Tournament'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 44.w,
              right: 20.w,
            ),
            child: Text(
              'You need to complete these steps to Join Tournament.'.tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: FONT_LIGHT,
                color: Colors.grey,
              ),
            ),
          ),
          Obx(
            () => ctr.list.isNotEmpty ? _accountWidget() : _noAccountWidget(),
          ),
          Obx(() => Visibility(
            visible: ctr.list.isNotEmpty,
            child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: ctr.jumpWeb,
            child: Container(
              width: 1.sw - 40.w,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h,
              ),
              margin: EdgeInsets.only(top: 30.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: Color(0xff5C5E69),
                  width: 1.w,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: Color(0xff36384A),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  6.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connect another Riot account'.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: FONT_MEDIUM,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'You need to complete these steps to Join Tournament.'
                              .tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: FONT_LIGHT,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),)),
        ],
      ),
    );
  }

  Widget _noAccountWidget() => Container(
        width: 1.sw - 40.w,
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 40.h,
        ),
        decoration: BoxDecoration(
          color: Color(0xff2C2D3A),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Summoner'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            6.verticalSpace,
            Text(
              "You haven't bound an account yet".tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: FONT_LIGHT,
                color: Colors.grey,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: ctr.jumpWeb,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
                margin: EdgeInsets.only(top: 30.h),
                decoration: BoxDecoration(
                  color: Color(0xffD1363A),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageUtils.icon_quantou,
                      width: 22.w,
                      height: 22.w,
                    ),
                    6.horizontalSpace,
                    Text(
                      'ADD SUMMONER'.tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: FONT_MEDIUM,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _accountWidget() => Container(
        width: 1.sw - 40.w,
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        decoration: BoxDecoration(
          color: Color(0xff2C2D3A),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a summoner'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "You haven't bound an account yet".tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: FONT_LIGHT,
                color: Colors.grey,
              ),
            ),
            Container(
              height: 100.h,
              margin: EdgeInsets.only(top: 10.h),
              child: Obx(() => ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (c, i) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => ctr.selectAccount(i),
                      child: Obx(() => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: ctr.selectIndex.value == i
                                ? Color(0xff76B69E)
                                : Color(0xff5C5E69),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30.w,
                              height: 30.w,
                              margin: EdgeInsets.only(right: 6.w),
                              decoration: BoxDecoration(
                                color: Color(0xffD1363A),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Image.asset(
                                ImageUtils.icon_quantou,
                                scale: 4.0,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${ctr.list[i].lolName}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: FONT_MEDIUM,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: ctr.selectIndex.value == i,
                              child: Image.asset(
                                ImageUtils.icon_xuanze,
                                scale: 3.6,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                    separatorBuilder: (c, i) => 10.verticalSpace,
                    itemCount: ctr.list.length,
                  )),
            ),
          ],
        ),
      );
}
