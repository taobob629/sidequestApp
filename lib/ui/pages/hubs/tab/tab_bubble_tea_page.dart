import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../../widget/image_util.dart';
import '../bubble_tea_detail_page.dart';
import '../confirm_order_page.dart';

class TabBubbleTeaPage extends StatelessWidget {
  final ctr = TabBubbleTeaCtr.find;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            InkWell(
              onTap: () => ctr.selectStore(),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => RichText(
                              text: TextSpan(
                                text: '${ctr.currentSelectStore.value.name}  ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: 'DIN',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                      size: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        6.verticalSpace,
                        RichText(
                          text: TextSpan(
                            text: "52m",
                            style: TextStyle(
                              color: const Color(0xFFFFB20E),
                              fontSize: 12.sp,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: " away from you",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12.sp,
                                  fontFamily: 'DIN',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    ImageUtils.bubble_tea_store_icon,
                    width: 52.w,
                    height: 38.h,
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            SizedBox(
              height: 160.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: ImageUtil.networkImage(
                    url: '{controller.headLineList[i].image}',
                    width: 134.w,
                    height: 160.h,
                    border: 8.r,
                    fit: BoxFit.cover,
                  ),
                ),
                separatorBuilder: (c, i) => 15.horizontalSpace,
                itemCount: 4,
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: Obx(() => Stack(
                    children: [
                      ListView.separated(
                        itemBuilder: (c, i) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () =>
                              Get.to(() => BubbleTeaDetailPage(), arguments: {
                            "id": ctr.teaList[i].id,
                            "index": i,
                          }),
                          child: Container(
                            height: 112.h,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF141517),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                16.horizontalSpace,
                                ImageUtil.networkImage(
                                  url: '${ctr.teaList[i].image}',
                                  width: 90.w,
                                  height: 90.h,
                                  fit: BoxFit.cover,
                                ),
                                10.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${ctr.teaList[i].name}',
                                        style: TextStyle(
                                          fontFamily: FONT_MEDIUM,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        ctr.teaList[i].brief ?? '',
                                        style: TextStyle(
                                          fontFamily: FONT_LIGHT,
                                          fontSize: 12.sp,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        '£ ${ctr.teaList[i].retailPrice}',
                                        style: TextStyle(
                                          color: const Color(0xFFFFB20E),
                                          fontSize: 16.sp,
                                          fontFamily: FONT_MEDIUM,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 10.w,
                                    top: 40.h,
                                  ),
                                  child: InkWell(
                                    onTap: () => ctr.addTea(i),
                                    child: Icon(
                                      Icons.add_circle_outline,
                                      color: hexColor('FFB20E'),
                                      size: 24.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (c, i) => 10.verticalSpace,
                        itemCount: ctr.teaList.length,
                      ),
                      Visibility(
                        visible: ctr.selectTeaList.isNotEmpty && ctr.isShowDrinkNow.value,
                        child: Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: drinkNowWidget(0),
                        ),
                      ),
                    ],
                  )),
            ),
            Builder(builder: (context) {
              ctr.cartContext = context;
              return SizedBox(height: 0.h,);
            }),
          ],
        ).paddingSymmetric(horizontal: 16.w),
      );

  Widget drinkNowWidget(double horizontal) => Container(
    height: 44.w,
    decoration: ShapeDecoration(
      color: hexColor('4C3608'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60.r),
      ),
    ),
    margin: EdgeInsets.symmetric(horizontal: horizontal),
    child: Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            ctr.isShowDrinkNow.value = false;
            SmartDialog.showAttach(
                targetContext: ctr.cartContext,
                usePenetrate: false,
                alignment: Alignment.topCenter,
                builder: (_) => cartWidget(),
                onDismiss: () => ctr.isShowDrinkNow.value = true
            );
          },
          child: badges.Badge(
            showBadge: ctr.selectTeaList.isNotEmpty,
            badgeContent: Text(
              '${ctr.selectTeaList.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            badgeColor: hexColor('FF4848'),
            position: badges.BadgePosition(top: -8.h),
            alignment: Alignment.topRight,
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: ShapeDecoration(
                color: hexColor('141517'),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.w,
                      color: hexColor('FFB20E')),
                  borderRadius:
                  BorderRadius.circular(60.r),
                ),
              ),
              child: Image.asset(
                ImageUtils.drink_now_icon,
                scale: 2,
              ),
            ),
          ),
        ),
        14.horizontalSpace,
        Text(
          '£${ctr.totalPrice.value}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: FONT_MEDIUM,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Center(
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
                      color:
                      Colors.white.withOpacity(0.6),
                      size: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => Get.to(() => ConfirmOrderPage()),
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
              'Drink Now',
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
  );

  Widget cartWidget() => Container(
        constraints: BoxConstraints(
          maxHeight: 300.h,
          minHeight: 100.h,
          minWidth: 1.sw,
        ),
        decoration: ShapeDecoration(
          color: hexColor('141517'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "${ctr.selectTeaList.length}  ",
                      style: TextStyle(
                        color: hexColor('FFB20E'),
                        fontSize: 14.sp,
                        fontFamily: 'DIN',
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'item in total',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14.sp,
                            fontFamily: 'DIN',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ).paddingOnly(left: 16.w),
                ),
                InkWell(
                  onTap: () => ctr.clearTea(),
                  child: Image.asset(ImageUtils.delete_icon),
                ),
                16.horizontalSpace,
              ],
            ),
            ctr.selectTeaList.length <= 3
                ? commonWidget(true)
                : Expanded(child: commonWidget(false)),
            drinkNowWidget(16.w),
          ],
        ),
      );

  Widget commonWidget(bool shrinkWrap) => Obx(() => ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: shrinkWrap,
        itemBuilder: (c, i) => Container(
          height: 70.h,
          child: Row(
            children: [
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${ctr.selectTeaList[i].name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Visibility(
                      visible: ctr.selectTeaList[i].brief != null,
                      child: Text(
                        '${ctr.selectTeaList[i].brief}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10.sp,
                          fontFamily: FONT_LIGHT,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '£ ${ctr.selectTeaList[i].retailPrice}',
                style: TextStyle(
                  color: Color(0xFFFFB20E),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ).paddingSymmetric(horizontal: 10.w),
              Obx(() => InkWell(
                onTap: () => ctr.minusMoney(i),
                child: Icon(
                  Icons.remove_circle_outline,
                  color: ctr.selectTeaList[i].count.value == 1
                      ? Colors.white.withOpacity(0.6)
                      : Colors.white,
                ),
              )),
              Obx(() => Text(
                    '${ctr.selectTeaList[i].count.value}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_LIGHT,
                      fontWeight: FontWeight.w600,
                    ),
                  ).paddingSymmetric(horizontal: 15.w)),
              InkWell(
                onTap: () => ctr.addMoney(i),
                child: Icon(
                  Icons.add_circle_outline,
                  color: hexColor('#FFB20E'),
                ),
              ),
              16.horizontalSpace,
            ],
          ),
        ),
        separatorBuilder: (c, i) => Container(
          height: 1.h,
          decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
        ),
        itemCount: ctr.selectTeaList.length,
      ));
}
