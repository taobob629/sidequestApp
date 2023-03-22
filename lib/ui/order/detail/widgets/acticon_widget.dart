/**
    author:mac
    创建日期:2023/3/21
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_confirm.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/im/dialog_comment.dart';
import 'package:wy/ui/order/controller.dart';
import 'package:wy/ui/order/detail/controller.dart';

class ActionWidget extends GetView<OrderDetailPageController> {
  @override
  Widget build(BuildContext context) => actions();

  Widget actions() {
    switch (controller.model?.status) {
      case 1:
        switch (controller.type) {
          case TYPE_ORDER_PROVIDED:
            return container(ColorfulButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "CANCEL".tr,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                ),
              ),
              height: 48,
              onTap: () {
                controller.cancelOrder();
              },
            ));
          case TYPE_ORDER_RECEIVED:
            return container(Row(
              children: [
                Expanded(
                  child: ColorfulButton(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "ACCEPT".tr,
                        style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                      ),
                    ),
                    height: 48,
                    onTap: () {
                      controller.acceptOrder();
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.dialog(CommentDialog(controller.id, () => Get.back(), isRehect: true),
                          barrierColor: Colors.black26);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white24, borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "REJECT".tr,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                            ),
                          ),
                        ),
                        height: 48),
                  ),
                )
              ],
            ));
        }
        break;
      case 9:
        if (controller.type == TYPE_ORDER_RECEIVED) {
          return container(ColorfulButton(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "FINISHED".tr,
                style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
              ),
            ),
            height: 48,
            onTap: () {
              controller.finishOrder();
            },
          ));
        }
        break;
      case 2:
        if (controller.type == TYPE_ORDER_PROVIDED) {
          return container(Row(
            children: [
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "FINISHED".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () {
                    controller.finishOrder();
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "REFUND".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () {
                    Get.dialog(CommentDialog(controller.id, () => Get.back(), isRefund: true),
                        barrierColor: Colors.black26);
                  },
                ),
              ),
            ],
          ));
        }
        break;
      case 3:
        if (UserController.find.userInfoModel?.value.isauth == 1) {
          return container(Row(
            children: [
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "REJECT".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () => controller.dsRejectOrder(),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ColorfulButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "REFUND".tr,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "DIN"),
                    ),
                  ),
                  height: 48,
                  onTap: () => controller.dsRefundOrder(),
                ),
              ),
            ],
          ));
        }
        break;
      default:
        return Container(
          height: 0,
        );
    }
    return Container(
      height: 0,
    );
  }
}

container(Widget view) {
  return Container(
      padding: EdgeInsets.all(16.w), constraints: BoxConstraints(minHeight: 45.h), child: view);
}
