import 'package:date_format/date_format.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/utils/datetime_utils.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */

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

  late int type;
  late final LoginModel? loginModel;

  RegisterPageController();

  @override
  void onInit() {
    super.onInit();
    var params = Get.arguments;
    flog('params  $params');
    type = params['type'];
    loginModel = params['loginModel'];
    flog('loginModel $loginModel');
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
        DateTime bd = DateFormat('dd/MM/y', 'en_GB').parse(loginModel!.user.birth);
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
        EasyLoading.showError("Guardian email cannot be the same as your account".tr);
        return;
      }
    }
    EasyLoading.show();
    uid = await AuthApi.sendEmail(email, guardian, type);
    if (uid.isNotEmpty) {
      await EasyLoading.showSuccess("Verification code sent".tr, duration: Duration(seconds: 2));
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
          "Congratulations and welcome, please sign in with your new account!".tr,
          duration: Duration(seconds: 3));
    } else {
      await AuthApi.updateProfile(password, firstName, lastName, nick, phone, email,
          formatDate(birthday.value, [dd, '/', mm, '/', yyyy]), code, uid, pin, loginModel!.token);
      StorageManager.setAccount(email);
      StorageManager.setPassword(password);
      UserController userController = Get.find<UserController>();
      await userController.login();
      await EasyLoading.showSuccess(
          "Congratulations and welcome, your profile has been updated!".tr,
          duration: Duration(seconds: 3));
    }
    Get.offNamedUntil(AppPages.Login, ModalRoute.withName(AppPages.Login) ,arguments: Map()..['fromRegister'] = true);
    // Get.back();
  }
}
