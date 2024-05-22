import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/address_model.dart';
import '../../../common/colorful_button.dart';
import '../../../common/keyboard_scaffold.dart';
import '../../../config/app_color.dart';
import '../../../controller/user_controller.dart';
import '../../../model/pay_order_model.dart';
import '../../../utils/navigator_helper.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/utils.dart';
import 'controller.dart';

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
    return KeyboardScaffold(
      title: "Pay Confirm".tr,
      body: ListView.separated(
        itemBuilder: (context, index) =>
            Platform.isIOS ? iosWidget(index) : androidWidget(index),
        separatorBuilder: (context, index) => 15.verticalSpace,
        itemCount: Platform.isIOS ? 6 : 5,
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget iosWidget(int index) {
    int orderType = controller.payOrderModel.type;
    //  flog('orderTYpe $orderType');
    if (index == 0) {
      return _buildAmount();
    } else if (index == 1) {
      return Obx(() => _buildBillAddress());
    } else if (index == 2) {
      if (orderType == PayType.PW_RECHARGE) {
        return Container();
      }
      return Obx(() => _buildCredit(1, controller.payType.value));
    } else if (index == 3) {
      return Obx(() => _buildPayView(
            "Apple Pay".tr,
            "Apple Pay".tr,
            7,
            controller.payType.value,
          ));
    } else if (index == 4) {
      if (orderType == PayType.PW_STRIP_ACCOUNT) {
        return Obx(() =>
            _buildPayView("Alipay".tr, "alipay", 4, controller.payType.value));
      }
      if (orderType > 0 || orderType == PayType.PW_RECHARGE) {
        return Container();
      } else {
        return Obx(() =>
            _buildPayView("Alipay".tr, "alipay", 4, controller.payType.value));
        //return Container();
      }
    } else if (index == 5) {
      if (orderType == PayType.PW_RECHARGE) {
        return Obx(() => _buildPayView(
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
        return Obx(() => _buildPayView(
            "Balance".tr, "balance_money", 2, controller.payType.value,
            subTitle: Obx(() => Text(
                  "￡${controller.balance}",
                  style: TextStyle(
                      color: controller.isSufficient()
                          ? Colors.white
                          : Colors.white54),
                ))));
      } else if (orderType > -2) {
        return 0.verticalSpace;
      } else {
        return Obx(() => _buildPayView(
            "Balance".tr, "balance_money", 2, controller.payType.value));
      }
    }
    return 70.verticalSpace;
  }

  Widget androidWidget(int index) {
    int orderType = controller.payOrderModel.type;
    //  flog('orderTYpe $orderType');
    if (index == 0) {
      return _buildAmount();
    } else if (index == 1) {
      return Obx(() => _buildBillAddress());
    } else if (index == 2) {
      if (orderType == PayType.PW_RECHARGE) {
        return Container();
      }
      return Obx(() => _buildCredit(1, controller.payType.value));
    } else if (index == 3) {
      if (orderType == PayType.PW_STRIP_ACCOUNT) {
        return Obx(() =>
            _buildPayView("Alipay".tr, "alipay", 4, controller.payType.value));
      }
      if (orderType > 0 || orderType == PayType.PW_RECHARGE) {
        return Container();
      } else {
        return Obx(() =>
            _buildPayView("Alipay".tr, "alipay", 4, controller.payType.value));
        //return Container();
      }
    } else if (index == 4) {
      if (orderType == PayType.PW_RECHARGE) {
        return Obx(() => _buildPayView(
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
        return Obx(() => _buildPayView(
            "Balance".tr, "balance_money", 2, controller.payType.value,
            subTitle: Obx(() => Text(
                  "￡${controller.balance}",
                  style: TextStyle(
                      color: controller.isSufficient()
                          ? Colors.white
                          : Colors.white54),
                ))));
      } else if (orderType > -2) {
        return 0.verticalSpace;
      } else {
        return Obx(() => _buildPayView(
            "Balance".tr, "balance_money", 2, controller.payType.value));
      }
    }
    return 70.verticalSpace;
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
        onTap: () => userController.checkLogin(
          () => controller.pay(),
          // () => Platform.isIOS && !StorageManager.getOnline()
          //     ? controller.inAppPay()
          //     : controller.pay(),
        ),
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

  Widget _buildCredit(int value, int groupValue) {
    String payMethod = "";
    if (Platform.isAndroid) {
      payMethod = "&  Google Pay";
    } else if (Platform.isIOS) {
      // payMethod = "&  Apple Pay";
    }
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
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
                        "${'Credit Card'.tr}  $payMethod",
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
        padding: const EdgeInsets.only(right: 15, top: 5, bottom: 5, left: 5),
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
