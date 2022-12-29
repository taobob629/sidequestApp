import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_date_time_picker.dart';
import 'package:wy/ui/common/keyboard_scaffold.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/storage_manager.dart';

import '../../model/login_model.dart';
import '../../utils/datetime_utils.dart';
import '../controller/user_controller.dart';
import 'auth_input_view.dart';
import 'birthday_selector.dart';

class RegisterPage extends StatelessWidget {
  late final int type; //1注册 2更新老用户资料

  late final RegisterPageController controller;

  RegisterPage({required this.type, LoginModel? loginModel}) {
    controller =
        Get.put(RegisterPageController(type: type, loginModel: loginModel));
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
                  style: TextStyle(
                      color: Colors.white, fontFamily: "DIN", fontSize: 28),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.step.value == 1
                        ? createStep1()
                        : createStep2(),
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
            style:
                TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
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
            style:
                TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
          ),
        ),
        height: 48,
        onTap: () => controller.signUp(),
      ),
    );
    return list;
  }
}

class RegisterPageController extends GetxController {
  var step = 1.obs;

  late TextEditingController emailEditingController;
  late TextEditingController guardianEditingController;
  late TextEditingController codeEditingController;
  late TextEditingController passwordEditingController;
  late TextEditingController firstEditingController;
  late TextEditingController lastEditingController;
  late TextEditingController nickEditingController;
  late TextEditingController phoneEditingController;
  late TextEditingController inviteEditingController;
  late TextEditingController pinEditingController;

  late FocusNode emailFocusNode;
  late FocusNode codeFocusNode;

  late Rx<DateTime> birthday = DateTime.now().obs;

  String email = "";
  String code = "";
  String password = "";
  String pin = "";
  String firstName = "";
  String lastName = "";
  String nick = "";
  String phone = "";
  String uid = "";
  String invite = "";
  var sex = 0.obs;

  late final int type;
  late final LoginModel? loginModel;
  RegisterPageController({required this.type, this.loginModel});

  @override
  void onInit() {
    super.onInit();
    emailEditingController = TextEditingController();
    codeEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    firstEditingController = TextEditingController();
    lastEditingController = TextEditingController();
    nickEditingController = TextEditingController();
    phoneEditingController = TextEditingController();
    guardianEditingController = TextEditingController();
    inviteEditingController = TextEditingController();
    pinEditingController = TextEditingController();

    emailFocusNode = FocusNode();
    codeFocusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
    emailFocusNode.requestFocus();
    if (loginModel != null) {
      if (loginModel!.user.birth.isNotEmpty) {
        DateTime bd =
            DateFormat('dd/MM/y', 'en_GB').parse(loginModel!.user.birth);
        setBirthday(bd);
      }
      if (loginModel!.user.firstName.isNotEmpty) {
        firstEditingController.text = loginModel!.user.firstName;
      }
      if (loginModel!.user.lastName.isNotEmpty) {
        lastEditingController.text = loginModel!.user.lastName;
      }
      if (loginModel!.user.phone.isNotEmpty) {
        phoneEditingController.text = loginModel!.user.phone;
      }
    }
  }

  @override
  void onClose() {
    emailEditingController.dispose();
    codeEditingController.dispose();
    passwordEditingController.dispose();
    firstEditingController.dispose();
    lastEditingController.dispose();
    nickEditingController.dispose();
    phoneEditingController.dispose();
    guardianEditingController.dispose();
    inviteEditingController.dispose();
    pinEditingController.dispose();

    emailFocusNode.dispose();
    codeFocusNode.dispose();
    super.onClose();
  }

  void changeSex(int? sex) {
    if (sex != null) {
      this.sex.value = sex;
    }
  }

  void gotoStep2() async {
    String email = emailEditingController.text.trim();
    if (email.isEmpty) {
      emailFocusNode.requestFocus();
      EasyLoading.showInfo("Please input a email as your account".tr);
      return;
    }

    if (!email.contains("@")) {
      emailFocusNode.requestFocus();
      EasyLoading.showInfo("Please input a valid email".tr);
      return;
    }

    if (DatetimeUtils.getAge(birthday.value) < 13) {
      EasyLoading.showInfo(
          "Players under the age of 13 will not be able to signup for our services, instead a parent must make the account on their behalf."
              .tr);
      return;
    }

    String guardian = guardianEditingController.text.trim();
    if (DatetimeUtils.getAge(birthday.value) < 16) {
      if (guardian.isEmpty) {
        EasyLoading.showInfo("Please input your guardian email".tr);
        return;
      }
      if (!guardian.contains("@")) {
        EasyLoading.showInfo("Please input a valid guardian email".tr);
        return;
      }
      if (guardian == email) {
        EasyLoading.showError(
            "Guardian email cannot be the same as your account".tr);
        return;
      }
    }
    EasyLoading.show();
    uid = await AuthApi.sendEmail(email, guardian, type);
    if (uid.isNotEmpty) {
      await EasyLoading.showSuccess("Verification code sent".tr,
          duration: Duration(seconds: 2));
      codeFocusNode.requestFocus();
      step.value = 2;
    }
  }

  void setBirthday(DateTime? date) {
    if (date != null) {
      if (DatetimeUtils.getAge(date) < 13) {
        EasyLoading.showError(
            "Players under the age of 13 will not be able to signup for our services, instead a parent must make the account on their behalf."
                .tr,
            duration: Duration(seconds: 4));
        return;
      }
      this.birthday.value = date;
    }
  }

  void signUp() async {
    // Get.offAll(LoginPage());

    email = emailEditingController.text.trim();
    code = codeEditingController.text.trim();
    password = passwordEditingController.text.trim();
    firstName = firstEditingController.text.trim();
    lastName = lastEditingController.text.trim();
    nick = nickEditingController.text.trim();
    phone = phoneEditingController.text.trim();
    invite = inviteEditingController.text.trim();
    pin = pinEditingController.text.trim();

    if (code.isEmpty) {
      EasyLoading.showInfo("Please input your verification code".tr);
      return;
    }

    if (password.length < 6) {
      EasyLoading.showInfo("Password no less than 6 characters".tr);
      return;
    }

    if (firstName.isEmpty) {
      EasyLoading.showInfo("Please input your first name".tr);
      return;
    }

    if (lastName.isEmpty) {
      EasyLoading.showInfo("Please input your last name".tr);
      return;
    }

    if (nick.isEmpty) {
      EasyLoading.showInfo("Please input your nick name".tr);
      return;
    }

    if (phone.isEmpty) {
      EasyLoading.showInfo("Please input your phone number".tr);
      return;
    }

    if (pin.length < 6) {
      EasyLoading.showInfo("Only 6 numbers accepted as your payment pin".tr);
      return;
    }

    EasyLoading.show();
    if (type == 1) {
      await AuthApi.signUp(
          firstName,
          lastName,
          nick,
          phone,
          email,
          formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
          password,
          code,
          uid,
          pin,
          invite,
          sex.value);
      await EasyLoading.showSuccess(
          "Congratulations and welcome, please sign in with your new account!"
              .tr,
          duration: Duration(seconds: 3));
    } else {
      await AuthApi.updateProfile(
          password,
          firstName,
          lastName,
          nick,
          phone,
          email,
          formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
          code,
          uid,
          pin,
          loginModel!.token);
      StorageManager.setAccount(email);
      StorageManager.setPassword(password);
      UserController userController = Get.find<UserController>();
      await userController.login();
      await EasyLoading.showSuccess(
          "Congratulations and welcome, your profile has been updated!".tr,
          duration: Duration(seconds: 3));
    }
    Get.offAll(LoginPage());
    // Get.back();
  }
}
