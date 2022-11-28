import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/im/play_order.dart';
import 'package:wy/ui/pay/pay_page.dart';
import 'package:wy/utils/navigator_helper.dart';

import '../../model/pay_order_model.dart';

class PayButton extends StatelessWidget {
  final playOrderController = Get.find<PlayOrderController>();

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
                "Balance".tr,
                style: TextStyle(color: Colors.white38, fontSize: 18, fontFamily: "DIN"),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/ic_balance_money.webp",
                    width: 28,
                    height: 28,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "${playOrderController.balance.value.toStringAsFixed(0)}",
                        style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: "DIN"),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pay".tr,
                  style: TextStyle(color: Colors.white, fontSize: 26, fontFamily: "DIN"),
                ),
              ),
              height: 56,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                PayOrderModel model = playOrderController.getPayOrderModel();
                var controller = Get.put(PayPageController(payOrderModel: model));
                await controller.havePassword();
                controller.pay(isPlay: true);
                // NavigatorHelper.gotoPayPage(
                //   model,
                //   // offPage: true,
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}
