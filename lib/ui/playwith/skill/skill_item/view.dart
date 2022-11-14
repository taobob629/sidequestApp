/**
    author:mac
    创建日期:2022/9/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

import 'controller.dart';

class SkillItemPage extends GetView<SkillItemPageController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('${Get.arguments}'),
        actions: [
          PWidget.text('Edit'.tr, [Colors.white, 14, true])
        ],
      ),
      body: PWidget.column(items(context)),
      btnBar: FloatingButton(
        label: "CONFIRM".tr,
      ),
    );
  }

  items(context) {
    return [
      PWidget.text('Nickname'.tr, [Colors.white, 18, true], {'ff': 'DIN'}),
      PWidget.boxh(16),
      itemBg(PWidget.row([
        // PWidget.text('Be good at', [Colors.white]),
        // PWidget.boxw(8),
        buildTFView(context!,
            hintText: 'Please enter user nickname'.tr,
            hintColor: Colors.white24,
            textColor: Colors.white,
            con: controller.teContent,
            isExp: true,
            maxLength: 26),
      ]))
    ];
  }

  Widget itemBg(view, {Function? fun}) {
    return PWidget.container(view, [null, 48, Color(0xff282640)],
        {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }
}
