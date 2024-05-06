/**
    author:mac
    创建日期:2022/9/22
    描述:
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../../common/dialog_selector.dart';
import '../../../../../common/floating_button.dart';
import '../../../../../common/paixs_fun.dart';
import '../../../../../config/icon_font.dart';
import '../../../../../model/price_range_model.dart';
import '../../../../../widget/another_xlider.dart';
import '../../../../../widget/paixs_widget.dart';
import '../../../../../widget/scaffold_widget.dart';
import '../../../../../widget/views.dart';
import '../../add/add_game_page.dart';
import 'controller.dart';

class SkillItemPage extends GetView<SkillItemPageController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('${Get.arguments['skillName']}'),
        actions: [
          if (Get.arguments['id'] != null)
            TextButton(
                onPressed: () => controller.delete(),
                child: Image.asset(ImageUtils.ic_delete2, width: 18))
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Obx(
            () => controller.skillModel == null
                ? buildLoad()
                : PWidget.column(items()),
          )),
      btnBar: FloatingButton(
        onTap: () => controller.addGame(),
        label: "CONFIRM".tr,
      ),
    );
  }

  items() {
    double priceRangeMax = controller.skillModel?.priceRangeMax ?? 0;
    double priceRangeMin = controller.skillModel?.priceRangeMin ?? 0;
    var value =
        (controller.price > priceRangeMax || controller.price < priceRangeMin)
            ? 0
            : controller.price;
    return [
      PWidget.boxh(16),
      itemBg(PWidget.row([
        PWidget.text('${'Service Name'.tr} :', [Colors.white]),
        PWidget.boxw(16),
        buildTFView(Get.context!,
            hintText: 'Please enter name'.tr,
            hintColor: Colors.white24,
            textColor: Colors.white,
            con: controller.teContent,
            isExp: true,
            maxLength: 20),
      ])),
      PWidget.boxh(10),
      itemBg(PWidget.row([
        PWidget.text('${'Rank'.tr} :', [Colors.white]),
        PWidget.boxw(16),
        PWidget.text('${controller.skillModel?.level}'.tr, [Colors.white]),
      ])),
      PWidget.boxh(10),
      itemBg(PWidget.row([
        PWidget.text('${'Price'.tr} :', [Colors.white]),
        Expanded(
            child: PriceSlider(
                min: controller.skillModel?.priceRangeMin?.toDouble() ?? 0,
                max: controller.skillModel?.priceRangeMax?.toDouble() ?? 0,
                value: (controller.price > priceRangeMax ||
                        controller.price < priceRangeMin)
                    ? priceRangeMin
                    : controller.price,
                fun: (v) => controller.price = v)),
        Text(
          '${controller.skillModel?.unit}',
          style: TextStyle(fontFamily: FONT_LIGHT, fontSize: 12.sp),
        )
      ])),
      PWidget.boxh(10),
      itemBg(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        PWidget.text('${'Status'.tr} :', [Colors.white]),
        CupertinoSwitch(
          activeColor: Colors.green,
          value: controller.status,
          onChanged: (bool value) {
            controller.status = value;
          },
        )
        //  fun: (v) => priceRangeCon.text = '${v.toInt()}',
      ])),
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
    ];
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
                  'Discount',
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
                                items: controller.discountList,
                                title: "Discount".tr),
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
                                items: controller.orderFreeList,
                                title: "Discount".tr),
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
                                items: controller.xAndYList,
                                title: "Buy X".tr),
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
                  'Free Y'.tr,
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
                                items: controller.xAndYList,
                                title: "Free Y".tr),
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

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 45, Color(0xFF2D2E3C)],
        {'br': 10.r, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }
}

// 价格滑块
class PriceSlider extends GetView<SkillItemPageController> {
  PriceRangeModel? model;
  int index = 0;
  final double? max;
  final double? min;
  double value;
  RxDouble _price = RxDouble(0);

  double get price => _price.value;

  set price(double value) {
    _price.value = value;
  }

  final Function(double)? fun;

  PriceSlider(
      {this.max,
      this.min,
      this.fun,
      this.value = 0,
      this.model,
      this.index = 0}) {
    this.price = value;
  }

  var textColor = Color(0xFFB2B9C9);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    textController.addListener(() {
      model?.name = textController.text;
    });
    textController.text = model?.name ?? '';
    return Obx(() => FlutterSlider(
          values: [price],
          max: max!,
          min: min!,
          handlerWidth: 40.w,
          trackBar: FlutterSliderTrackBar(
            inactiveTrackBar: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(8)),
            activeTrackBar: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
          ),
          tooltip: FlutterSliderTooltip(
            positionOffset: FlutterSliderTooltipPositionOffset(top: -16),
            custom: (v) => PWidget.container(
              PWidget.row([
                Image.asset("assets/images/ic_balance_money.webp",
                    width: 16, height: 16),
                PWidget.boxw(4),
                PWidget.text('${double.parse('$v').toInt()}'),
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
              padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2).r,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
              child: Text(
                '${price.toInt()}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.75), fontSize: 12.sp),
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
            fun?.call(v1);
            price = v1;
            // model?.curPrice = price;
          },
          //    onDragCompleted: (i, v1, v2) => price = v1,
        ));
  }
}
