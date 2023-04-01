/**
    author:mac
    创建日期:2023/3/9
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/model/price_range_model.dart';
import 'package:wy/res/dimens.dart';
import 'package:wy/res/styles.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/another_xlider.dart';
import 'package:wy/widget/paixs_widget.dart';

import '../add_game_page.dart';
import '../controller.dart';

class PriceSliderWidget extends GetView<AddGamePageController> {
  bool showLable = false;
  bool showAdd = false;

  PriceSliderWidget({this.showLable = true, this.showAdd = true});

  Widget itemLable(var lable) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10).h,
      child: Text(
        "$lable",
        style: PageStyle.labelStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context!,
        child: Obx(() => ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  showLable ? controller.mPriceRanges.length + 1 : controller.mPriceRanges.length,
              itemBuilder: (BuildContext context, int index) {
                if (showLable && index == 0) {
                  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    itemLable('Price'.tr),
                    Visibility(
                      visible: showLable,
                      child: InkWell(
                          onTap: () {
                            controller.toAddServiceTypePage();
                          },
                          child: Text(
                            'Edit'.tr,
                            style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          )),
                    )
                  ]);
                }
                var item = controller.mPriceRanges[showLable ? index - 1 : index];
                return PriceSlider(
                  min: item.gameCoinMin,
                  max: item.gameCoinMax,
                  value: item.curPrice == 0 ? item.gameCoinMin : item.curPrice,
                  index: showLable ? index - 1 : index,
                  model: item,
                );
              },
              separatorBuilder: (BuildContext context, int index) => showLable && index == 0
                  ? Divider(
                      height: 0,
                    )
                  : Divider(
                      color: Colors.transparent,
                      height: 16.h,
                    ),
            )));
  }
}

// 价格滑块
class PriceSlider extends GetView<AddGamePageController> {
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

  PriceSlider({this.max, this.min, this.fun, this.value = 0, this.model, this.index = 0}) {
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
    return outerBg(Column(
      children: [
        InputView(
          maxLength: 15,
          decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
          controller: textController,
          label: 'ServiceType_${model?.unit}',
          tips: 'Please input Service Name'.tr,
          margin: EdgeInsets.only(top: 2).h,
          padding: EdgeInsets.only(bottom: 8.h),
          height: 45.h,
          rightActionWidget: InkWell(
            onTap: () {
              controller.removePriceRange(index);
            },
            child: ImageUtil.assetImage('ic_delete2', width: 18),
          ),
        ),
        5.verticalSpace,
        Container(
          height: 45.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                      decoration: itemDecoration(color: Color(0xFF2D2E3C), radius: 10.r),
                      child: Obx(() => FlutterSlider(
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
                                    borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                                child: Text(
                                  '${price.toInt()}',
                                  style: TextStyle(color: Colors.black.withOpacity(0.75), fontSize: 12.sp),
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
                              price = v1;
                              model?.curPrice = price;
                            },
                            //    onDragCompleted: (i, v1, v2) => price = v1,
                          )))),
              10.horizontalSpace,
              Container(
                height: 45.h,
                width: 50.w,
                constraints: BoxConstraints(minWidth: 100.w),
                decoration: innerDecoration(),
                alignment: Alignment.center,
                padding: itemPadding(),
                child: dropDownButton(index, model?.unit),
              )
            ],
          ),
        )
      ],
    ));
  }

  dropDownButton(int index, var init) {
    var seclet = controller.priceRanges.firstWhereOrNull((element) => element.unit == init);
    return DropdownButtonHideUnderline(
        child: DropdownButton<PriceRangeModel>(
            value: seclet,
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
              controller.onPriceUnitChange(index, item!);
            }));
  }
}
