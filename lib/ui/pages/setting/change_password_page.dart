import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../api/user_api.dart';
import '../../../api/wy_http.dart';
import '../../../common/base_scaffold.dart';
import '../../../common/floating_button.dart';
import '../../../common/input_view.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import '../login/forget_page.dart';

class ChangePasswordPage extends StatelessWidget {
  final int type;
  final bool check;
  final bool hasPwd;
  late final ChangePasswordPageController controller;

  ChangePasswordPage({
    required this.type,
    this.check = false,
    this.hasPwd = false,
  }) {
    controller = Get.put(ChangePasswordPageController(
      type: type,
      check: check,
      hasPwd: hasPwd,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: type == 1 ? "Account Password".tr : "Payment Pin".tr,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => controller.have.isTrue
                ? InputView(
                    autoHeight: true,
                    controller: controller.oldController,
                    textInputType: type == 1
                        ? TextInputType.visiblePassword
                        : TextInputType.number,
                    inputFormatters: type == 1
                        ? null
                        : [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                            //设置只允许输入数字
                          ],
                    label: type == 1 ? "Old Password".tr : "Old Pin".tr,
                    tips: type == 1
                        ? "Input your current password".tr
                        : "Input your current pin".tr)
                : InputView(
                    autoHeight: true,
                    controller: controller.oldController,
                    textInputType: type == 1
                        ? TextInputType.visiblePassword
                        : TextInputType.number,
                    inputFormatters: type == 1
                        ? null
                        : [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                            //设置只允许输入数字
                          ],
                    label: type == 1 ? "Set Password".tr : "Set Payment Pin".tr,
                    tips: type == 1
                        ? "Set your password".tr
                        : "Set your payment pin".tr)),
            Obx(
              () => controller.have.isTrue
                  ? InputView(
                      autoHeight: true,
                      controller: controller.newController,
                      textInputType: type == 1
                          ? TextInputType.visiblePassword
                          : TextInputType.number,
                      inputFormatters: type == 1
                          ? null
                          : [
                              LengthLimitingTextInputFormatter(6),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                              //设置只允许输入数字
                            ],
                      label: type == 1 ? "New Password".tr : "New Pin".tr,
                      tips: type == 1
                          ? "Input your new password".tr
                          : "Input your new pin".tr)
                  : InputView(
                      autoHeight: true,
                      controller: controller.newController,
                      textInputType: type == 1
                          ? TextInputType.visiblePassword
                          : TextInputType.number,
                      inputFormatters: type == 1
                          ? null
                          : [
                              LengthLimitingTextInputFormatter(6),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'))
                              //设置只允许输入数字
                            ],
                      label: type == 1
                          ? "Confirm Password".tr
                          : "Confirm Payment Pin".tr,
                      tips: type == 1
                          ? "Confirm your new password".tr
                          : "Confirm your new payment pin".tr),
            ),
            Offstage(
              offstage: type == 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "* Only 6 numbers accepted as your payment pin".tr,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => Get.to(() => ForgetPage(
                      type: type,
                      flag: 'payPsd',
                    )),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      "Forgotten?".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FloatingButton(
              label: "CONFIRM".tr,
              onTap: () => controller.updatePassword(),
            )
          ],
        ));
  }
}

class ChangePasswordPageController extends GetxController {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();

  var have = true.obs;

  int type;
  bool check;
  bool hasPwd = false;

  ChangePasswordPageController({
    required this.type,
    required this.check,
    required bool hasPwd,
  }) {
    this.have.value = hasPwd;
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    oldController.dispose();
    newController.dispose();
    super.onClose();
  }

  void updatePassword() async {
    var oldPwd = oldController.text;
    var newPwd = newController.text;

    if (newPwd.length < 6) {
      showToast("Password can not less than 6 characters".tr);
      return;
    }

    showLoading();
    if (!have.value) {
      if (type == 1) {
        bool ret = await UserApi.updateLoginPassword(oldPwd, newPwd);
        dismissLoading();
        if (ret) {
          showSuccess("Success".tr);
          StorageManager.setPassword(newPwd);
          Get.back();
        }
      } else {
        bool ret = await UserApi.updatePayPassword(oldPwd, newPwd);
        dismissLoading();
        if (ret) {
          showSuccess("Success".tr);
          Get.back();
        }
      }
      return;
    }

    if (type == 1) {
      var formData = {
        "pin": newPwd,
        "oldPassword": oldPwd,
      };
      var response =
          await http.get('/peiwan/app/user/setPwd', queryParameters: formData);

      dismissLoading();
      if (response.data == null) {
        showSuccess("Success".tr);
        Get.back();
      }
      return;
    }
    var formData = {
      "pin": newPwd,
      "oldPin": oldPwd,
    };
    var response =
        await http.get('/peiwan/app/user/setPin', queryParameters: formData);

    dismissLoading();
    if (response.data == null) {
      showSuccess("Success".tr);
      Get.back();
    }
  }
}
