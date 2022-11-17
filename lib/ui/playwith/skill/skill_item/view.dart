/**
    author:mac
    创建日期:2022/9/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/playwith/add_game_page.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
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
                child: PWidget.text('Delete'.tr, [Colors.white, 14, true]))
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
        PWidget.text('Service Name'.tr, [Colors.white]),
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
        PWidget.text('Level'.tr, [Colors.white]),
        PWidget.boxw(16),
        PWidget.text('${controller.skillModel?.level}'.tr, [Colors.white]),
      ])),
      PWidget.boxh(10),
      itemBg(PWidget.row([
        PWidget.text('Price range'.tr, [Colors.white]),
        PriceSlider(
            min: controller.skillModel?.priceRangeMin?.toDouble() ?? 0,
            max: controller.skillModel?.priceRangeMax?.toDouble() ?? 0,
            value: (controller.price > priceRangeMax ||
                    controller.price < priceRangeMin)
                ? priceRangeMin
                : controller.price,
            fun: (v) => controller.price = v),
      ])),
      PWidget.boxh(10),
      itemBg(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        PWidget.text('Status'.tr, [Colors.white]),
        Switch(
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
    return PWidget.container(view, [null, 48, Color(0xff282640)],
        {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }
}
