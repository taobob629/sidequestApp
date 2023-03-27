import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/base_scaffold.dart';

import '../../../image_utils.dart';
import '../../common/colorful_button.dart';
import '../view/tag/simple_tags.dart';
import 'controller.dart';

class SideKickMatchSucPage extends StatelessWidget {
  final _ctr = Get.put(SideKickMatchSucController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Sidekick Match',
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _matchingRequirementsWidget(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.w,
                      mainAxisSpacing: 15.h,
                      childAspectRatio: 0.6 / 1.0),
                  itemBuilder: (c, i) {
                    if (i < 2) {
                      return _itemWidget(i);
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xff262731),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: Color(0xffFFCB0E),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              margin: EdgeInsets.only(
                                left: 8.w,
                                right: 8.w,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0x99FFCB0E),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: Color(0x33FFCB0E),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemCount: 3,
                ),
              ),
            ),
            if (_ctr.showOrHide.value)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: ColorfulButton(
                  child: Text(
                    "Stop Matching".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "DIN",
                        fontSize: 18.sp),
                  ),
                  height: 40.h,
                  borderRadius: 20.r,
                ),
              ),
            Visibility(
              visible: _ctr.selectItemList.isNotEmpty,
              child: Container(
                color: Color(0xff1b1a1e),
                height: 96.h,
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(
                            color: Color(0xffF4C708),
                            width: 1.w,
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: TextStyle(
                            color: Color(0xffF4C708),
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ),
                    15.horizontalSpace,
                    Expanded(
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFD49C21), Color(0xFFE96524)],
                          ),
                        ),
                        child: Text(
                          'Play'.tr,
                          style: TextStyle(
                            color: Color(0xffF4C708),
                            fontSize: 14.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemWidget(int i) => Obx(
        () => GestureDetector(
          onTap: () => _ctr.selectItem(i),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff262731),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: _ctr.selectItemList.contains(i)
                        ? Border.all(color: Color(0xffF4C708), width: 1.w)
                        : Border.all(color: Colors.transparent, width: 1.w),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.r),
                            topLeft: Radius.circular(15.r),
                          ),
                          image: DecorationImage(
                              image: AssetImage('assets/images/bg_vip5.webp'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, top: 7.h),
                            child: Text(
                              'Name',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: FONT_MEDIUM),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 10.w,
                              top: 7.h,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 4.h,
                              horizontal: 7.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFF351BD),
                                  Color(0xFFFF1549),
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageUtils.iconSex1,
                                  width: 5.w,
                                  height: 7.h,
                                ),
                                3.horizontalSpace,
                                Text(
                                  '26',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.sp,
                                      fontFamily: FONT_MEDIUM,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 10.w,
                          top: 7.h,
                          bottom: 7.h,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              ImageUtils.score1,
                              width: 13.w,
                              height: 13.w,
                            ),
                            5.horizontalSpace,
                            Text(
                              '4.8',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            8.horizontalSpace,
                            Container(
                              width: 1.w,
                              height: 10.h,
                              color: Color(0xffc3c3c3),
                            ),
                            8.horizontalSpace,
                            Text(
                              'Diamond 2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10.w,
                            top: 7.h,
                            bottom: 7.h,
                          ),
                          child: SimpleTags(
                            content: [],
                            // content: _ctr.sideKickTypes,
                            wrapSpacing: 4.w,
                            wrapRunSpacing: 4.w,
                            onTagPress: null,
                            tagContainerPadding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 10.w),
                            tagTextStyle: TextStyle(
                                color: Color(0xffc3c3c3), fontSize: 11.sp),
                            tagSelectTextStyle: TextStyle(
                                color: Color(0xffc3c3c3), fontSize: 11.sp),
                            tagContainerDecoration: BoxDecoration(
                              color: Color(0xff313033),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            tagContainerSelectDecoration: BoxDecoration(
                              color: Color(0xff313033),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    margin: EdgeInsets.only(top: 10.w, right: 10.w),
                    decoration: _ctr.selectItemList.contains(i)
                        ? BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageUtils.iconYixuanzhe),
                            ),
                          )
                        : BoxDecoration(
                            border: Border.all(
                                color: Color(0xffc3c3c3), width: 1.w),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

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
            GestureDetector(
              onTap: _ctr.showOrHideWidget,
              behavior: HitTestBehavior.translucent,
              child: Row(
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
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    _ctr.showOrHide.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _ctr.showOrHide.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1.h,
                    color: Color(0xff2D2E3A),
                    margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
                  ),
                  _commonWidget('Categroy'.tr, 'PC'.tr),
                  20.verticalSpace,
                  _commonWidget('Game'.tr, 'League of Legends'.tr),
                  20.verticalSpace,
                  _commonWidget('Price Range'.tr, '10.00~ 20.00'.tr,
                      showIcon: true),
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
                    content: [],
                    wrapSpacing: 10.w,
                    wrapRunSpacing: 10.h,
                    onTagPress: null,
                    tagContainerPadding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                    tagTextStyle:
                        TextStyle(color: Color(0xffFFCB0E), fontSize: 14.sp),
                    tagContainerDecoration: BoxDecoration(
                      color: Color(0xff3a3627),
                      border:
                          Border.all(color: Color(0xffFFCB0E), width: 0.5.w),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    tagContainerSelectDecoration: BoxDecoration(
                      color: Color(0xff3a3627),
                      border:
                          Border.all(color: Color(0xffFFCB0E), width: 0.5.w),
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
                ],
              ),
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
