import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/balance_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/bank_card_model.dart';
import 'package:wy/model/chage_rule_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/action_button.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/balance/item_title.dart';
import 'package:wy/ui/profile/consume/my_consume_page.dart';
import 'package:wy/utils/navigator_helper.dart';

import 'charge_item.dart';
import 'input_formatter.dart';
import 'top_banner.dart';

class BalancePage extends StatelessWidget {

  late final BalancePageController controller;

  BalancePage({double amount = 0.0}){
    controller = Get.put(BalancePageController(amount: amount));
  }

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "Top Up",
      actions: [
        ActionButton(
          icon: Icon(Icons.list, size: 26,color: Colors.white,),
          onTap: ()=>Get.to(()=>MyConsumePage()),
        )
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBanner(),
            ItemTitle(title: "Top Up",subTitle: "",),
            Obx(()=>_buildChargeItems(context)),
            ItemTitle(title: "Other Top Up Amount", subTitle: "Min:£1",),
            _buildCustomInput(),
            ItemTitle(title: "Top Up Account",subTitle: "",),
            _buildAccountSelect(context),
            Container(height: 100,)
          ],
        )
      ),
      floatingActionButton: FloatingButton(
        label: "CONFIRM",
        onTap: ()=> controller.pay()
      ),
    );
  }

  Widget _buildChargeItems(BuildContext context) {
    List<Widget> itemList = [];
    int index = 0;
    controller.list.forEach((element) {
      itemList.add(ChargeItem(
        index: index,
        item: element,
        selected: index == controller.productIndex.value,
        onTap: (idx) => controller.changeProductIndex(idx),
      ));
      index++;
    });
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 104 / 114,
      children: itemList,
    );
  }

  Widget _buildCustomInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24))
      ),
      child: TextField(
        maxLines: 1,
        inputFormatters: [PrecisionLimitFormatter(2)],
        controller: controller.amountController,
        focusNode: controller.amountFocusNode,
        cursorColor: Colors.white70,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white30, fontSize: 26, fontFamily: "DIN"),
        onSubmitted: (text) => controller.changeCustomAmount(text),
        decoration: const InputDecoration(
          hintText: "£0",
          hintStyle: TextStyle(fontSize: 26, color: Colors.white30, fontFamily: "DIN"),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 0)
        ),
      )
    );
  }

  Widget _buildAccountSelect(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 10, right: 15),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12)
            ),
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
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "${userController.user.value.email}",
                      style: TextStyle(
                        fontSize: 18,
                        color: controller.accountType.value == 0 ? Colors.white : Colors.white30,
                        fontFamily: "DIN"
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
          // SizedBox(height: 10,),
          // Container(
          //   height: 50,
          //   padding: const EdgeInsets.only(left: 10, right: 15),
          //   decoration: BoxDecoration(
          //     color: Colors.white10,
          //     borderRadius: BorderRadius.circular(12)
          //   ),
          //   child: Obx(() {
          //     return Row(
          //       children: [
          //         Radio(
          //           activeColor: AppColor.accent,
          //           value: 1,
          //           groupValue: controller.accountType.value,
          //           onChanged: (value) {
          //             controller.changeAccountType(1);
          //             FocusScope.of(context).requestFocus(controller.accountFocusNode);
          //           },
          //         ),
          //         Expanded(
          //           child: TextField(
          //             controller: controller.accountController,
          //             maxLines: 1,
          //             focusNode: controller.accountFocusNode,
          //             cursorColor: Colors.white70,
          //             textAlign: TextAlign.left,
          //             keyboardType: TextInputType.emailAddress,
          //             style: TextStyle(
          //               color: controller.accountType.value == 1 ? Colors.white : Colors.white30,
          //               fontSize: 18, fontFamily: "DIN"
          //             ),
          //             onSubmitted: (text) => {},
          //             decoration: const InputDecoration(
          //               hintText: "Enter email / SideQuest ID",
          //               hintStyle: TextStyle(fontSize: 18, color: Colors.white30, fontFamily: "DIN"),
          //               border: InputBorder.none,
          //               contentPadding: EdgeInsets.only(top: 2)
          //             ),
          //           ),
          //         ),
          //       ],
          //     );
          //   }),
          // )
        ],
      ),
    );
  }
}

class BalancePageController extends GetxListController {
  late var productIndex = 0.obs;

  late var customAmount = 0.0.obs;

  late var accountType = 0.obs;

  late TextEditingController amountController;
  late TextEditingController accountController;
  late FocusNode accountFocusNode;
  late FocusNode amountFocusNode;
  RxList<BankCardModel> _bankList = RxList();

  List<BankCardModel> get bankList => _bankList;

  set bankList(List<BankCardModel> value) {
    _bankList.value = value;
  }

  BankCardModel? selectedBank;

  BalancePageController({double amount = 0.0}) {
    customAmount.value = amount;
  }

  @override
  void onInit() {
    super.onInit();
    getBankList();
    amountController = TextEditingController();
    accountController = TextEditingController();
    accountFocusNode = FocusNode();
    amountFocusNode = FocusNode();

    amountFocusNode.addListener(() {
      if (amountFocusNode.hasFocus) {
        changeProductIndex(-1);
      } else {
        if (amountController.text.isEmpty) {
          changeProductIndex(0);
        }else{
          customAmount.value = double.parse(amountController.text);
          if (customAmount.value > 0) {
            if(customAmount.value < 1){
              customAmount.value = 1;
              amountController.text = "1.0";
            }
            productIndex.value = -1;
          }
        }
      }
    });
  }

  @override
  void onClose() {
    amountController.dispose();
    amountFocusNode.dispose();
    accountFocusNode.dispose();
    accountController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    accountFocusNode.addListener(() {
      if (accountFocusNode.hasFocus) {
        changeAccountType(1);
      } else {
        if (accountController.text.isEmpty) {
          changeAccountType(0);
        }
      }
    });

    if (customAmount.value > 0) {
      if (customAmount.value < 1) {
        customAmount.value = 1;
      }
      productIndex.value = -1;
      amountController.text = customAmount.value.toStringAsFixed(2);
    }
  }

  ChargeRuleModel? chargeRule;

  Future<List<CoinChargeRuleModel>> loadData() async {
    EasyLoading.show();
    chargeRule = await BalanceApi.chargeRule();
    EasyLoading.dismiss();
    return chargeRule?.pwChargeRules ?? [];
  }

  void changeProductIndex(int index) {
    productIndex.value = index;
    amountController.clear();
  }

  void changeCustomAmount(String amount) {
    if(amount.isEmpty){
      productIndex.value = 0;
      return;
    }
    customAmount.value = double.parse(amount);
    if (customAmount.value > 0) {
      if(customAmount.value < 1){
        customAmount.value = 1;
        amountController.text = "1.0";
      }
      productIndex.value = -1;
    } else {
      productIndex.value = 0;
    }
  }

  void changeAccountType(int value) {
    accountType.value = value;
  }

  void selectBank(BankCardModel bank) {
    selectedBank = bank;
    accountType.value = bank.id;
  }

  void pay() {
    PayOrderModel payOrderModel = PayOrderModel();
    String amountStr = amountController.text;
    double amount = 0.0;
    if (amountStr.isNotEmpty) {
      amount = double.parse(amountStr);
    }
    if (amount == 0) {
      CoinChargeRuleModel model=list[productIndex.value];
      amount = double.parse(model.money) * 1.0;
    }
    payOrderModel.goodsPrice = "$amount";
    payOrderModel.totalAmount = "$amount";

    NavigatorHelper.gotoPayPage(payOrderModel,whenComplete: (){
      var userController = Get.find<UserController>();
      userController.updateInfo();
    });
  }

  void getBankList() async {
    bankList = await BalanceApi.getBankList();
    selectedBank = bankList?.first;
    accountType.value = selectedBank?.id ?? -1;
  }

  void deleteBank(var id) async {
    EasyLoading.show();
    await BalanceApi.unbindBankCard(id);
    getBankList();
    EasyLoading.showToast('Success');
    EasyLoading.dismiss();
  }

  /*
   * 提现
   *  post方法
参数 ：
name：用户昵称，可选
card：银行卡号
cardId:银行卡ID
votes:金币数量
voucherId：优惠券ID，若有
withDrawalRatio：提现手续费比例
chargeRatio：金币兑换比例
   */
  Future<void> withDraw() async {
    var votes = amountController.text;
    if (votes.isEmpty) {
      EasyLoading.showInfo('Please Enter withdraw amount!');
      return;
    }
    if (selectedBank == null) {
      EasyLoading.showInfo('Please Add withdraw account First!');
      return;
    }
    EasyLoading.show();
    await BalanceApi.withDraw(Map<String, dynamic>()
      ..['card'] = selectedBank?.cardNumber
      ..['cardId'] = selectedBank?.id
      ..['votes'] = votes
      ..['withDrawalRatio'] = chargeRule?.withdrawalRatio
      ..['chargeRatio'] = chargeRule?.chargeRatio);
    EasyLoading.dismiss();
    Get.back();
  }
}
