import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_date_time_picker.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/login/auth_input_view.dart';
import 'package:wy/ui/login/birthday_selector.dart';
import 'package:wy/ui/login/register_page.dart';
import 'package:wy/utils/datetime_utils.dart';

class RegisterPage extends GetView<RegisterPageController> {
  late final int type; //1注册 2更新老用户资料

  late final RegisterPageController controller;

  RegisterPage({required this.type, LoginModel? loginModel}) {
    controller = Get.put(RegisterPageController(type: type, loginModel: loginModel));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardScaffold(
        title: type == 1 ? "Sign Up".tr : "Update Profile".tr,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Profile Information",
                  style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 28),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.step.value == 1 ? createStep1() : createStep2(),
                  );
                })
              ],
            ),
          ),
        ));
  }

  List<Widget> createStep1() {
    List<Widget> list = [];
    list.add(AuthInputView(
      tips: "Account Email",
      editingController: controller.emailEditingController,
      focusNode: controller.emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.go,
      onSubmitted: (value) => controller.gotoStep2(),
    ));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(Obx(() => BirthdaySelector(
          value: controller.birthday.value,
          onTap: () => Get.dialog<DateTime?>(
                  DateTimePickerDialog(
                    maxDateTime: DateTime.now(),
                    initDateTime: controller.birthday.value,
                  ),
                  barrierColor: Colors.black26)
              .then((value) {
            controller.setBirthday(value);
          }),
        )));
    list.add(Obx(() => Offstage(
          offstage: DatetimeUtils.getAge(controller.birthday.value) >= 16 ||
              DatetimeUtils.getAge(controller.birthday.value) == 0,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              AuthInputView(
                tips: "Guardian Email".tr,
                editingController: controller.guardianEditingController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) => controller.gotoStep2(),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Players under the age of 16 must provide an emergency contact in order to use our services and sign up."
                      .tr,
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ),
            ],
          ),
        )));
    list.add(SizedBox(
      height: 100,
    ));
    list.add(
      ColorfulButton(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "SEND VERIFICATION CODE".tr,
            style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
          ),
        ),
        height: 48,
        onTap: () => controller.gotoStep2(),
      ),
    );
    return list;
  }

  List<Widget> createStep2() {
    List<Widget> list = [];
    list.add(AuthInputView(
      tips: "Verification code from your email".tr,
      editingController: controller.codeEditingController,
      focusNode: controller.codeFocusNode,
      keyboardType: TextInputType.number,
    ));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(Row(
      children: [
        Expanded(
          flex: 1,
          child: AuthInputView(
            tips: "First Name".tr,
            editingController: controller.firstEditingController,
            keyboardType: TextInputType.name,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: AuthInputView(
            tips: "Last Name".tr,
            editingController: controller.lastEditingController,
            keyboardType: TextInputType.name,
          ),
        )
      ],
    ));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(AuthInputView(
      tips: "Nick Name".tr,
      editingController: controller.nickEditingController,
      keyboardType: TextInputType.name,
    ));
    list.add(SizedBox(
      height: 10,
    ));
    list.add(Row(
      children: [
        Radio<int>(
            value: 0,
            groupValue: controller.sex.value,
            onChanged: (value) => controller.changeSex(value)),
        Text(
          "Male".tr,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        Radio<int>(
            value: 1,
            groupValue: controller.sex.value,
            onChanged: (value) => controller.changeSex(value)),
        Text(
          "Female".tr,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        Radio<int>(
            value: 2,
            groupValue: controller.sex.value,
            onChanged: (value) => controller.changeSex(value)),
        Text(
          "Non-binary".tr,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        // Radio<int>(value: 2, groupValue: controller.sex.value, onChanged: (value)=>controller.changeSex(value)),
        // Text("Others",style: TextStyle(color: Colors.white,fontSize: 14),),
      ],
    ));
    list.add(SizedBox(
      height: 10,
    ));
    list.add(AuthInputView(
      tips: "Phone Number".tr,
      editingController: controller.phoneEditingController,
      keyboardType: TextInputType.phone,
    ));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(AuthInputView(
        tips: "Login Password".tr,
        editingController: controller.passwordEditingController,
        keyboardType: TextInputType.visiblePassword));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(
      AuthInputView(
          editingController: controller.pinEditingController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
          ],
          tips: "Payment Pin".tr),
    );
    if (type == 1) {
      list.add(SizedBox(
        height: 20,
      ));
      list.add(AuthInputView(
          tips: "Invite Code (Optional)".tr,
          editingController: controller.inviteEditingController,
          keyboardType: TextInputType.text));
    }
    list.add(SizedBox(
      height: 40,
    ));
    list.add(
      ColorfulButton(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            type == 1 ? "SIGN UP" : "UPDATE",
            style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
          ),
        ),
        height: 48,
        onTap: () => controller.signUp(),
      ),
    );
    return list;
  }
}
