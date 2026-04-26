import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sq_hub_app/ui/pages/login/login_page.dart';
import 'package:sq_hub_app/ui/pages/register/register_page.dart';
import 'package:sq_hub_app/utils/storage_manager.dart';

import '../../../api/auth_api.dart';
import '../../../controller/user_controller.dart';
import '../../../model/login_model.dart';
import '../../../utils/datetime_utils.dart';
import '../../../utils/toast_utils.dart';
import '../login/choose_game/view.dart';
import '../main_page.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */

class RegisterPageController extends GetxController {
  static RegisterPageController get find => Get.find();

  var step = 1.obs;

  late TextEditingController emailEditingController;
  late TextEditingController guardianEditingController;
  late TextEditingController codeEditingController;
  late TextEditingController passwordEditingController;
  late TextEditingController firstEditingController;
  late TextEditingController lastEditingController;
  late TextEditingController nickEditingController;
  late TextEditingController phoneEditingController;
  late TextEditingController pinEditingController;

  late FocusNode emailFocusNode;
  late FocusNode codeFocusNode;

  late Rx<DateTime> birthday = DateTime.now().obs;

  String email = "";
  String code = "";
  String password = "";
  String pin = "";

//  String firstName = "";
  // String lastName = "";
  String nick = "";
  String phone = "";
  var uid = "".obs;
  var sex = 0.obs;

  Timer? _timer;
  var codeCountDown = 60.obs;

  late int type;
  late final LoginModel? loginModel;

  RegisterPageController();

  @override
  void onInit() {
    super.onInit();
    var params = Get.arguments;
    type = params['type'];
    loginModel = params['loginModel'];
    emailEditingController = TextEditingController();
    codeEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    firstEditingController = TextEditingController();
    lastEditingController = TextEditingController();
    nickEditingController = TextEditingController();
    phoneEditingController = TextEditingController();
    guardianEditingController = TextEditingController();
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
    pinEditingController.dispose();

    emailFocusNode.dispose();
    codeFocusNode.dispose();
    _timer?.cancel();
    _timer = null;
    super.onClose();
  }

  void changeSex(int? sex) {
    if (sex != null) {
      this.sex.value = sex;
    }
  }

  bool verifyEmail(bool verifyBirthday) {
    email = emailEditingController.text.trim();
    if (email.isEmpty) {
      emailFocusNode.requestFocus();
      showInfo("Please input a email as your account".tr);
      return false;
    }

    if (!email.contains("@")) {
      emailFocusNode.requestFocus();
      showInfo("Please input a valid email".tr);
      return false;
    }

    if (verifyBirthday && DatetimeUtils.getAge(birthday.value) < 13) {
      showInfo(
        "Players under the age of 13 will not be able to signup for our services, instead a parent must make the account on their behalf."
            .tr,
      );
      return false;
    }
    String guardian = guardianEditingController.text.trim();
    if (verifyBirthday && DatetimeUtils.getAge(birthday.value) < 16) {
      if (guardian.isEmpty) {
        showInfo(
          "Please input your guardian email".tr,
        );
        return false;
      }
      if (!guardian.contains("@")) {
        showInfo(
          "Please input a valid guardian email".tr,
        );
        return false;
      }
      if (guardian == email) {
        showInfo("Guardian email cannot be the same as your account".tr);
        return false;
      }
    }
    return true;
  }

  void sendEmail() async {
    if (_timer?.isActive == true) return;

    if (!verifyEmail(false)) return;

    showLoading();
    uid.value = await AuthApi.sendEmail(
        email, guardianEditingController.text.trim(), type);
    dismissLoading();
    if (uid.isNotEmpty) {
      codeCountDown.value--;
      showSuccess(
        "Verification code sent".tr,
      );

      _timer = Timer.periodic(const Duration(seconds: 1), (v) {
        if (codeCountDown.value > 0) {
          codeCountDown.value--;
        } else {
          _timer?.cancel();
          codeCountDown.value = 60;
        }
      });
    }
  }

  void gotoStep2() async {
    if (!verifyEmail(true)) return;

    if (uid.isEmpty) {
      showInfo(
        "Please send your verification code".tr,
      );
      return;
    }

    code = codeEditingController.text.trim();

    if (code.isEmpty) {
      showInfo(
        "Please input your verification code".tr,
      );
      return;
    }

    showLoading();
    bool ifSuccess = await AuthApi.verifyCode(code, uid.value);
    dismissLoading();
    if (ifSuccess) {
      codeFocusNode.requestFocus();
      step.value = 2;
    } else {
      showError('verification code incorrect'.tr);
    }
  }

  void setBirthday(DateTime? date) {
    if (date != null) {
      if (DatetimeUtils.getAge(date) < 13) {
        showInfo(
            "Players under the age of 13 will not be able to signup for our services, instead a parent must make the account on their behalf."
                .tr);
        return;
      }
      this.birthday.value = date;
    }
  }

  void signUp() async {
    // Get.offAll(LoginPage());

    email = emailEditingController.text.trim();
    password = passwordEditingController.text.trim();
    //firstName = firstEditingController.text.trim();
    // lastName = lastEditingController.text.trim();
    nick = nickEditingController.text.trim();
    phone = phoneEditingController.text.trim();
    pin = pinEditingController.text.trim();

    if (password.length < 6) {
      showInfo(
        "Password no less than 6 characters".tr,
      );
      return;
    }

    // if (firstName.isEmpty) {
    //   showInfo("Please input your first name".tr);
    //   return;
    // }
    //
    // if (lastName.isEmpty) {
    //   showInfo("Please input your last name".tr);
    //   return;
    // }

    if (nick.isEmpty) {
      showInfo(
        "Please input your nick name".tr,
      );
      return;
    }

    if (phone.isEmpty) {
      showInfo(
        "Please input your phone number".tr,
      );
      return;
    }

    if (pin.length < 6) {
      showInfo(
        "Only 6 numbers accepted as your payment pin".tr,
      );
      return;
    }

    showLoading();
    if (type == 1) {
      LoginModel loginModel = await AuthApi.signUp2(
          // firstName,
          // lastName,
          nick,
          phone,
          email,
          formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
          password,
          code,
          uid.value,
          pin,
          sex.value);
      showSuccess(
          "Congratulations and welcome, please sign in with your new account!"
              .tr);
      UserController.find.setLocalInfo(
        loginModel,
        (loginModel) => loginSuccess(loginModel),
        password: password,
      );
    } else {
      await AuthApi.updateProfile(
          password,
          nick,
          phone,
          email,
          formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
          code,
          uid.value,
          pin,
          loginModel!.token);
      dismissLoading();
      StorageManager.setAccount(email);
      StorageManager.setPassword(password);
      UserController userController = Get.find<UserController>();
      await userController.login();
      await showSuccess(
          "Congratulations and welcome, your profile has been updated!".tr);
      Get.offAll(() => LoginPage(), arguments: Map()..['fromRegister'] = true);
    }
  }

  void loginSuccess(LoginModel loginModel) {
    dismissLoading();
    if (loginModel.validate == 0) {
      //如果是从登录页面跳转的，跳转到选择游戏页面先
      // var fromRegister = Get.arguments?['fromRegister'];
      // if (fromRegister == true) {
      //   Get.offAll(() => ChooseGamesPage());
      //   return;
      // }
      Get.offAll(() => MainPage());
    } else {
      Get.to(
            () => RegisterPage(),
        arguments: {}
          ..['type'] = 1
          ..['loginModel'] = loginModel,
      );
    }
  }

}
