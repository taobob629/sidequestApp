import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';

import '../../../api/wy_http.dart';
import '../../../utils/toast_utils.dart';

class SetPasswordPage extends StatelessWidget {
  late final SetPasswordPageController controller;

  SetPasswordPage() {
    controller = Get.put(SetPasswordPageController());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "Payment Pin".tr,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputView(
                autoHeight: true,
                controller: controller.oldController,
                textInputType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  //设置只允许输入数字
                ],
                label: "Input Payment Pin".tr,
                tips: "Input your payment pin".tr),
            InputView(
                autoHeight: true,
                controller: controller.newController,
                textInputType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  //设置只允许输入数字
                ],
                label: "Confirm Payment Pin".tr,
                tips: "Confirm your payment pin".tr),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "* Only 6 numbers accepted as your payment pin".tr,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingButton(
          label: "CONFIRM".tr,
          onTap: () => controller.setPin(),
        ));
  }
}

class SetPasswordPageController extends GetxController {
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();

  @override
  void onClose() {
    oldController.dispose();
    newController.dispose();
    super.onClose();
  }

  void setPin() async {
    var oldPwd = oldController.text;
    var newPwd = newController.text;

    if (newPwd.length < 6) {
      showToast("Password can not less than 6 characters".tr);
      return;
    }
    if (oldPwd != newPwd) {
      showToast("The two passwords do not match".tr);
      return;
    }

    showLoading();
    var formData = {
      "pin": oldPwd,
    };
    final response = await http.get('/peiwan/app/user/setPin', queryParameters: formData);

    dismissLoading();
    if (response.statusCode == 200) {
      showSuccess("Success".tr);
      Get.back();
    }
  }
}
