import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/config/app_pages.dart';

import '../../model/login_model.dart';
import '../../model/user_model.dart';
import '../common/colorful_button.dart';
import '../common/dialog_selector.dart';
import '../common/input_view.dart';
import '../common/keyboard_scaffold.dart';
import '../common/select_view.dart';
import 'register_page.dart';

class SecondaryPage extends StatelessWidget {

  late final LoginModel loginModel;

  late final SecondaryPageController controller;

  SecondaryPage({required this.loginModel}){
    controller = Get.put(SecondaryPageController(loginModel: loginModel));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "Account Validation".tr,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Validate Information".tr,
                  style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 28),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectView(
                        label: "Validate by".tr,
                        tips: "",
                        value: "${controller.way.value}",
                        onTap: () {
                          Get.dialog(
                                  SelectorDialog(
                                    items: controller.loginModel.verifyFieldList,
                                    title: "Validate By".tr,
                                  ),
                                  barrierColor: Colors.black26)
                              .then((value) {
                            if (value != null) {
                              controller.selectWay(value);
                            }
                          });
                        },
                    ),
                    SizedBox(height: 20,),
                    InputView(
                        label: "Validate information".tr,
                        tips: 'Please input your'.tr + "${controller.way.value}",
                        controller: controller.validateEditingController,
                      ),
                    SizedBox(height: 100,),
                    ColorfulButton(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "CONFIRM".tr,
                            style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
                          ),
                        ),
                      height: 48,
                      onTap: ()=>controller.validate(),
                    )
                  ],
                );
              })
            ],
          ),
        ),
      )
    );
  }
}

class SecondaryPageController extends GetxController{
  var way = "".obs;

  late VerifyField fieldSelect;

  LoginModel loginModel;
  late TextEditingController validateEditingController;

  SecondaryPageController({required this.loginModel});

  @override
  void onInit() {
    super.onInit();
    validateEditingController = TextEditingController();
    if(loginModel.verifyFieldList.isNotEmpty) {
      way.value =loginModel.verifyFieldList[0].label;
      fieldSelect = loginModel.verifyFieldList[0];
    }
  }

  @override
  void onClose() {
    validateEditingController.dispose();
    super.onClose();
  }

  void selectWay(VerifyField model){
    this.way.value = model.label;
    fieldSelect = model;
  }

  void validate() async{
    String data = validateEditingController.text;
    if (data.isEmpty) {
      EasyLoading.showInfo('Please input your'.tr + " $way");
      return;
    }
    EasyLoading.show();

    UserModel userModel = await AuthApi.validateInfo(fieldSelect.name, data, loginModel.token);
    EasyLoading.dismiss();
    loginModel.user = userModel;
    Get.offAndToNamed(AppPages.REGISTER,
        arguments: Map()
          ..['type'] = 2
          ..['loginModel'] = loginModel);
    //  Get.off(()=>RegisterPage(type: 2,loginModel: loginModel,));
  }
}