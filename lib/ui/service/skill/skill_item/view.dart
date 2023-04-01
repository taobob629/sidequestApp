/**
    author:mac
    创建日期:2022/9/22
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
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/another_xlider.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

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
                child: ImageUtil.assetImage('ic_delete2', width: 18))
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: Obx(
            () => controller.skillModel == null ? buildLoad() : PWidget.column(items()),
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
    var value = (controller.price > priceRangeMax || controller.price < priceRangeMin)
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
                value: (controller.price > priceRangeMax || controller.price < priceRangeMin)
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
    ];
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(
        view, [null, 45, AppColor.itemBg2], {'br': 10.r, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
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
    return Obx(() => FlutterSlider(
          values: [price],
          max: max!,
          min: min!,
          handlerWidth: 40.w,
          trackBar: FlutterSliderTrackBar(
            inactiveTrackBar:
                BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
            activeTrackBar:
                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          ),
          tooltip: FlutterSliderTooltip(
            positionOffset: FlutterSliderTooltipPositionOffset(top: -16),
            custom: (v) => PWidget.container(
              PWidget.row([
                Image.asset("assets/images/ic_balance_money.webp", width: 16, height: 16),
                PWidget.boxw(4),
                PWidget.text('${double.parse('$v').toInt()}'),
                PWidget.boxw(4),
                PWidget.text('(£${(double.parse('$v') / 6.0).toStringAsFixed(2)})'),
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
            fun?.call(v1);
            price = v1;
            // model?.curPrice = price;
          },
          //    onDragCompleted: (i, v1, v2) => price = v1,
        ));
  }
}
