import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/user_api.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/floating_button.dart';
import 'package:wy/ui/common/input_view.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../login/forget_page.dart';

class ChangePasswordPage extends StatelessWidget {
  final int type;
  final bool check;
  final bool have;
  late final ChangePasswordPageController controller;

  ChangePasswordPage({
    required this.type,
    this.check = false,
    this.have = false
  }){
    controller = Get.put(ChangePasswordPageController(type: type, check: check, have: have));
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
                    controller: controller.oldController,
                    textInputType: type == 1 ? TextInputType.visiblePassword : TextInputType.number,
                    inputFormatters: type == 1
                        ? null
                        : [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
                          ],
                    label: type == 1 ? "Old Password".tr : "Old Pin".tr,
                    tips: type == 1 ? "Input your old password".tr : "Input your old pin".tr):Container()
          ),
          InputView(
              controller: controller.newController,
                textInputType: type == 1 ? TextInputType.visiblePassword : TextInputType.number,
                inputFormatters: type == 1
                    ? null
                    : [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
                      ],
                label: type == 1 ? "New Password".tr : "New Pin".tr,
                tips: type == 1 ? "Input your new password".tr : "Input your new pin".tr),
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
              onTap:()=> Get.to(()=>ForgetPage(type: type,)),
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
      )
    );
  }
}

class ChangePasswordPageController extends GetxController{
  
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();

  var have = true.obs;

  int type;
  bool check;

  ChangePasswordPageController({
    required this.type,
    required this.check,
    required bool have
  }){
    this.have.value = have;
  }

  @override
  void onReady() async{
    super.onReady();
    if(type == 2 && check) {
      EasyLoading.show();
      have.value = await UserApi.havePayPassword();
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    oldController.dispose();
    newController.dispose();
    super.onClose();
  }
  
  void updatePassword() async{
    var oldPwd = oldController.text;
    var newPwd = newController.text;
    
    if(newPwd.length < 6) {
      EasyLoading.showToast("Password can not less than 6 characters".tr);
      return;
    }
    EasyLoading.show();
    if(type == 1) {
      bool ret = await UserApi.updateLoginPassword(oldPwd, newPwd);
      if(ret){
        EasyLoading.showSuccess("Success".tr);
        StorageManager.setPassword(newPwd);
        Get.back();
      }
    }else{
      bool ret = await UserApi.updatePayPassword(oldPwd, newPwd);
      if(ret){
        EasyLoading.showSuccess("Success".tr);
        Get.back();
      }
    }

  }
}