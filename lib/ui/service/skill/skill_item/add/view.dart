/**
    author:mac
    创建日期:2023/3/24
    描述:
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/ui/service/add/add_game_page.dart';
import 'package:wy/widget/another_xlider.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/views.dart';

import '../../../../common/dialog_selector.dart';
import 'controller.dart';

class SkillItemAddPage extends GetView<SkillItemAddPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments['skillName']}'),
      ),
      body: Obx(
          () => controller.priceRanges.isEmpty ? buildLoad() : _buildBody()),
      bottomNavigationBar: FloatingButton(
        label: 'Confirm'.tr,
        onTap: () => controller.onConfirm(),
      ),
    );
  }

  _buildBody() {
    return Container(
      padding: itemPadding10,
      child: Column(
        children: [
          Obx(() => InputView(
                maxLength: 15,
                inputLable: Container(
                  width: 60.w,
                  padding: EdgeInsets.only(right: 10.w),
                  child: Text(
                    'Name'.tr,
                    style: TextStyle(fontSize: 12.sp, fontFamily: FONT_LIGHT),
                  ),
                ),
                decoration:
                    itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
                controller: controller.teContent,
                label: 'ServiceType'.tr + ' / ${controller.priceRange?.unit}',
                tips: 'Please input service name'.tr,
                margin: EdgeInsets.only(top: 2).h,
                padding: EdgeInsets.only(bottom: 8.h),
                height: 45.h,
              )),
          5.verticalSpace,
          Container(
            height: 45.h,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // innnerBg(
                //
                // ),
                Container(
                  width: 60.w,
                  child: Text(
                    'Price'.tr,
                    style: TextStyle(fontSize: 12.sp, fontFamily: FONT_LIGHT),
                  ),
                ),
                Expanded(
                    child: Container(
                        decoration: itemDecoration(
                            color: Color(0xFF2D2E3C), radius: 10.r),
                        child: Obx(() => FlutterSlider(
                              values: [controller.price],
                              max: controller.priceRange?.gameCoinMax!,
                              min: controller.priceRange?.gameCoinMin!,
                              handlerWidth: 40.w,
                              trackBar: FlutterSliderTrackBar(
                                inactiveTrackBar: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(8)),
                                activeTrackBar: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              tooltip: FlutterSliderTooltip(
                                positionOffset:
                                    FlutterSliderTooltipPositionOffset(
                                        top: -16),
                                custom: (v) => PWidget.container(
                                  PWidget.row([
                                    Image.asset(
                                        "assets/images/ic_balance_money.webp",
                                        width: 16,
                                        height: 16),
                                    PWidget.boxw(4),
                                    PWidget.text(
                                        '${double.parse('$v').toInt()}'),
                                    PWidget.boxw(4),
                                    PWidget.text(
                                        '(£${(double.parse('$v') / 6.0).toStringAsFixed(2)})'),
                                  ]),
                                  [null, null, Colors.white],
                                  {'pd': PFun.lg(4, 4, 8, 8), 'br': 56},
                                ),
                              ),
                              handler: FlutterSliderHandler(
                                child: Container(
                                  padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 2, bottom: 2)
                                      .r,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white),
                                  child: Text(
                                    '${controller.price.toInt()}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.75),
                                        fontSize: 12.sp),
                                  ),
                                ),
                                foregroundDecoration: BoxDecoration(),
                                decoration: BoxDecoration(),
                              ),
                              handlerAnimation: FlutterSliderHandlerAnimation(
                                  curve: Curves.elasticOut,
                                  reverseCurve: Curves.elasticIn,
                                  duration: Duration(milliseconds: 250)),
                              onDragging: (i, v1, v2) {
                                controller.price = v1;
                                controller.priceRange?.curPrice =
                                    controller.price;
                              },
                              //    onDragCompleted: (i, v1, v2) => price = v1,
                            )))),
                10.horizontalSpace,
                Container(
                  height: 45.h,
                  // width: 50.w,
                  constraints: BoxConstraints(minWidth: 100.w),
                  decoration: innerDecoration(),
                  alignment: Alignment.center,
                  padding: itemPadding(),
                  child: dropDownButton(controller.priceRange?.unit),
                )
              ],
            ),
          ),
          15.verticalSpace,
          Row(
            children: [
              Text(
                'Promotion Setting'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: controller.promotionSwitch.value,
                  onChanged: (value) => controller.promotionSwitch.value =
                  !controller.promotionSwitch.value,
                ),
              ),
            ],
          ),
          if (controller.promotionSwitch.value) _discountWidget(),
        ],
      ),
    );
  }

  Widget _discountWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.dialog(
                      SelectorDialog(
                          items: controller.promotionList, title: "Choose a promotion".tr),
                      barrierColor: Colors.black26)
                  .then((value) {
                if (value != null) {
                  controller.currentPromotion.value = value;
                }
              });
            },
            child: Container(
              height: 46.h,
              decoration: innerDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              margin: EdgeInsets.symmetric(vertical: 15.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.currentPromotion.value.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ],
              ),
            ),
          ),
          if (controller.currentPromotion.value.id == 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discount'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.dialog(
                        SelectorDialog(
                            items: controller.discountList, title: "Discount".tr),
                        barrierColor: Colors.black26)
                        .then((value) {
                      if (value != null) {
                        controller.currentDiscount.value = value;
                      }
                    });
                  },
                  child: Container(
                    height: 46.h,
                    decoration: innerDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    margin: EdgeInsets.only(top: 6.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.currentDiscount.value.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (controller.currentPromotion.value.id == 1)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1st Order Discount'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.dialog(
                        SelectorDialog(
                            items: controller.orderFreeList, title: "Discount".tr),
                        barrierColor: Colors.black26)
                        .then((value) {
                      if (value != null) {
                        controller.currentOrderFree.value = value;
                      }
                    });
                  },
                  child: Container(
                    height: 46.h,
                    decoration: innerDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    margin: EdgeInsets.only(top: 6.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.currentOrderFree.value.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (controller.currentPromotion.value.id == 2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buy X'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.dialog(
                        SelectorDialog(
                            items: controller.xAndYList, title: "Buy X".tr),
                        barrierColor: Colors.black26)
                        .then((value) {
                      if (value != null) {
                        controller.currentBuyX.value = value;
                      }
                    });
                  },
                  child: Container(
                    height: 46.h,
                    decoration: innerDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    margin: EdgeInsets.only(top: 6.h, bottom: 15.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.currentBuyX.value.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Get Y',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.dialog(
                        SelectorDialog(
                            items: controller.xAndYList, title: "Free Y".tr),
                        barrierColor: Colors.black26)
                        .then((value) {
                      if (value != null) {
                        controller.currentGetY.value = value;
                      }
                    });
                  },
                  child: Container(
                    height: 46.h,
                    decoration: innerDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    margin: EdgeInsets.only(top: 6.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.currentGetY.value.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      );

  var textColor = Color(0xFFB2B9C9);

  dropDownButton(var init) {
    return Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<PriceRangeModel>(
            borderRadius: BorderRadius.all(Radius.circular(10)).r,
            dropdownColor: AppColor.dropDownBtBg,
            value: controller.priceRange,
            items: controller.priceRanges
                .map((item) => DropdownMenuItem<PriceRangeModel>(
                      value: item,
                      child: Text(
                        '${item.unit}',
                        style: TextStyle(color: textColor),
                      ),
                    ))
                .toList(),
            onChanged: (item) {
              controller.onTypeChange(item);
              //   controller.onPriceUnitChange(index, item!);
            })));
  }
}
