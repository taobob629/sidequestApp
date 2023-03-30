import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/res/dimens.dart';

import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../common/colorful_button.dart';
import '../view/tag/simple_tags.dart';
import 'controller.dart';

class SideKickMatchPage extends StatelessWidget {
  final _ctr = Get.put(SideKickMatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.background,
          elevation: 0,
          title: Text(
            'Sidekick Match'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontFamily: FONT_MEDIUM,
              color: Colors.white,
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: KeyboardVisibilityBuilder(
            builder: (c, bool isKeyboardVisible) => SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: contentPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category'.tr,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () => _ctr.selectItem('Category'),
                          child: Container(
                            margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
                            height: 45.h,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: Color(0xff313033),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)).w,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => Text(
                                      _ctr.category.value,
                                      style: TextStyle(
                                          color: Color(0xffB2B9C9),
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Game'.tr,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () => _ctr.selectItem('Game'),
                          child: Container(
                            margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
                            height: 45.h,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: Color(0xff313033),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)).w,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => Text(
                                      _ctr.game.value,
                                      style: TextStyle(
                                        color: Color(0xffB2B9C9),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Price Range'.tr,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
                                height: 45.h,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                decoration: BoxDecoration(
                                  color: Color(0xff313033),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)).w,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/coin_red.webp",
                                      width: 15.w,
                                      height: 15.w,
                                    ),
                                    8.horizontalSpace,
                                    Expanded(
                                      child: TextField(
                                        controller: _ctr.minPriceCtr,
                                        style: TextStyle(
                                          color: Color(0xffB2B9C9),
                                          fontSize: 14.sp,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'min price'.tr,

                                          /// 让文字垂直居中
                                          isCollapsed: true,
                                          hintStyle: TextStyle(
                                              color: Color(0xffb2b9c9),
                                              fontSize: 14.sp),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 11.w,
                              height: 3.h,
                              margin: EdgeInsets.only(
                                  top: 6.h,
                                  bottom: 20.h,
                                  left: 7.w,
                                  right: 7.w),
                              color: Color(0xffb2b9c9),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
                                height: 45.h,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                decoration: BoxDecoration(
                                  color: Color(0xff313033),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)).w,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/coin_red.webp",
                                      width: 15.w,
                                      height: 15.w,
                                    ),
                                    8.horizontalSpace,
                                    Expanded(
                                      child: TextField(
                                        controller: _ctr.maxPriceCtr,
                                        style: TextStyle(
                                          color: Color(0xffB2B9C9),
                                          fontSize: 14.sp,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'max price'.tr,

                                          /// 让文字垂直居中
                                          isCollapsed: true,
                                          hintStyle: TextStyle(
                                              color: Color(0xffb2b9c9),
                                              fontSize: 14.sp),
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Unit'.tr,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () => _ctr.selectItem('Unit'),
                          child: Container(
                            margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
                            height: 45.h,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: Color(0xff313033),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)).w,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => Text(
                                      _ctr.unit.value,
                                      style: TextStyle(
                                          color: Color(0xffB2B9C9),
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Language'.tr,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        GestureDetector(
                          onTap: () => _ctr.selectItem('Language'),
                          child: Container(
                            margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
                            height: 45.h,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: Color(0xff313033),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)).w,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _ctr.selectLanguage(),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Quantity'.tr,
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6.h, bottom: 20.h),
                          height: 45.h,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: Color(0xff313033),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)).w,
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _ctr.quantityCtr,
                            style: TextStyle(
                              color: Color(0xffB2B9C9),
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // 让文字垂直居中
                              isCollapsed: true,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        _sideKickTypesWidget(),
                        20.verticalSpace,
                        _additionalRequestWidget(),
                        20.verticalSpace,
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          child: ColorfulButton(
                            child: Text(
                              "Send".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "DIN",
                                  fontSize: 18.sp),
                            ),
                            height: 40.h,
                            borderRadius: 20.r,
                            onTap: _ctr.matching,
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }

  Widget _sideKickTypesWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Sidekick Types '.tr,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
              Text(
                '(Optional)'.tr,
                style: TextStyle(color: Color(0x80ffffff), fontSize: 16.sp),
              ),
            ],
          ),
          6.verticalSpace,
          Obx(
            () => Visibility(
              visible: _ctr.others.value.isNotEmpty,
              child: SimpleTags(
                content: _ctr.others.value,
                wrapSpacing: 10.w,
                wrapRunSpacing: 12.h,
                onTagPress: (tag) => _ctr.selectSideKickTypes(tag),
                tagContainerPadding:
                    EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                tagTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                tagSelectTextStyle:
                    TextStyle(color: Color(0xffFFCB0E), fontSize: 14.sp),
                tagContainerDecoration: BoxDecoration(
                  color: Color(0xff313033),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                tagContainerSelectDecoration: BoxDecoration(
                  color: Color(0xff3a3627),
                  border: Border.all(color: Color(0xffFFCB0E), width: 0.5.w),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _additionalRequestWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Additional Requests '.tr,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
              Text(
                '(Optional)'.tr,
                style: TextStyle(color: Color(0x80ffffff), fontSize: 16.sp),
              ),
            ],
          ),
          6.verticalSpace,
          Container(
            margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
            padding: EdgeInsets.all(13.w),
            decoration: BoxDecoration(
              color: Color(0xff313033),
              borderRadius: BorderRadius.all(Radius.circular(8)).w,
            ),
            child: TextField(
              controller: _ctr.requestsPriceCtr,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Service, Ranking, roles etc.'.tr,
                hintStyle: TextStyle(color: Color(0xffb2b9c9), fontSize: 14.sp),
                helperStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
                labelStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              maxLength: 50,
              maxLines: 3,
              minLines: 3,
            ),
          )
        ],
      );
}
