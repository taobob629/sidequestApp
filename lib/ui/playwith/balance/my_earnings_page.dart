import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/common/paixs_fun.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/balance/play_balance_child.dart';
import 'package:wy/ui/playwith/balance/widget/bank_widget.dart';
import 'package:wy/ui/profile/balance/input_formatter.dart';
import 'package:wy/ui/profile/balance/item_title.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

class MyEarningsPage extends StatefulWidget {
  @override
  _MyEarningsPageState createState() => _MyEarningsPageState();
}

class _MyEarningsPageState extends State<MyEarningsPage> {
  late WalletBalancePageController controller;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    controller = Get.put(WalletBalancePageController());
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: MyListView(
        isShuaxin: false,
        padding: EdgeInsets.only(top: pmPadd.top + 56),
        item: (i) => item[i],
        itemCount: item.length,
      ),
    );
  }

  List<Widget> get item {
    return [
      PWidget.container(
        PWidget.column([
          PWidget.row([
            PWidget.image('assets/images/ic_balance_votes.webp'),
            PWidget.boxw(4),
            PWidget.text('Total amount'.tr, [Color(0xffEEF3FF)], {'exp': true}),
          ]),
          PWidget.boxh(10),
          Obx(() => PWidget.text('${controller.diamonds}', [Color(0xffEEF3FF), 32, true])),
        ]),
        [null, null, Color(0xff282640)],
        {'pd': 16, 'br': 12, 'mg': PFun.lg(0, 0, 16, 16)},
      ),
      ItemTitle(
          title: "Withdrawal amount".tr,
          subTitle: "",
          actions: Text(
            '${'Min'.tr}:1000',
            style: TextStyle(color: Colors.white54, fontFamily: "DIN", fontSize: 18),
          )),
      _buildCustomInput(),
      ItemTitle(
        title: "Withdrawal Account".tr,
        subTitle: "",
        actions: TextButton(
          onPressed: () {
            if (controller.bankList.length >= 4) {
              EasyLoading.showToast('Only 4 bankcards allowed!'.tr);
              return;
            }
            Get.toNamed(AppPages.BindBankCard);
          },
          child: Row(
            children: [
              PWidget.image('assets/images/ic_add.webp', [16, 16, null, BoxFit.cover]),
              PWidget.boxw(3),
              Text(
                'Add Account'.tr,
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              )
            ],
          ),
        ),
      ),
      //  _buildAccountSelect(context),
      BankListWidget(),
      PWidget.boxh(8),
      FloatingButton(
        label: "Withdrawal".tr,
        onTap: () => controller.privacyCheckController.check() ? controller.withDraw('withDraw') :EasyLoading.showInfo('You should read and agree to our seller payment terms first.'.tr),
      ),
      FloatingButton(
        label: "Exchange To Coin".tr,
        onTap: () => controller.privacyCheckController.check() ? controller.withDraw('exchange') :EasyLoading.showInfo('You should read and agree to our seller payment terms first.'.tr),
      ),
      PWidget.container(
        PWidget.column([
          PWidget.text('Withdrawal and exchange instructions:'.tr, [Color(0xffEEF3FF)]),
          Text(
            '''1. ${'Withdrawals typically take three to five bank working days.'.tr}\n2. ${'6 Diamond for £1.'.tr}''',
            style: TextStyle(color: Color(0xff8291B4)),
          ),
        ]),
        {'pd': 16},
      ),
      PWidget.boxh(8),
      PrivacyCheck(controller: controller.privacyCheckController, type: TYPE_ADD_BANK),
    ];
  }

  Widget _buildCustomInput() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white24))),
        child: TextField(
          maxLines: 1,
          inputFormatters: [PrecisionLimitFormatter(2)],
          controller: controller.amountController,
          focusNode: controller.amountFocusNode,
          cursorColor: Colors.white70,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 26, fontFamily: "DIN"),
          onSubmitted: (text) => controller.changeCustomAmount(text),
          decoration: const InputDecoration(hintText: "1000", hintStyle: TextStyle(fontSize: 26, color: Colors.white30, fontFamily: "DIN"), border: InputBorder.none, contentPadding: EdgeInsets.only(top: 0)),
        ));
  }

  Widget _buildAccountSelect(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 10, right: 15),
            decoration:
                BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: Obx(() {
              return Row(
                children: [
                  Radio(
                      activeColor: AppColor.accent,
                      value: 0,
                      groupValue: controller.accountType.value,
                      onChanged: (value) {
                        controller.changeAccountType(0);
                        controller.accountFocusNode.unfocus();
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "2930118234@qq.com",
                      style: TextStyle(
                          fontSize: 18,
                          color: controller.accountType.value == 0 ? Colors.white : Colors.white30,
                          fontFamily: "DIN"),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
