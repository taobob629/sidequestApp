import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/balance_api.dart';
import 'package:wy/common/getx_list_controller.dart';
import 'package:wy/model/bank_card_model.dart';
import 'package:wy/model/chage_rule_model.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/common/dialog_password.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/profile/balance/charge_item.dart';
import 'package:wy/ui/profile/balance/count_view.dart';
import 'package:wy/ui/profile/balance/input_formatter.dart';
import 'package:wy/ui/profile/balance/item_title.dart';
import 'package:wy/utils/navigator_helper.dart';
import 'package:wy/utils/num_utils.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/mylistview.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';
import 'package:wy/widget/views.dart';

class PlayBalanceChild extends StatefulWidget {
  @override
  _PlayBalanceChildState createState() => _PlayBalanceChildState();
}

class _PlayBalanceChildState extends State<PlayBalanceChild> {
  late WalletBalancePageController controller;

  @override
  void initState() {
    this.initData();
    super.initState();
  }

  UserController userController = Get.find<UserController>();

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
      btnBar: FloatingButton(
        label: "CONFIRM".tr,
        onTap: () => Get.dialog(ConfirmDialog(
          title: 'Warning'.tr,
          info: 'These Coins are only used for SideKick.'.tr,
          onConfirm: () => controller.pay(),
        )),
      ),
    );
  }

  List<Widget> get item {
    return [
      cardView(),
      ItemTitle(title: "Recharge".tr, subTitle: ""),
      PWidget.boxh(8),
      Obx(() => _buildChargeItems(context!)),
      // Obx(
      //   () => ItemTitle(
      //       title: '',
      //       subTitle: '',
      //       customSubTitle: Padding(
      //         padding: EdgeInsets.only(left: 10),
      //         child: controller.iconByChargeRatio == 0
      //             ? Text(
      //                 "Other recharge amount".tr,
      //                 style: TextStyle(color: Colors.white, fontSize: 18),
      //               ): Row(
      //           children: [
      //             PWidget.image('assets/images/ic_balance_money.webp', [16, 16]),
      //             Text(
      //               " ${controller.iconByChargeRatio}",
      //               style: TextStyle(color: Colors.yellow,fontSize: 18),
      //             )
      //           ],
      //         ),
      //       ),
      //       actions: Text(
      //         '${'Min'.tr}:£1',
      //         style: TextStyle(color: Colors.white54, fontFamily: "DIN", fontSize: 18),
      //       )),
      // ),
      // _buildCustomInput(),
      PWidget.container(
        PWidget.column([
          PWidget.text('${'Tips'.tr}:', [Color(0xffEEF3FF)]),
          Text(
            '* These Coins are only used for SideKick.'.tr,
            style: TextStyle(color: Color(0xff8291B4)),
          ),
        ]),
        {'pd': 16},
      ),
      // ItemTitle(title: "Top Up Account", subTitle: ""),
      // _buildAccountSelect(context!),
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
          decoration:
              const InputDecoration(hintText: "£1", hintStyle: TextStyle(fontSize: 26, color: Colors.white30, fontFamily: "DIN"), border: InputBorder.none, contentPadding: EdgeInsets.only(top: 0)),
        ));
  }

  Widget cardView() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Color(0xFFFF3BC1)),
      child: AspectRatio(
        aspectRatio: 343 / 136,
        child: Stack(children: [
          Positioned(left: 0, right: 0, bottom: 0, height: 100, child: ClipPath(clipper: BottomPath(), child: Container(color: Colors.white30))),
          Positioned(left: 0, right: 0, bottom: 0, height: 100, child: ClipPath(clipper: _Bottom2Path(), child: Container(color: Colors.white30))),
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xaaFF3BC2), Color(0x998B00FF)]))),
          Positioned(right: 0, top: -10, width: 100, child: Image.asset("assets/images/bg_balance.webp")),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CountView(
                    customIcon: "assets/images/coin_red.webp",
                    title: "Coin".tr,
                    // count: "${controller.coin}",
                    count: "${userController.userInfoModel.value.coin}",
                    icon: '',
                  ),
                  CountView(icon: "votes", title: "Diamond".tr, count: "${controller.diamonds}"),
                ],
              )),
        ]),
      ),
    );
  }

  Widget _buildChargeItems(BuildContext context) {
    List<Widget> itemList = [];
    int index = 0;
    controller.list.forEach((element) {
      itemList.add(ChargeItem(
        showCoin: true,
        index: index,
        item: element,
        selected: index == controller.productIndex.value,
        onTap: (idx) => controller.changeProductIndex(idx),
      ));
      index++;
    });
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 8,
      childAspectRatio: 104 / 122,
      children: itemList,
    );
  }
}

class BottomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint;
    var endPoint;
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(-size.width * 5 / 100, size.height * 70 / 100);

    controlPoint = Offset(size.width * 5 / 100, size.height * 80 / 100); //曲线开始点
    endPoint = Offset(size.width * 20 / 100, size.height * 45 / 100); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    controlPoint = Offset(size.width * 38 / 100, 0); //曲线开始点
    endPoint = Offset(size.width * 60 / 100, size.height * 55 / 100); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    controlPoint = Offset(size.width * 80 / 100, size.height); //曲线开始点
    endPoint = Offset(size.width, size.height * 75 / 100); // 曲线结束点
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, size.height); // 第五个点
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _Bottom2Path extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 55 / 100);
    path.cubicTo(size.width * 322 / 700, 0, size.width * 382 / 700, size.height * 1.3, size.width, size.height * 60 / 100);
    path.lineTo(size.width, size.height); // 第五个点
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WalletBalancePageController extends GetxListController {
  late PrivacyCheckController privacyCheckController;
  late var productIndex = 0.obs;

  late var customAmount = 0.0.obs;

  late var accountType = 0.obs;
  var _iconByChargeRatio = 0.obs;
  final withdrawType = 0.obs;

  get iconByChargeRatio => _iconByChargeRatio.value;

  set iconByChargeRatio(value) {
    _iconByChargeRatio.value = value;
  }

  var _coin = 0.obs;
  var _diamonds = 0.obs;

  get coin => _coin;

  set coin(value) {
    _coin.value = value;
  }

  get diamonds => _diamonds.value;

  set diamonds(value) {
    _diamonds.value = value;
  }

  void dealIconChargeRatio() {
    if (amountController.text.isBlank == true) {
      iconByChargeRatio = 0;
      return;
    }
    double amount = double.parse(amountController.text);
    if (chargeRule == null || amount == 0) iconByChargeRatio = 0;
    var chargeRatio;
    try {
      chargeRatio = double.parse(chargeRule.chargeRatio ?? '0');
      double doubleResult = chargeRatio * amount;
      iconByChargeRatio = doubleResult.floor();
    } catch (e) {
      iconByChargeRatio = 0;
    }
  }

  late TextEditingController amountController;
  late TextEditingController accountController;
  TextEditingController paypalController = TextEditingController();
  late FocusNode accountFocusNode;
  late FocusNode amountFocusNode;
  RxList<BankCardModel> _bankList = RxList();

  List<BankCardModel> get bankList => _bankList;

  set bankList(List<BankCardModel> value) {
    _bankList.value = value;
  }

  BankCardModel? selectedBank;

  WalletBalancePageController({double amount = 0.0}) {
    customAmount.value = amount;
  }

  @override
  void onInit() {
    super.onInit();
    privacyCheckController = PrivacyCheckController();
    getBankList();
    amountController = TextEditingController()
      ..addListener(() {
        dealIconChargeRatio();
      });
    accountController = TextEditingController();
    accountFocusNode = FocusNode();
    amountFocusNode = FocusNode();

    amountFocusNode.addListener(() {
      if (amountFocusNode.hasFocus) {
        changeProductIndex(-1);
      } else {
        if (amountController.text.isEmpty) {
          changeProductIndex(0);
        } else {
          customAmount.value = double.parse(amountController.text);
          if (customAmount.value > 0) {
            if (customAmount.value < 1) {
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

  late ChargeRuleModel chargeRule;

  Future<List<CoinChargeRuleModel>> loadData() async {
    EasyLoading.show();
    chargeRule = await BalanceApi.chargeRule();
    coin = chargeRule.coin;
    diamonds = chargeRule.votes;
    EasyLoading.dismiss();
    return chargeRule.pwChargeRules ?? [];
  }

  void changeProductIndex(int index) {
    productIndex.value = index;
    amountController.clear();
    iconByChargeRatio = 0;
  }

  void changeCustomAmount(String amount) {
    if (amount.isEmpty) {
      productIndex.value = 0;
      return;
    }
    customAmount.value = double.parse(amount);
    if (customAmount.value > 0) {
      if (customAmount.value < 1) {
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
    if (Get.isDialogOpen == true) Get.back();
    PayOrderModel payOrderModel = PayOrderModel()..type = 2;
    String amountStr = amountController.text;
    double amount = 0.0;
    if (amountStr.isNotEmpty) {
      amount = double.parse(amountStr);
      if (!isValidateAmount(amountStr, 1)) {
        EasyLoading.showInfo('Please enter an valid number greater than 1'.tr);
        return;
      }
    }
    if (amount == 0) {
      CoinChargeRuleModel model = list[productIndex.value];
      amount = double.parse(model.money) * 1.0;
      payOrderModel.chargeid = model.id;
    }

    payOrderModel.goodsPrice = "$amount";
    payOrderModel.totalAmount = "$amount";
    NavigatorHelper.gotoPayPage(payOrderModel, whenComplete: () {
      updateCoinAndDiamonds();
    });
  }

  Future<void> updateCoinAndDiamonds() async {
    ChargeRuleModel chargeRule = await BalanceApi.chargeRule();
    coin = chargeRule.coin;
    diamonds = chargeRule.votes;
  }

  void getBankList() async {
    bankList = await BalanceApi.getBankList();
    if (bankList.isNotEmpty) {
      selectedBank = bankList.first;
      accountType.value = selectedBank?.id ?? 0;
    }
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
  Future<void> withDraw(String type, {String cardNum = ""}) async {
    UserController userController = Get.find<UserController>();
    var votes = amountController.text;
    if (votes.isEmpty) {
      EasyLoading.showInfo('Please Enter withdraw amount!'.tr);
      return;
    }
    if (!isValidateAmount(votes, 600) && (type == 'withDraw' || type == 'paypal')) {
      EasyLoading.showInfo('Please enter an valid number greater than 600'.tr);
      return;
    }
    double votesDouble = double.parse(votes);
    double votesSum = double.parse(userController.userInfoModel.value.votes);
    if (votesDouble.isGreaterThan(votesSum)) {
      EasyLoading.showInfo('${'Lack of diamonds'.tr}!');
      return;
    }
    if (type == "paypal" && paypalController.text.trim().isEmpty) {
      EasyLoading.showInfo('Please Enter paypal account!'.tr);
      return;
    }
    Get.dialog(PasswordDialog(), barrierDismissible: true, barrierColor: Colors.black26).then((value) async {
      if (value == true) {
        if (type == "paypal") {
          await paypalWithdrawRequest(paypalController.text, votes);
        } else {
          await withdrawRequest(type, votes);
        }
      }
    });
  }

  Future<void> paypalWithdrawRequest(String cardNumber, String votes) async {
    EasyLoading.show();
    var response;

    if (selectedBank == null) {
      EasyLoading.showInfo('Please Add withdraw account First!'.tr);
      return;
    }
    response = await BalanceApi.withDraw(Map<String, dynamic>()
      ..['card'] = cardNumber
      ..['votes'] = votes
      ..['accountType'] = 1);
    if (response.statusCode == 200) {
      diamonds = double.parse(response.data['votes'].toString()).toInt();
      coin = double.parse(response.data['coin'].toString()).toInt();
      Get.find<UserController>().updateInfo();
      EasyLoading.showSuccess(response.statusMessage!);
    }
    EasyLoading.dismiss();
  }

  Future<void> withdrawRequest(String type, String votes) async {
    EasyLoading.show();
    var response;
    if (type == 'withDraw') {
      if (selectedBank == null) {
        EasyLoading.showInfo('Please Add withdraw account First!'.tr);
        return;
      }
      response = await BalanceApi.withDraw(Map<String, dynamic>()
        ..['card'] = selectedBank?.cardNumber
        ..['cardId'] = selectedBank?.id
        ..['votes'] = votes
        ..['withDrawalRatio'] = chargeRule.withdrawalRatio
        ..['accountType'] = 0
        ..['chargeRatio'] = chargeRule.chargeRatio);
    } else if (type == 'PalpalWithDraw') {
      if (selectedBank == null) {
        EasyLoading.showInfo('Please Add withdraw account First!'.tr);
        return;
      }
      response = await BalanceApi.withDraw(Map<String, dynamic>()
        ..['card'] = selectedBank?.cardNumber
        ..['cardId'] = selectedBank?.id
        ..['votes'] = votes
        ..['withDrawalRatio'] = chargeRule.withdrawalRatio
        ..['chargeRatio'] = chargeRule.chargeRatio);
    } else {
      response = await BalanceApi.exchangeToCoin(votes);
    }
    if (response.statusCode == 200) {
      diamonds = double.parse(response.data['votes'].toString()).toInt();
      coin = double.parse(response.data['coin'].toString()).toInt();
      Get.find<UserController>().updateInfo();
      EasyLoading.showSuccess(response.statusMessage!);
    }
    EasyLoading.dismiss();
  }
}
