import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/keyboard_visibility_scaffold.dart';
import 'package:wy/ui/common/privacy_check.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/login/forget_page.dart';
import 'package:wy/ui/login/secondary_page.dart';
import 'package:wy/utils/storage_manager.dart';
import 'package:wy/utils/utils.dart';

import '../../model/login_model.dart';
import '../../utils/toast_utils.dart';
import '../common/base_scaffold.dart';
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
                      margin: const EdgeInsets.only(bottom: 80),
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
                        SizedBox(
                          height: 20,
                        ),
                        ColorfulButton(
                          child: Text(
                            "SIGN IN".tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "DIN",
                                fontSize: 18),
                          ),
                          height: 48,
                          onTap: () => controller.login(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  Get.toNamed(AppPages.REGISTER, arguments: Map()..['type'] = 1),
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Sign Up".tr,
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => ForgetPage(
                                    type: 1,
                                  )),
                              child: Container(
                                color: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Forgotten your password?".tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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

  GoogleSignIn _googleSignIn = GoogleSignIn(
      // scopes: [
      //   'email',
      //   'https://www.googleapis.com/auth/contacts.readonly',
      // ],
      );

  void login() async {
    // try {
    //   GoogleSignInAccount? account = await _googleSignIn.signIn();
    //   flog('google sign in $account');
    // }catch(e){
    //   flog('sign in err $e');
    // }
    //
    // return;
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
            if (loginModel.validate == 0) {
              userController.imLogin();
              //如果是从登录页面跳转的，跳转到选择游戏页面先
              var fromRegister=Get.arguments?['fromRegister'];
              flog('fromRegister $fromRegister');
              if(fromRegister==true){
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
                // Get.off(() => RegisterPage(
                //       type: 2,
                //       loginModel: loginModel,
                //     ));
              }
            }
          });
    }
  }
}
