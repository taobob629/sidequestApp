import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';

import '../../utils/storage_manager.dart';
import '../../utils/toast_utils.dart';
import 'auth_input_view.dart';

class ForgetPage extends StatelessWidget {

  //1登录 2支付
  final int type;
  final String flag;
  late final ForgetPageController controller;

  ForgetPage({required this.type, this.flag = ''}){
    controller = Get.put(ForgetPageController(type: type));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
      title: "Retrieve".tr,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "${'RETRIEVE'.tr} ${type == 1 ? '${'PASSWORD'.tr}' : '${'PIN'.tr}'}",
                  style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 28),
                ),
              SizedBox(height: 10,),
              Obx((){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.step.value == 1 ? createStep1() : createStep2(),
                );
              })
            ],
          ),
        ),
      )
    );
  }

  List<Widget> createStep1(){
    List<Widget> list = [];
    list.add(AuthInputView(
      tips: "Your sign in account email".tr,
      editingController: controller.emailEditingController,
      focusNode: controller.emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.go,
      onSubmitted: (value) => controller.gotoStep2(),
      readOnly: 'payPsd' == flag,
    ));
    list.add(SizedBox(height: 100,));
    list.add(ColorfulButton(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
          child: Text(
            "SEND VERIFICATION CODE".tr,
            style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
          ),
        ),
      height: 48,
      onTap: ()=>controller.gotoStep2(),
    ),);
    return list;
  }

  List<Widget> createStep2(){
    List<Widget> list = [];
    list.add(AuthInputView(
      tips: "Verification code from your email".tr,
      editingController: controller.codeEditingController,
      focusNode: controller.codeFocusNode,
      keyboardType: TextInputType.number,
    ));
    list.add(SizedBox(height: 20,));
    list.add(AuthInputView(
      tips: "${'New'.tr} ${type == 1 ? 'password'.tr : 'pin'.tr}",
      editingController: controller.passwordEditingController,
      keyboardType: type == 1 ?TextInputType.text:TextInputType.number,
      inputFormatters: type == 1
          ? null
          : [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
            ],
    ));
    list.add(Offstage(
      offstage: type == 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 10),
        child: Text(
          "* Only 6 numbers accepted as your payment pin".tr,
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ),
    ));
    list.add(SizedBox(height: 100,));
    list.add(ColorfulButton(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
          child: Text(
            "CONFIRM".tr,
            style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
          ),
        ),
      height: 48,
      onTap: ()=>controller.savePassword(),
    ),);
    return list;
  }
}

class ForgetPageController extends GetxController {
  var step = 1.obs;

  late TextEditingController emailEditingController;
  late TextEditingController codeEditingController;
  late TextEditingController passwordEditingController;

  late FocusNode emailFocusNode;
  late FocusNode codeFocusNode;

  late final int type;

  ForgetPageController({required this.type});

  String email = "";
  String code = "";
  String password = "";

  String uid = "";

  @override
  void onInit() {
    super.onInit();
    emailEditingController = TextEditingController();
    codeEditingController = TextEditingController();
    passwordEditingController = TextEditingController();

    emailFocusNode = FocusNode();
    codeFocusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
    //emailFocusNode.requestFocus();
    String account = StorageManager.getAccount();
    emailEditingController.text = account;
  }

  @override
  void onClose() {
    emailEditingController.dispose();
    codeEditingController.dispose();
    passwordEditingController.dispose();

    emailFocusNode.dispose();
    codeFocusNode.dispose();
    super.onClose();
  }

  void gotoStep2() async{
    String email = emailEditingController.text;
    if(email.isEmpty){
      emailFocusNode.requestFocus();
      showToast("Please input a email as your account".tr);
      return;
    }
    showLoading();
    if (type == 1) {
      uid = await AuthApi.resendEmail(email);
    } else {
      uid = await AuthApi.resendPinEmail(email);
    }
    await showSuccess("Verification code sent".tr, duration: Duration(seconds: 2));
    codeFocusNode.requestFocus();
    step.value = 2;
  }

  void savePassword() async{
    email = emailEditingController.text;
    code = codeEditingController.text;
    password = passwordEditingController.text;

    if(code.isEmpty){
      showToast("Please input your verification code".tr);
      return;
    }

    if(password.length < 6) {
      if(type == 1) {
        showToast("Password no less than 6 characters".tr);
        return;
      }else{
        showInfo("Only 6 numbers accepted as your payment pin".tr,);
        return;
      }
    }

    showLoading();
    if (type == 1) {
      await AuthApi.reset(email, password, code, uid);
    } else {
      await AuthApi.resetPin(email, password, code, uid);
    }
    await showSuccess("${'Your'.tr} ${type == 1 ? 'password'.tr : 'pin'.tr} ${'has been successfully reset!'.tr}", duration: Duration(seconds: 2));
    Get.back();
  }
}