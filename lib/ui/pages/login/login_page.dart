import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../api/wy_http.dart';
import '../../../common/base_controller.dart';
import '../../../common/keyboard_visibility_scaffold.dart';
import '../../../common/privacy_check.dart';
import '../../../config/icon_font.dart';
import '../../../controller/user_controller.dart';
import '../../../image_utils.dart';
import '../../../model/login_model.dart';
import '../../../utils/storage_manager.dart';
import '../../../utils/toast_utils.dart';
import '../main_page.dart';
import '../register/register_page.dart';
import 'forget_page.dart';
import 'secondary_page.dart';

const _background = Color(0xFF0A0A0A);
const _field = Color(0xFF252529);
const _muted = Color(0xFFA7A5AA);
const _soft = Color(0xFF77767C);
const _yellow = Color(0xFFFFB20E);
const _line = Color(0x24FFFFFF);

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginPageController controller = Get.put(LoginPageController());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityScaffold(
      builder: (context, keyboardShow) {
        return Scaffold(
          backgroundColor: _background,
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -1.05),
                radius: 0.78,
                colors: [Color(0x24FFB20E), _background],
                stops: [0, 0.72],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(22, 6, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _topBar(),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      alignment: Alignment.topCenter,
                      child: keyboardShow
                          ? const SizedBox(height: 6)
                          : Column(
                              children: [
                                const SizedBox(height: 14),
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(
                                      ImageUtils.default_logo,
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 17),
                              ],
                            ),
                    ),
                    Text(
                      'Welcome back'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _yellow,
                        fontSize: 29,
                        height: 1.08,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Sign in with your SideQuest ID or email.'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: keyboardShow ? 18 : 26),
                    _fieldLabel('SideQuest ID / Email'.tr),
                    const SizedBox(height: 7),
                    _LoginTextField(
                      controller: controller.emailEditingController,
                      focusNode: controller.emailFocusNode,
                      hint: 'Enter your ID or email'.tr,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _fieldLabel('Password'.tr)),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Get.to(() => ForgetPage(type: 1)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              'Forgot password?'.tr,
                              style: const TextStyle(
                                color: _yellow,
                                fontSize: 11,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    _LoginTextField(
                      controller: controller.passwordEditingController,
                      focusNode: controller.passwordFocusNode,
                      hint: 'Enter your password'.tr,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.go,
                      obscureText: true,
                      onSubmitted: (_) => controller.login(),
                    ),
                    const SizedBox(height: 18),
                    _primaryButton(),
                    const SizedBox(height: 13),
                    _signUpLink(),
                    if (!keyboardShow) ...[
                      const SizedBox(height: 18),
                      _socialLoginArea(),
                      const SizedBox(height: 18),
                      PrivacyCheck(
                        controller: controller.controller,
                        compact: true,
                        wrapAlignment: WrapAlignment.start,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topBar() {
    return SizedBox(
      height: 34,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'SIGN IN'.tr,
              style: const TextStyle(
                color: _soft,
                fontSize: 11,
                letterSpacing: 1.1,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Get.offAll(() => MainPage()),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 34, height: 34),
              icon: const Icon(
                Icons.close_rounded,
                size: 22,
                color: Color(0xFFD7D5D9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFECEBEE),
          fontSize: 12,
          fontFamily: FONT_MEDIUM,
        ),
      ),
    );
  }

  Widget _primaryButton() {
    return Container(
      height: 49,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFFED5A24), Color(0xFFD49C21)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 10),
            blurRadius: 22,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: controller.login,
          child: Center(
            child: Text(
              'Continue'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to SideQuest?'.tr,
          style: const TextStyle(color: _muted, fontSize: 14),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.to(
            () => RegisterPage(),
            arguments: <String, dynamic>{'type': 1},
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Create account'.tr,
              style: const TextStyle(
                color: _yellow,
                fontSize: 14,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialLoginArea() {
    return Obx(() {
      final settings = controller.loginBtnModel.value;
      final showGoogle = Platform.isAndroid && settings.googleLogin;
      final showApple = Platform.isIOS && settings.appleLogin;
      if (!showGoogle && !showApple) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: Divider(color: _line, height: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'or continue with'.tr,
                  style: const TextStyle(color: _soft, fontSize: 10),
                ),
              ),
              const Expanded(child: Divider(color: _line, height: 1)),
            ],
          ),
          const SizedBox(height: 14),
          if (showGoogle)
            _SocialLoginButton(
              label: 'Continue with Google'.tr,
              icon: ImageUtils.google_icon,
              light: true,
              onTap: controller.loginWithGoogle,
            ),
          if (showApple)
            _SocialLoginButton(
              label: 'Continue with Apple'.tr,
              icon: ImageUtils.apple_icon,
              onTap: controller.loginWithApple,
            ),
        ],
      );
    });
  }
}

class _LoginTextField extends StatefulWidget {
  const _LoginTextField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;

  @override
  State<_LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<_LoginTextField> {
  late bool obscure = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      decoration: BoxDecoration(
        color: _field,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0FFFFFFF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                obscureText: obscure,
                onSubmitted: widget.onSubmitted,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: _yellow,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1,
                ),
                strutStyle: const StrutStyle(
                  fontSize: 15,
                  height: 1,
                  forceStrutHeight: true,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFF8D8C92),
                    fontSize: 14,
                    height: 1,
                  ),
                  contentPadding: const EdgeInsets.only(left: 15, right: 10),
                ),
              ),
            ),
          ),
          if (widget.obscureText)
            IconButton(
              onPressed: () => setState(() => obscure = !obscure),
              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
              padding: EdgeInsets.zero,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _muted,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.light = false,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final foreground = light ? const Color(0xFF202124) : Colors.white;
    return Material(
      color: light ? const Color(0xFFF7F7F8) : const Color(0xFF18181B),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: light ? const Color(0xFFE2E2E5) : _line),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(width: 24, height: 24, child: Image.asset(icon)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 14,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPageController extends BasePageController {
  late PrivacyCheckController controller;

  var email = ''.obs;
  var password = ''.obs;

  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  var loginBtnModel = LoginBtnModel().obs;

  @override
  void onInit() {
    super.onInit();
    controller = PrivacyCheckController();

    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    requestData();
  }

  @override
  void onReady() {
    super.onReady();
    final account = StorageManager.getAccount();
    emailEditingController.text = account;
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void requestData() async {
    final response = await http.get('/sideQuest/app/sq/user/loginPage');
    loginBtnModel.value = LoginBtnModel.fromJson(response.data);
  }

  void loginWithApple() {
    if (controller.check()) {
      UserController.find.appleLogin(needLogin: true, done: loginSuccess);
    }
  }

  void loginWithGoogle() {
    if (controller.check()) {
      UserController.find.googleLogin(done: loginSuccess);
    }
  }

  void login() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    final email = emailEditingController.text;
    final password = passwordEditingController.text;

    if (email.isEmpty) {
      showToast('Please input your email'.tr);
      return;
    }

    if (password.isEmpty) {
      showToast('Please input your password'.tr);
      return;
    }

    if (controller.check()) {
      final userController = Get.find<UserController>();
      userController.login(
        email: email,
        password: password,
        showLoadings: true,
        done: loginSuccess,
      );
    }
  }

  void loginSuccess(LoginModel loginModel) {
    dismissLoading();
    if (loginModel.validate == 0) {
      Get.offAll(() => MainPage());
    } else if (loginModel.secondary == 1) {
      Get.off(() => SecondaryPage(loginModel: loginModel));
    } else {
      Get.to(
        () => RegisterPage(),
        arguments: <String, dynamic>{'type': 1, 'loginModel': loginModel},
      );
    }
  }
}
