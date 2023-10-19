import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/model/pay_order_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/pay/controller.dart';
import 'package:wy/utils/index.dart';

import '../../model/address_model.dart';

class PayPage extends StatelessWidget {
  late final PayPageController controller;

  final userController = Get.find<UserController>();

  PayPage({
    required PayOrderModel payOrderModel,
  }) {
    controller = Get.put(PayPageController(payOrderModel: payOrderModel),
        tag: payOrderModel.totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    flog('payOrderModel ${controller.payOrderModel}');
    int orderType = controller.payOrderModel.type;
    return KeyboardScaffold(
      title: "Pay Confirm".tr,
      body: Platform.isIOS && StorageManager.getOnline() == false
          ? ListView(
              children: [
                _buildPayView("Apple Pay".tr, "ios_pay",
                    controller.payType.value, controller.payType.value)
              ],
            )
          : buildContentWidget(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget buildContentWidget() {
    int orderType = controller.payOrderModel.type;
    Widget firstWidget = _buildAmount();
    Widget secondWidget = Obx(() => _buildBillAddress());
    Widget thirdWidget = orderType == PayType.PW_RECHARGE
        ? Container()
        : Obx(
            () => _buildCredit(1, controller.payType.value, 'Credit Card'.tr));
    Widget thirdWidget2 = Obx(() => _buildCredit(
          9999,
          controller.payType.value,
          Platform.isAndroid ? 'Google Pay' : 'Apple Pay',
        ));
    Widget fourWidget;
    if (orderType == PayType.PW_STRIP_ACCOUNT) {
      fourWidget = Obx(() =>
          _buildPayView("Alipay".tr, "alipay", 4, controller.payType.value));
    }
    if (orderType > 0 || orderType == PayType.PW_RECHARGE) {
      fourWidget = Container();
    } else {
      fourWidget = Obx(() =>
          _buildPayView("Alipay".tr, "alipay", 4, controller.payType.value));
    }
    Widget fiveWidget;
    if (orderType == PayType.PW_RECHARGE) {
      fiveWidget = Obx(() => _buildPayView(
          "Gold Coins".tr, "balance_money", 2, controller.payType.value,
          subTitle: Row(
            children: [
              Image.asset(
                "assets/images/ic_balance_money.webp",
                width: 14,
                height: 14,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "${controller.coin.value}",
                style: TextStyle(color: Colors.white, fontSize: 14),
              )
            ],
          )));
    } else if (orderType == PayType.PW_STRIP_ACCOUNT) {
      fiveWidget = Obx(() => _buildPayView(
          "Balance".tr, "balance_money", 2, controller.payType.value,
          subTitle: Obx(() => Text(
                "￡${controller.balance}",
                style: TextStyle(
                    color: controller.isSufficient()
                        ? Colors.white
                        : Colors.white54),
              ))));
    } else if (orderType > -2) {
      fiveWidget = Container();
    } else {
      fiveWidget = Obx(() => _buildPayView(
          "Balance".tr, "balance_money", 2, controller.payType.value));
    }

    return Column(
      children: [
        firstWidget,
        secondWidget,
        thirdWidget,
        thirdWidget2,
        fourWidget,
        fiveWidget,
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ColorfulButton(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "CONFIRM".tr,
            style:
                TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
          ),
        ),
        onTap: () => userController.checkLogin(() =>
            Platform.isIOS && !StorageManager.getOnline()
                ? controller.inAppPay()
                : controller.pay()),
      ),
    );
  }

  Widget _buildAmount() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20),
      child: Stack(
        children: [
          Container(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.payOrderModel.type == -2
                            ? Image.asset(
                                "assets/images/ic_balance_money.webp",
                                width: 30,
                                height: 30,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "£",
                                  style: TextStyle(
                                      fontSize: 34,
                                      color: Colors.white,
                                      fontFamily: "DIN"),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 5),
                          child: Text(
                            "${double.parse(controller.payOrderModel.totalAmount).toStringAsFixed(controller.payOrderModel.type == -2 ? 0 : 2)}",
                            style: TextStyle(
                                fontSize: 34,
                                color: Colors.white,
                                fontFamily: "DIN"),
                          ),
                        ),
                      ],
                    ))),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              "Amount".tr,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBillAddress() {
    Widget text = Expanded(
        child: Text(
      "Please select your billing address".tr,
      style: TextStyle(fontSize: 14, color: Colors.white38),
    ));
    if (controller.address.value.id != 0) {
      var addressModel = controller.address.value;
      text = Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${addressModel.firstName} ${addressModel.lastName} ${addressModel.phone}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              "${addressModel.line1} ${addressModel.line2}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              " ${addressModel.city} ${addressModel.postCode}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      );
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Billing Address".tr,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () async {
              AddressModel? model =
                  await NavigatorHelper.gotoAddressPage(select: true);
              if (model != null) {
                controller.address.value = model;
              }
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  text,
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildCredit(int value, int groupValue, String payMethod) {
    return Container(
        margin: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          bottom: 15.h,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff28253D),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => controller.changePayType(value),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(
                    left: 5, right: 15, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      activeColor: AppColor.accent,
                      value: value,
                      groupValue: groupValue,
                      onChanged: (value) =>
                          controller.changePayType(value as int),
                      hoverColor: AppColor.accent,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "$payMethod",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "DIN"),
                      ),
                    ),
                    Spacer(),
                    // Image.asset("assets/images/ic_visa.webp",height: 32,),
                    // SizedBox(width: 10,),
                    // Image.asset("assets/images/ic_master.webp",height: 32,)
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildPayView(String name, String icon, int value, int groupValue,
      {Widget? subTitle}) {
    return GestureDetector(
      onTap: () => controller.changePayType(value),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.only(right: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff28253D),
        ),
        child: Row(
          children: [
            Radio(
              activeColor: AppColor.accent,
              value: value,
              groupValue: groupValue,
              onChanged: (value) => controller.changePayType(value as int),
              hoverColor: AppColor.accent,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                name,
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: "DIN"),
              ),
            ),
            Spacer(),
            subTitle ?? Container()
            //Image.asset("assets/images/ic_$icon.webp",height: 24,),
          ],
        ),
      ),
    );
  }
}
