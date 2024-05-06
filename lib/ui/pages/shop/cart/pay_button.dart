import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/colorful_button.dart';
import '../../../../controller/cart_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../utils/navigator_helper.dart';
import '../../profile/orders/orders_page.dart';
import 'cart_page.dart';

class PayButton extends StatelessWidget {
  final controller = Get.find<CartController>();
  final cartPageController = Get.find<CartPageController>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black,
      padding: const EdgeInsets.all(
        15,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total".tr,
                style: TextStyle(
                    color: Colors.white38, fontSize: 18, fontFamily: "DIN"),
              ),
              Obx(
                () => Text(
                  "£ ${controller.totalAmount.value.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: Colors.white, fontSize: 30, fontFamily: "DIN"),
                ),
              )
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ColorfulButton(
              height: 56,
              onTap: () {
                if (cartPageController.defaultAddress.value.id == 0) {
                  userController
                      .checkLogin(() => cartPageController.selectAddress());
                  return;
                }
                if (controller.totalAmount.value <= 0) {
                  return;
                }

                userController.checkLogin(() => NavigatorHelper.gotoPayPage(
                    cartPageController.getPayOrderModel(),
                    offPage: true,
                    whenComplete: () => Get.to(() => OrdersPage(
                          initialIndex: 1,
                        ))));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pay".tr,
                  style: TextStyle(
                      color: Colors.white, fontSize: 26, fontFamily: "DIN"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
