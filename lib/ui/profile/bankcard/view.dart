import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/common/web_page.dart';
import 'package:wy/ui/profile/bankcard/controller.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/view/views.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

/**
    view
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class BindBankCardPage extends GetView<BindBankCardController> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Bind bank card'.tr, style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
      ),
      body: PWidget.column([
        PWidget.container(
          PWidget.row([
            PWidget.image('assets/images/ic_safety.webp', [24, 24]),
            PWidget.boxw(8),
            Expanded(
              child: Text(
                'In order to ensure normal bank card signing, you need to collect your bank card information to ensure privacy and security throughout the process. Please feel free to use'
                    .tr,
                style: TextStyle(color: Color(0xff4488FF)),
              ),
            ),
          ], '000'),
          [null, null, Color(0xffDEEAFF).withOpacity(0.1)],
          {'pd': 8},
        ),
        PWidget.text(
          'Bank card information'.tr,
          [Colors.white, 18, true],
          {'ff': 'DIN', 'pd': PFun.lg(16, 16, 26, 16)},
        ),
        Expanded(child: _buildForm())
      ], '000'),
      btnBar: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          PrivacyCheck(
              controller: controller.privacyCheckController,
              type: TYPE_ADD_BANK),
          FloatingButton(
            label: "Next".tr,
            onTap: () {
              controller.save();
            },
          )
        ],
      ),
    );
  }

  _buildForm() => MyListView(
        isShuaxin: false,
        flag: false,
        padding: EdgeInsets.all(16),
        itemCount: item.length,
        item: (i) => item[i],
        divider: Divider(height: 16, color: Colors.transparent),
      );

  List<Widget> get item {
    var hintColor = Color.fromRGBO(130, 145, 180, 1);
    return [
      itemBg(PWidget.row([
        PWidget.text('Sort code', [
          Colors.white,
        ], {
          'ali': 1
        }),
        PWidget.boxw(8),
        buildTFView(context!,
            hintText: 'Please enter the 6-digit format xx-xx-xx',
            con: controller.sortCodeTEC,
            textAlign: TextAlign.right,
            hintColor: hintColor,
            textColor: Colors.white,
            isBankCode: true,
            isExp: true),
      ])),
      itemBg(PWidget.row([
        PWidget.text('Bank name'.tr, [
          Colors.white,
        ], {
          'ali': 1
        }),
        PWidget.boxw(8),
        buildTFView(context!,
            hintText: 'please input'.tr,
            con: controller.bankNameTEC,
            textAlign: TextAlign.right,
            hintColor: hintColor,
            textColor: Colors.white,
            isExp: true),
      ])),
      itemBg(PWidget.row([
        PWidget.text('Account number'.tr, [
          Colors.white,
        ], {
          'ali': 1
        }),
        PWidget.boxw(8),
        buildTFView(context!,
            hintText: 'please input'.tr,
            con: controller.accountNumTEC,
            textAlign: TextAlign.right,
            hintColor: hintColor,
            textColor: Colors.white,
            isExp: true),
      ])),
      itemBg(PWidget.row([
        PWidget.text('Name on account'.tr, [
          Colors.white,
        ], {
          'ali': 1
        }),
        PWidget.boxw(8),
        buildTFView(context!,
            hintText: '${'please input'.tr}',
            con: controller.nameOnAccountNumTEC,
            textAlign: TextAlign.right,
            hintColor: hintColor,
            textColor: Colors.white,
            isExp: true),
      ])),
    ];
  }

  Widget itemBg(view, {Function? fun}) {
    return Container(
        child: view,
        padding: EdgeInsets.fromLTRB(10, 15, 15, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xff282640),
        ));
    return PWidget.container(view, [null, 48, Color(0xff282640)],
        {'br': 48, 'pd': PFun.lg(0, 0, 16, 16), 'fun': fun});
  }
}
