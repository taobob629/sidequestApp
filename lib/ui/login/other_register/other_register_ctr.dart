import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wy/api/auth_api.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/datetime_utils.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';

import '../../../utils/toast_utils.dart';
import '../../common/dialog_selector.dart';
import '../secondary_page.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */

class OtherRegisterCtr extends GetxController {
  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;
  late TextEditingController nickEditingController;
  late TextEditingController phoneEditingController;
  late TextEditingController inviteEditingController;
  late TextEditingController pinEditingController;

  late FocusNode emailFocusNode;
  late FocusNode codeFocusNode;

  late Rx<DateTime> birthday = DateTime.now().obs;

  String email = "";
  String password = "";
  String pin = "";

//  String firstName = "";
  // String lastName = "";
  String nick = "";
  String phone = "";
  String uid = "";
  String invite = "";

  var selectSex = VerifyField.fromJson({
    'name': '',
    'label': '',
  }).obs;

  AuthorizationCredentialAppleID? credential;

  GoogleSignInAccount? googleSignInAccount;
  String? idToken;

  OtherRegisterCtr();

  @override
  void onInit() {
    super.onInit();
    var params = Get.arguments;
    if (params is AuthorizationCredentialAppleID) {
      // apple sign
      credential = params;
      emailEditingController = TextEditingController(
          text: credential != null ? credential!.email : '');
    } else if (params is Map) {
      // google sign
      googleSignInAccount = params['account'] as GoogleSignInAccount;
      idToken = params['idToken'];
      emailEditingController = TextEditingController(
          text: googleSignInAccount != null ? googleSignInAccount!.email : '');
    } else {
      emailEditingController = TextEditingController();
    }
    passwordEditingController = TextEditingController();
    nickEditingController = TextEditingController();
    phoneEditingController = TextEditingController();
    inviteEditingController = TextEditingController();
    pinEditingController = TextEditingController();

    emailFocusNode = FocusNode();
    codeFocusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
    emailFocusNode.requestFocus();
  }

  @override
  void onClose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    nickEditingController.dispose();
    phoneEditingController.dispose();
    inviteEditingController.dispose();
    pinEditingController.dispose();

    emailFocusNode.dispose();
    codeFocusNode.dispose();
    super.onClose();
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

  void selectGender() async {
    final result = await Get.dialog(
      SelectorDialog(
        items: [
          VerifyField.fromJson({
            'name': '0',
            'label': 'Male'.tr,
          }),
          VerifyField.fromJson({
            'name': '1',
            'label': 'Female'.tr,
          }),
        ],
        title: "Select Gender".tr,
        showInfo: true,
      ),
      barrierColor: Colors.black26,
    );
    if (result != null) {
      selectSex.value = result as VerifyField;
    }
  }

  void signUp() async {
    // Get.offAll(LoginPage());

    email = emailEditingController.text.trim();
    password = passwordEditingController.text.trim();
    //firstName = firstEditingController.text.trim();
    // lastName = lastEditingController.text.trim();
    nick = nickEditingController.text.trim();
    // phone = phoneEditingController.text.trim();
    invite = inviteEditingController.text.trim();
    pin = pinEditingController.text.trim();

    if (email.isEmpty) {
      emailFocusNode.requestFocus();
      showInfo("Please input a email as your account".tr);
      return;
    }

    if (!email.contains("@")) {
      emailFocusNode.requestFocus();
      showInfo("Please input a valid email".tr);
      return;
    }

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

    if (password.length < 6) {
      showInfo(
        "Password no less than 6 characters".tr,
      );
      return;
    }

    if (DatetimeUtils.getAge(birthday.value) < 13) {
      showInfo(
        "Players under the age of 13 will not be able to signup for our services, instead a parent must make the account on their behalf."
            .tr,
      );
      return;
    }

    if (selectSex.value.name == '') {
      showInfo(
        "Please select your gender".tr,
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
    LoginModel loginModel;
    if (credential != null) {
      // loginModel = await AuthApi.signInApple(
      //   credential,
      //   nick,
      //   phone,
      //   email,
      //   formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
      //   password,
      //   uid,
      //   pin,
      //   invite,
      //   int.parse(selectSex.value.name),
      // );
    } else {
      // loginModel = await AuthApi.signInGoogle(
      //   googleSignInAccount,
      //   idToken,
      //   nick,
      //   phone,
      //   email,
      //   formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
      //   password,
      //   uid,
      //   pin,
      //   invite,
      //   int.parse(selectSex.value.name),
      // );
    }
    dismissLoading();
    await showSuccess(
        "Congratulations and welcome, please sign in with your new account!"
            .tr);

    // loginSuccess(loginModel);
  }

  void loginSuccess(LoginModel loginModel) {
    if (loginModel.validate == 0) {
      UserController.find.setLocalInfo(loginModel, null, null);
      UserController.find.imLogin();
      Get.offAndToNamed(AppPages.Main);
    } else {
      if (loginModel.secondary == 1) {
        Get.off(() => SecondaryPage(
              loginModel: loginModel,
            ));
      } else {
        Get.toNamed(AppPages.REGISTER,
            arguments: Map()
              ..['type'] = 1
              ..['loginModel'] = loginModel);
      }
    }
  }
}
