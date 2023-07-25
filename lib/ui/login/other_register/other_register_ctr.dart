import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/login_model.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/utils/datetime_utils.dart';

import '../../../api/auth_api.dart';
import '../../../utils/toast_utils.dart';
import '../../common/dialog_selector.dart';
import '../secondary_page.dart';

/**
    author:mac
    创建日期:2023/2/2
    描述:
 */
class OtherRegisterCtr extends GetxController {
  TextEditingController emailEditingController = TextEditingController();

  late Rx<DateTime> birthday = DateTime.now().obs;

  var selectSex = VerifyField.fromJson({
    'name': '',
    'label': '',
  }).obs;

  String? otherEmail;

  AuthorizationCredentialAppleID? credential;

  GoogleSignInAccount? googleSignInAccount;
  String? idToken;

  String? discordAppId;
  String? nickName;
  String? discriminator;

  OtherRegisterCtr();

  @override
  void onInit() {
    super.onInit();
    var params = Get.arguments;
    if (params is AuthorizationCredentialAppleID) {
      // apple sign
      credential = params;
      otherEmail = credential?.email;
    } else {
      // google sign
      googleSignInAccount = params['account'] as GoogleSignInAccount?;
      idToken = params['idToken'] as String?;
      otherEmail = googleSignInAccount?.email;

      if (googleSignInAccount == null) {
        // discord sign
        discordAppId = params['discordAppId'] as String?;
        otherEmail = params['email'] as String?;
        nickName = params['nickName'] as String?;
        discriminator = params['discriminator'] as String?;
      }
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
    String email = emailEditingController.text.toString();

    if (otherEmail == null) {
      if (email.isEmpty) {
        showInfo("Please input a email as your account".tr);
        return;
      }

      if (!email.contains("@")) {
        showInfo("Please input a valid email".tr);
        return;
      }
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

    showLoading();
    LoginModel loginModel;
    if (credential != null) {
      loginModel = await AuthApi.signInApple(
          credential!, '/peiwan/app/user/appleLogin2',
          email: email,
          birth: formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
          sex: selectSex.value.name);
    } else {
      if (googleSignInAccount != null) {
        loginModel = await AuthApi.signInGoogle(
            '/peiwan/app/user/googleLogin2', googleSignInAccount!, idToken,
            birth: formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
            sex: selectSex.value.name);
      } else {
        loginModel = await AuthApi.signInDiscord(
            '/peiwan/app/user/discordLogin2',
            discordAppId,
            otherEmail?.isEmpty == true ? email : otherEmail,
            nickName,
            discriminator,
            birth: formatDate(birthday.value, [dd, '/', mm, '/', yyyy]),
            sex: selectSex.value.name);
      }
    }
    dismissLoading();
    await showSuccess(
        "Congratulations and welcome, please sign in with your new account!"
            .tr);

    loginSuccess(loginModel);
  }

  void loginSuccess(LoginModel loginModel) {
    if (loginModel.validate == 0) {
      UserController.find.setLocalInfo(loginModel, null);
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
