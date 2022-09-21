import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/bank_card_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/profile/balance/balance_page.dart';
import 'package:wy/utils/utils.dart';

/**
    bank_widget
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 **/
class BankListWidget extends GetView<BalancePageController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(12)),
      child: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return bankItem(controller.bankList[index]);
          },
          itemCount: controller.bankList.length,
        );
      }),
    );
  }

  Widget bankItem(BankCardModel bankModel) {
    return ListTile(
      dense: true,
      leading: Obx(() => Radio(
          activeColor: AppColor.accent,
          value: bankModel.id,
          groupValue: controller.accountType.value,
          toggleable: true,
          onChanged: (value) {
            flog('onChanged ${bankModel.id}');
            controller.changeAccountType(bankModel.id);
            //   controller.accountFocusNode.unfocus();
          })),
      title: Text(
        getPayCardStr(bankModel.cardNumber),
        style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "DIN"),
      ),
      subtitle: Text(
        bankModel.bankName ?? '',
        style: TextStyle(fontSize: 12, color: Colors.white, fontFamily: "DIN"),
      ),
      trailing: IconButton(
        icon: Icon(Icons.clear,color: Colors.white24,),
        onPressed: () {
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
      ),
    );
  }
}
