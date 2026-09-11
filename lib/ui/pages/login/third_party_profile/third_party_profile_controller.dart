import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api/auth_api.dart';
import '../../../../controller/user_controller.dart';
import '../../../../utils/datetime_utils.dart';
import '../../../../utils/login_flag.dart';
import '../../../../utils/storage_manager.dart';
import '../../../../utils/toast_utils.dart';
import '../login_page.dart';
import '../welcome/new_user_welcome_page.dart';

class ThirdPartyProfileController extends GetxController {
  final nickNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final paymentPinController = TextEditingController();
  final dialCode = '+44'.obs;
  final gender = ''.obs;
  final birthday = Rxn<DateTime>();

  String provider = LoginFlag.google;
  String providerEmail = '';

  bool get requiresEmail => provider == LoginFlag.ios;

  DateTime get latestAllowedBirthday {
    final now = DateTime.now();
    final year = now.year - 13;
    final day = now.day.clamp(1, DateUtils.getDaysInMonth(year, now.month));
    return DateTime(year, now.month, day);
  }

  String get birthdayText {
    final value = birthday.value;
    if (value == null) return '';
    return formatDate(value, [dd, '/', mm, '/', yyyy]);
  }

  @override
  void onInit() {
    super.onInit();
    provider = StorageManager.getString('loginFlag') ?? LoginFlag.google;
    final params = Get.arguments;
    if (params is Map) {
      provider = (params['provider'] as String?) ?? provider;
      providerEmail = (params['email'] as String?) ?? '';
    }
  }

  @override
  void onClose() {
    nickNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    paymentPinController.dispose();
    super.onClose();
  }

  void selectGender(String value) {
    gender.value = value;
  }

  void selectBirthday(DateTime? value) {
    if (value == null) return;
    if (DatetimeUtils.getAge(value) < 13) {
      showInfo(
        'Players under the age of 13 will not be able to signup for our services, instead a parent must make the account on their behalf.'
            .tr,
      );
      return;
    }
    birthday.value = value;
  }

  void backToLogin() {
    Get.offAll(() => LoginPage());
  }

  Future<void> submit() async {
    final email = requiresEmail
        ? emailController.text.trim()
        : providerEmail.trim();
    final phoneNumber = phoneController.text.trim();
    final phone = '${dialCode.value} $phoneNumber';
    final nickName = nickNameController.text.trim();
    final password = passwordController.text;
    final paymentPin = paymentPinController.text;

    if (nickName.isEmpty) {
      showInfo('Please input your Nick Name'.tr);
      return;
    }
    if (requiresEmail && (email.isEmpty || !email.contains('@'))) {
      showInfo('Please input a valid email'.tr);
      return;
    }
    if (phoneNumber.replaceAll(RegExp(r'\D'), '').length < 7 ||
        !RegExp(r'^\+?[0-9 ()-]{7,25}$').hasMatch(phone)) {
      showInfo('Please input a valid phone number with country code'.tr);
      return;
    }
    if (gender.value.isEmpty) {
      showInfo('Please select your gender'.tr);
      return;
    }
    final selectedBirthday = birthday.value;
    if (selectedBirthday == null) {
      showInfo('Please select your date of birth'.tr);
      return;
    }
    if (DatetimeUtils.getAge(selectedBirthday) < 13) {
      showInfo(
        'Players under the age of 13 will not be able to signup for our services, instead a parent must make the account on their behalf.'
            .tr,
      );
      return;
    }
    if (password.length < 8) {
      showInfo('Password must contain at least 8 characters'.tr);
      return;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(paymentPin)) {
      showInfo('Payment PIN must contain 6 digits'.tr);
      return;
    }

    showLoading(clickMaskDismiss: false);
    try {
      final loginModel = await AuthApi.completeThirdPartyProfile(
        email: email,
        nickName: nickName,
        phone: phone,
        sex: gender.value,
        password: password,
        paymentPin: paymentPin,
        birth: birthdayText,
      );
      dismissLoading();
      UserController.find.setLocalInfo(
        loginModel,
        null,
        loginFlag: provider,
        password: password,
      );
      Get.offAll(
        () => NewUserWelcomePage(
          nickName: nickName,
          memberCode: loginModel.user.memberCode,
        ),
      );
    } catch (e) {
      dismissLoading();
      showError(e.toString());
    }
  }
}
