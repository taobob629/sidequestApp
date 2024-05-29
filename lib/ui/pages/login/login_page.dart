import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/ui/pages/main_page.dart';
import 'package:sq_hub_app/ui/pages/register/register_page.dart';

import '../../../common/base_controller.dart';
import '../../../common/colorful_button.dart';
import '../../../common/keyboard_visibility_scaffold.dart';
import '../../../common/privacy_check.dart';
import '../../../config/icon_font.dart';
import '../../../controller/user_controller.dart';
import '../../../image_utils.dart';
import '../../../model/login_model.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import 'auth_input_view.dart';
import 'choose_game/view.dart';
import 'forget_page.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginPageController());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityScaffold(builder: (context, keyboardShow) {
      return Scaffold(
        // title: keyboardShow ? "Sign In".tr : "",
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  40.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.offAll(() => MainPage());
                          },
                          icon: Icon(
                            Icons.close,
                            size: 17.w,
                            color: AppColor.whiteGray,
                          ))
                    ],
                  ),
                  100.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Offstage(
                          offstage: keyboardShow,
                          child: Text(
                            "LOG IN".tr,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontFamily: "DIN",
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          "Enter your SideQuest ID,email to sign in".tr,
                          style: TextStyle(
                            color: hexColor('#C5C3C6'),
                            fontFamily: "DIN",
                            fontSize: 16.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        30.verticalSpace,
                        AuthInputView(
                          tips: "SideQuest ID / Email".tr,
                          editingController: controller.emailEditingController,
                          textInputAction: TextInputAction.next,
                          focusNode: controller.emailFocusNode,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthInputView(
                            tips: "Password".tr,
                            password: true,
                            editingController:
                                controller.passwordEditingController,
                            textInputAction: TextInputAction.go,
                            focusNode: controller.passwordFocusNode),
                        10.verticalSpace,
                        GestureDetector(
                          onTap: () => Get.to(() => ForgetPage(
                                type: 1,
                              )),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              "Forgotten your password?".tr,
                              style: TextStyle(
                                color: AppColor.yellow,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        ColorfulButton(
                          height: 48,
                          borderRadius: 40.r,
                          onTap: () => controller.login(),
                          child: Text(
                            "Continue".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "DIN",
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        GestureDetector(
                          onTap: () => Get.to(() => RegisterPage(),
                              arguments: {}..['type'] = 1),
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sign Up".tr,
                                  style: TextStyle(
                                    color: const Color(0xffFFD20E),
                                    fontSize: 16.sp,
                                    fontFamily: FONT_MEDIUM,
                                  ),
                                ),
                                4.horizontalSpace,
                                const Icon(
                                  Icons.trending_neutral_rounded,
                                  color: Color(0xffFFD20E),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: keyboardShow ? 10 : 40,
              child: Visibility(
                visible: !keyboardShow,
                child: Center(
                  child: PrivacyCheck(
                    controller: controller.controller,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class LoginPageController extends BasePageController {
  late PrivacyCheckController controller;

  var email = "".obs;
  var password = "".obs;

  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void onInit() {
    super.onInit();
    controller = PrivacyCheckController();

    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
    String account = StorageManager.getAccount();
    emailEditingController.text = account;
  }

  @override
  void onClose() {
    controller.dispose();
    // emailEditingController.dispose();
    // passwordEditingController.dispose();
    // emailFocusNode.dispose();
    // passwordFocusNode.dispose();
    super.onClose();
  }

  void login() async {
    String email = emailEditingController.text;
    String password = passwordEditingController.text;

    if (email.isEmpty) {
      showToast("Please input your email".tr);
      return;
    }

    if (password.isEmpty) {
      showToast("Please input your password".tr);
      return;
    }

    if (controller.check()) {
      UserController userController = Get.find<UserController>();
      userController.login(
          email: email,
          password: password,
          showLoadings: true,
          done: (LoginModel loginModel) {
            loginSuccess(loginModel);
          });
    }
  }

  void loginSuccess(LoginModel loginModel) {
    dismissLoading();
    if (loginModel.validate == 0) {
      //如果是从登录页面跳转的，跳转到选择游戏页面先
      var fromRegister = Get.arguments?['fromRegister'];
      if (fromRegister == true) {
        Get.offAll(() => ChooseGamesPage());
        return;
      }
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
