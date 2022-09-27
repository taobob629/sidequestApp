import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wy/model/bank_card_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/playwith/balance/play_balance_child.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/paixs_widget.dart';

/**
    bank_widget
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
const double _itemHeight = 90;
const List _colorArray = [
  {'bf': Color.fromRGBO(255, 170, 86, 1), 'tr': Color.fromRGBO(255, 134, 78, 1)},
  {'bf': Color.fromRGBO(255, 146, 89, 1), 'tr': Color.fromRGBO(234, 57, 110, 1)},
  {'bf': Color.fromRGBO(175, 122, 255, 1), 'tr': Color.fromRGBO(215, 71, 255, 1)},
  {'bf': Color.fromRGBO(88, 158, 255, 1), 'tr': Color.fromRGBO(88, 76, 255, 1)},
];
double _topSpace = 20.0;

class BankListWidget extends GetView<WalletBalancePageController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: _itemHeight * (controller.bankList.length) -
              _topSpace * (controller.bankList.length - 1),
          margin: EdgeInsets.only(left: 16, right: 16),
          constraints: BoxConstraints(maxHeight: Get.height / 2, maxWidth: Get.width),
          child: Stack(
              children: controller.bankList
                  .mapIndexed((index, bankModel) => item(context, index, bankModel))
                  .toList()),
        ));
  }

  Widget item(BuildContext context, int index, BankCardModel bankModel) {
    double top = 0;
    if (index == 0) {
      top = 0;
    } else {
      top = (_itemHeight * index) - _topSpace * index;
    }
    return Positioned(
        top: top,
        left: 0,
        right: 0,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: bankItem(context, bankModel),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  //渐变位置
                  begin: Alignment.bottomLeft, //右上
                  end: Alignment.topRight, //左下
                  //  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [_colorArray[index]['bf'], _colorArray[index]['tr']])),
          height: _itemHeight,
        ));
  }

  Widget bankItem(BuildContext context, BankCardModel bankModel) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                controller.selectBank(bankModel);
              },
              child: Obx(() => Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: PWidget.image(
                        'assets/images/${controller.accountType.value == bankModel.id ? 'ic_checked' : 'ic_uncheck'}.webp',
                        [20, 20, null, BoxFit.cover]),
                  )),
            ),
            PWidget.boxw(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankModel.bankName ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                //   PWidget.boxh(5),
                Text(
                  getPayCardStr(bankModel.cardNumber),
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ],
        ),
        Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                Get.dialog(
                  ConfirmDialog(
                      title: "Waining",
                      onConfirm: () {
                        Get.back();
                        controller.deleteBank(bankModel.id);
                      },
                      info: "Are you sure to delete this account ?"),
                  barrierColor: Colors.black26,
                );
              },
              child: PWidget.image('assets/images/ic_more.webp'),
            ))
      ],
    );
  }
}
