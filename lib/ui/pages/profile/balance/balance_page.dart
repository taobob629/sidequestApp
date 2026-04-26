import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/profile/consume/my_consume_page.dart';

import '../../../../api/balance_api.dart';
import '../../../../common/floating_button.dart';
import '../../../../common/getx_list_controller.dart';
import '../../../../common/keyboard_scaffold.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../model/chage_rule_model.dart';
import '../../../../model/pay_order_model.dart';
import '../../../../model/profile_model.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../utils/toast_utils.dart';
import '../../../../widget/action_button.dart';
import '../../../../widget/paixs_widget.dart';
import 'charge_item.dart';
import 'input_formatter.dart';
import 'item_title.dart';
import 'top_banner.dart';

class BalancePage extends StatelessWidget {
  late final BalancePageController controller;

  BalancePage({double amount = 0.0}) {
    controller = Get.put(BalancePageController(amount: amount));
  }

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "SideQuest Hub".tr,
      actions: [
        ActionButton(
          icon: Icon(
            Icons.list,
            size: 26,
            color: Colors.white,
          ),
          onTap: () => Get.to(() => MyConsumePage()),
        )
      ],
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBanner(),
            _memberVipWidget(),
            Visibility(
              visible: Platform.isAndroid,
              child: ItemTitle(
                title: "Custom amount".tr,
                subTitle: "",
                marginTop: 15.h,
              ),
            ),
            Visibility(
              visible: Platform.isAndroid,
              child: Container(
                height: 46.h,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(left: 15, right: 15, top: 5).r,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: controller.amountController,
                  focusNode: controller.amountFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    isCollapsed: true,
                    hintText: 'Please enter an integer from 5 to 500'.tr,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xFFC5C3C6),
                    fontFamily: FONT_LIGHT,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            ItemTitle(
              title: "Top Up".tr,
              subTitle: "",
              marginTop: 15.h,
            ),
            10.verticalSpace,
            Obx(() => _buildChargeItems(context)),
            PWidget.container(
              PWidget.column([
                PWidget.text('${'Tips'.tr}:', [Color(0xffEEF3FF)]),
                Text(
                  '* These Credits are only used for SideQuest Hub.'.tr,
                  style: TextStyle(color: Color(0xff8291B4)),
                ),
              ]),
              {'pd': 16},
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        child: FloatingButton(
          label: "CONFIRM".tr,
          onTap: () {
            if (controller.productIndex.value == -1) {
              String amountStr = controller.amountController.text;
              double amount = 0.0;
              if (amountStr.isNotEmpty) {
                amount = double.parse(amountStr);
              }
              if (amount < 5 || amount > 500) {
                showToast('Please enter an integer from 5 to 500'.tr);
                return;
              }
            }
            controller.pay();
          },
        ),
      ),
    );
  }

  Widget _memberVipWidget() => Obx(() => Visibility(
        visible: controller.ads.isNotEmpty,
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15).r,
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            gradient: LinearGradient(
              colors: [Color(0xff433B31), Color(0xff262731)],
            ),
          ),
          child: Swiper(
            itemCount: controller.ads.length,
            itemBuilder: (c, i) => ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: ExtendedImage.network(
                controller.ads[i].url,
                fit: BoxFit.fill,
              ),
            ),
            scrollDirection: Axis.vertical,
            autoplay: controller.ads.length > 1 ? true : false,
            onTap: (index) => controller.ads[index].link != null
                ? NavigatorHelper.gotoConfigTarget(controller.ads[index].link!)
                : showError('link is null'.tr),
          ),
        ),
      ));

  Widget _buildChargeItems(BuildContext context) {
    List<Widget> itemList = [];
    int index = 0;
    controller.list.forEach((element) {
      itemList.add(
        ChargeItem(
          index: index,
          item: element,
          selected: index == controller.productIndex.value,
          onTap: (idx) => controller.changeProductIndex(idx),
        ),
      );
      index++;
    });
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.85,
      children: itemList,
    );
  }

  Widget _buildCustomInput() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15).r,
        padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 12.h),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          controller: controller.amountController,
          focusNode: controller.amountFocusNode,
          style: TextStyle(
            color: Colors.white30,
            fontSize: 14.sp,
            fontFamily: "DIN",
          ),
          onSubmitted: (text) => controller.changeCustomAmount(text),
          decoration: InputDecoration(
            hintText: "Please enter an integer from 5 to 500".tr,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.white30,
              fontFamily: "DIN",
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 0),
          ),
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
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(12)),
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
                      "${userController.user.value.email}",
                      style: TextStyle(
                          fontSize: 18,
                          color: controller.accountType.value == 0
                              ? Colors.white
                              : Colors.white30,
                          fontFamily: "DIN"),
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
  var ads = <AdModel>[].obs;

  BalancePageController({double amount = 0.0}) {
    customAmount.value = amount;
  }

  @override
  void onInit() {
    super.onInit();
    amountController = TextEditingController();
    accountController = TextEditingController();
    accountFocusNode = FocusNode();
    amountFocusNode = FocusNode();

    amountFocusNode.addListener(() {
      if (amountFocusNode.hasFocus) {
        changeProductIndex(-1);
      } else {
        if (amountController.text.isEmpty) {
          changeProductIndex(productIndex.value);
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

  Future<List<CoinChargeRuleModel>> loadData() async {
    var chargeRole = await BalanceApi.chargeRule();
    ads.assignAll(chargeRole.ads);
    return chargeRole.pwChargeRules ?? [];
  }

  void changeProductIndex(int index) {
    if (index != -1) {
      amountFocusNode.unfocus();
    }
    productIndex.value = index;
    amountController.clear();
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

  void pay() {
    if (Get.isDialogOpen == true) Get.back();
    PayOrderModel payOrderModel = PayOrderModel();
    String amountStr = amountController.text;
    double amount = 0.0;
    if (amountStr.isNotEmpty) {
      amount = double.parse(amountStr);
    }
    if (amount == 0) {
      CoinChargeRuleModel model = list[productIndex.value];
      amount = double.parse(model.money) * 1.0;
      payOrderModel.chargeid = model.id;
    }

    payOrderModel.goodsPrice = "$amount";
    payOrderModel.totalAmount = "$amount";

    NavigatorHelper.gotoPayPage(payOrderModel, whenComplete: () {
      var userController = Get.find<UserController>();
      userController.updateInfo();
    });
  }
}
