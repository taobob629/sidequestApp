import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/keyboard_visibility_scaffold.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/login/forget_page.dart';
import 'package:wy/ui/login/secondary_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';

import '../../config/controller/controller.dart';
import '../../model/login_model.dart';
import '../../utils/toast_utils.dart';
import 'auth_input_view.dart';

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
                  100.verticalSpace,
                  Offstage(
                    offstage: keyboardShow,
                    child: Container(
                      height: 56,
                      margin: EdgeInsets.only(bottom: 50.h),
                      child: Image.asset(
                        "assets/images/logo.webp",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Offstage(
                            offstage: keyboardShow,
                            child: Text(
                              "SIGN IN".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "DIN",
                                  fontSize: 28),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        AuthInputView(
                          tips: "SideQuest ID / Email".tr,
                          editingController: controller.emailEditingController,
                          textInputAction: TextInputAction.next,
                          focusNode: controller.emailFocusNode,
                        ),
                        SizedBox(
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
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgotten your password?".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        ColorfulButton(
                          child: Text(
                            "SIGN IN".tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "DIN",
                                fontSize: 18),
                          ),
                          height: 48,
                          borderRadius: 40.r,
                          onTap: () => controller.login(),
                        ),
                        30.verticalSpace,
                        GestureDetector(
                          onTap: () => Get.toNamed(AppPages.REGISTER,
                              arguments: Map()..['type'] = 1),
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sign Up".tr,
                                  style: TextStyle(
                                    color: Color(0xffFFD20E),
                                    fontSize: 16.sp,
                                    fontFamily: FONT_MEDIUM,
                                  ),
                                ),
                                4.horizontalSpace,
                                Icon(
                                  Icons.trending_neutral_rounded,
                                  color: Color(0xffFFD20E),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: Platform.isIOS,
                          child: 100.verticalSpace,
                        ),
                        Visibility(
                          visible: Platform.isAndroid,
                          child: 20.verticalSpace,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: Platform.isIOS,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => controller.loginWithApple(),
                                child: Container(
                                  width: 46.w,
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(46.r),
                                    border: Border.all(
                                      color: Color(0xff707070),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Image.asset(
                                    ImageUtils.apple_icon,
                                    scale: 4,
                                  ),
                                ),
                              ),
                            ),
                            GetBuilder<AppController>(
                                id: AppController.find.showGoogleSignInId,
                                builder: (builder) => Visibility(
                                      visible: Platform.isAndroid &&
                                          AppController.find.showGoogleSingIn,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () =>
                                            controller.loginWithGoogle(),
                                        child: Container(
                                          width: 46.w,
                                          height: 46.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(46.r),
                                            border: Border.all(
                                              color: Color(0xff707070),
                                              width: 1.w,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(8.r),
                                          child: Image.asset(
                                            ImageUtils.google_icon,
                                            scale: 4,
                                          ),
                                        ),
                                      ),
                                    )),
                            15.horizontalSpace,
                            Visibility(
                              visible: false,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => controller.loginWithDiscord(),
                                child: Container(
                                  width: 46.w,
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(46.r),
                                    border: Border.all(
                                      color: Color(0xff707070),
                                      width: 1.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(8.r),
                                  child: Image.asset(
                                    ImageUtils.discord_icon,
                                    scale: 4,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
              child: Center(
                  child: PrivacyCheck(
                controller: controller.controller,
              )),
            )
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

  void loginWithGoogle() {
    if (controller.check()) {
      UserController.find.googleLogin(done: (LoginModel loginModel) {
        loginSuccess(loginModel);
      });
    }
  }

  void loginWithDiscord() {
    if (controller.check()) {
      UserController.find.discordLogin(done: (LoginModel loginModel) {
        loginSuccess(loginModel);
      });
    }
  }

  void loginWithApple() {
    if (controller.check()) {
      UserController.find.appleLogin(
          needAppleLogin: true,
          done: (LoginModel loginModel) {
            loginSuccess(loginModel);
          });
    }
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
    if (loginModel.validate == 0) {
      UserController.find.imLogin();
      //如果是从登录页面跳转的，跳转到选择游戏页面先
      var fromRegister = Get.arguments?['fromRegister'];
      flog('fromRegister $fromRegister');
      if (fromRegister == true) {
        Get.offAndToNamed(AppPages.CHOOSE_GAME);
        return;
      }
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
