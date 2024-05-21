import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../config/icon_font.dart';
import '../../../getx_ctr/bubble_tea_detail_ctr.dart';
import '../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../utils/toast_utils.dart';
import '../../../widget/tag/simple_tags.dart';
import '../../../widget/tag/tag_bean.dart';
import 'bubble_confirm_order_page.dart';

class BubbleTeaDetailPage extends StatelessWidget {
  final ctr = Get.put(BubbleTeaDetailCtr());

  @override
  Widget build(BuildContext context) => Container(
        width: 1.sw,
        height: 1.sh,
        padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
        child: Obx(() => Stack(
              children: [
                Container(
                  width: 1.sw,
                  height: 274.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF0A0A0A), Color(0xFF2B221C)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: ImageUtil.networkImage(
                          url: "${ctr.model.value.image}",
                          width: 165.w,
                          height: 165.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.back(),
                        child: Container(
                          width: 34.w,
                          height: 34.w,
                          margin: EdgeInsets.only(left: 16.w),
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 260.h,
                  bottom: 60.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 1.sw,
                    decoration: ShapeDecoration(
                      color: hexColor('0A0A0A'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctr.model.value.name ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'DIN',
                            fontWeight: FontWeight.w600,
                          ),
                        ).paddingOnly(left: 16.w, top: 20.h),
                        Visibility(
                          visible: ctr.model.value.brief != null,
                          child: Text(
                            ctr.model.value.brief ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13.sp,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w400,
                            ),
                          ).paddingOnly(left: 16.w, top: 16.h),
                        ),
                        20.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingOnly(left: 16.w),
                            ),
                            Text(
                              '£${ctr.totalMoney.value}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w600,
                              ),
                            ).paddingOnly(right: 16.w),
                          ],
                        ),
                        6.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Quantity',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).paddingOnly(left: 16.w),
                            ),
                            Obx(() => !ctr.showAddToCart.value
                                ? qualityWidget()
                                : InkWell(
                                    onTap: () => ctr.addToCart(),
                                    child: Container(
                                      width: 100.w,
                                      height: 34.w,
                                      decoration: ShapeDecoration(
                                        color: hexColor('FFB20E'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Add To Cart',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontFamily: FONT_MEDIUM,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )),
                            16.horizontalSpace,
                          ],
                        ),
                        paramsWidget(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: addToCartWidget(16.w),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Builder(builder: (context) {
                    ctr.cartContext = context;
                    return 0.verticalSpace;
                  }),
                ),
              ],
            )),
      );

  Widget paramsWidget() => Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ctr.sizeTags.isNotEmpty)
                commonWidget(
                  title: "Size",
                  selectSize: 1,
                  tagList: ctr.sizeTags,
                  isDefaultSelectFirst: true,
                  defaultSelect: [ctr.model.value.selectSize],
                  onTagPress: (tagBean, isAdd) =>
                      ctr.selectSize(tagBean, isAdd),
                ),
              if (ctr.iceTags.isNotEmpty)
                commonWidget(
                  title: "Ice Level",
                  selectSize: 1,
                  isDefaultSelectFirst: true,
                  tagList: ctr.iceTags,
                  defaultSelect: [ctr.model.value.selectIce],
                  onTagPress: (tagBean, isAdd) => ctr.selectIce(tagBean, isAdd),
                ),
              if (ctr.sugarTags.isNotEmpty)
                commonWidget(
                  title: "Sugar",
                  selectSize: 1,
                  isDefaultSelectFirst: true,
                  tagList: ctr.sugarTags,
                  defaultSelect: [ctr.model.value.selectSugar],
                  onTagPress: (tagBean, isAdd) =>
                      ctr.selectSugar(tagBean, isAdd),
                ),
              if (ctr.toppingTags.isNotEmpty)
                commonWidget(
                  title: "Toppings",
                  selectSize: 2,
                  isDefaultSelectFirst: true,
                  tagList: ctr.toppingTags,
                  defaultSelect: ctr.model.value.selectTopping,
                  onTagPress: (tagBean, isAdd) =>
                      ctr.selectToppings(tagBean, isAdd),
                ),
            ],
          ),
        ),
      );

  Widget commonWidget({
    required String title,
    required int selectSize,
    required bool isDefaultSelectFirst,
    required List<TagBean> tagList,
    required List<TagBean?> defaultSelect,
    required Function(TagBean, bool isAdd) onTagPress,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: FONT_MEDIUM,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(left: 16.w, top: 24.h),
          SimpleTags(
            content: tagList,
            selectSize: selectSize,
            defaultSelect: defaultSelect,
            wrapSpacing: 10.w,
            wrapRunSpacing: 10.h,
            onTagPress: (TagBean tagBean, bool isAdd) =>
                onTagPress(tagBean, isAdd),
            tagContainerPadding: EdgeInsets.symmetric(
              vertical: 6.h,
              horizontal: 15.w,
            ),
            tagTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            tagSelectTextStyle: TextStyle(
              color: Color(0xffFFCB0E),
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            tagContainerDecoration: BoxDecoration(
              color: Color(0xFF141414),
              border: Border.all(
                color: Color(0xFF2F2F2F),
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            tagContainerSelectDecoration: BoxDecoration(
              color: Color(0xff3a3627),
              border: Border.all(
                color: Color(0xffFFCB0E),
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ).paddingOnly(left: 16.w, top: 10.h, right: 16.w),
        ],
      );

  Widget addToCartWidget(double horizontal) => Container(
        width: 1.sw,
        height: 60.h,
        decoration: ShapeDecoration(
          color: hexColor('141517'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: horizontal),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                TabBubbleTeaCtr.find.isShowDrinkNow.value = false;
                if (TabBubbleTeaCtr.find.isShowCartDialog) {
                  dismissLoading();
                } else {
                  if (TabBubbleTeaCtr.find.selectTeaList.isNotEmpty) {
                    TabBubbleTeaCtr.find.isShowCartDialog = true;
                    SmartDialog.showAttach(
                      targetContext: ctr.cartContext,
                      usePenetrate: false,
                      alignment: Alignment.topCenter,
                      builder: (_) => cartWidget(),
                      onDismiss: () {
                        TabBubbleTeaCtr.find.isShowDrinkNow.value = true;
                        TabBubbleTeaCtr.find.isShowCartDialog = false;
                      },
                    );
                  }
                }
              },
              child: Obx(() => badges.Badge(
                    showBadge: TabBubbleTeaCtr.find.totalCount > 0,
                    badgeContent: Text(
                      '${TabBubbleTeaCtr.find.totalCount.value}',
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
                          side:
                              BorderSide(width: 1.w, color: hexColor('FFB20E')),
                          borderRadius: BorderRadius.circular(60.r),
                        ),
                      ),
                      child: Image.asset(
                        ImageUtils.drink_now_icon,
                        scale: 2,
                      ),
                    ),
                  )),
            ),
            14.horizontalSpace,
            Expanded(
              child: Obx(() => Text(
                    '£${TabBubbleTeaCtr.find.totalPrice.value}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
            Obx(() => InkWell(
                  onTap: () => TabBubbleTeaCtr.find.selectTeaList.isNotEmpty
                      ? ctr.drinkNow()
                      : null,
                  child: Container(
                    width: 100.w,
                    height: 44.w,
                    decoration: ShapeDecoration(
                      color: TabBubbleTeaCtr.find.selectTeaList.isNotEmpty
                          ? hexColor('FFB20E')
                          : hexColor('CCCCCC'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
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
                )),
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
                  child: Obx(() => RichText(
                        text: TextSpan(
                          text:
                              "${TabBubbleTeaCtr.find.selectTeaList.length}  ",
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
                      ).paddingOnly(left: 16.w)),
                ),
                InkWell(
                  onTap: () => ctr.clearCart(),
                  child: Image.asset(ImageUtils.delete_icon),
                ),
                16.horizontalSpace,
              ],
            ),
            TabBubbleTeaCtr.find.selectTeaList.length <= 3
                ? Expanded(child: cartListWidget(true))
                : Expanded(child: cartListWidget(false)),
            addToCartWidget(16.w),
          ],
        ),
      );

  Widget cartListWidget(bool shrinkWrap) => Obx(() => ListView.separated(
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
                      '${TabBubbleTeaCtr.find.selectTeaList[i].name}',
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
                      visible:
                          TabBubbleTeaCtr.find.selectTeaList[i].brief != null,
                      child: Text(
                        '${TabBubbleTeaCtr.find.selectTeaList[i].brief}',
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
                '£ ${TabBubbleTeaCtr.find.getPrice(i)}',
                style: TextStyle(
                  color: Color(0xFFFFB20E),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w600,
                ),
              ).paddingSymmetric(horizontal: 10.w),
              InkWell(
                onTap: () => TabBubbleTeaCtr.find.minusMoney(i),
                child: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                ),
              ),
              Obx(() => Text(
                    '${TabBubbleTeaCtr.find.selectTeaList[i].count}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_LIGHT,
                      fontWeight: FontWeight.w600,
                    ),
                  ).paddingSymmetric(horizontal: 15.w)),
              InkWell(
                onTap: () => TabBubbleTeaCtr.find.addMoney(i),
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
        itemCount: TabBubbleTeaCtr.find.selectTeaList.length,
      ));

  Widget qualityWidget() => SizedBox(
        height: 34.h,
        child: Row(
          children: [
            InkWell(
              onTap: () => ctr.minusMoney(),
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.white,
              ),
            ),
            Obx(() => Text(
                  '${ctr.model.value.count}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: FONT_LIGHT,
                    fontWeight: FontWeight.w600,
                  ),
                ).paddingSymmetric(horizontal: 15.w)),
            InkWell(
              onTap: () => ctr.addMoney(),
              child: Icon(
                Icons.add_circle_outline,
                color: hexColor('#FFB20E'),
              ),
            ),
          ],
        ),
      );
}
