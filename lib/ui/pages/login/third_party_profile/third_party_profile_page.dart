import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_date_time_picker.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../widget/six_digit_pin_input.dart';
import 'third_party_profile_controller.dart';

const _background = Color(0xFF0A0A0A);
const _field = Color(0xFF252529);
const _muted = Color(0xFFA7A5AA);
const _soft = Color(0xFF77767C);
const _yellow = Color(0xFFFFB20E);
const _success = Color(0xFF6ED49A);
const _line = Color(0x1AFFFFFF);

class ThirdPartyProfilePage extends GetView<ThirdPartyProfileController> {
  @override
  ThirdPartyProfileController get controller =>
      Get.put(ThirdPartyProfileController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.backToLogin();
        return false;
      },
      child: Scaffold(
        backgroundColor: _background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -1.25),
              radius: 0.78,
              colors: [Color(0x1FFFb20E), _background],
              stops: [0, 0.72],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _topBar(),
                  const SizedBox(height: 6),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.asset(
                        ImageUtils.default_logo,
                        width: 34,
                        height: 34,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Complete your profile'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _yellow,
                      fontSize: 25,
                      height: 1.1,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'Just a few details to keep your account secure and ready for payments.'
                          .tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _socialAccount(),
                  _section(
                    title: 'Nick Name'.tr,
                    meta: 'Required'.tr,
                    child: _textField(
                      controller: controller.nickNameController,
                      hint: 'Enter your Nick Name'.tr,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  if (controller.requiresEmail)
                    _section(
                      title: 'Email address'.tr,
                      meta: 'Required for iOS'.tr,
                      child: _textField(
                        controller: controller.emailController,
                        hint: 'Enter your email address'.tr,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  _section(
                    title: 'Phone number'.tr,
                    meta: 'Required'.tr,
                    child: _phoneField(),
                  ),
                  _section(
                    title: 'Gender'.tr,
                    meta: 'Required'.tr,
                    child: _genderOptions(),
                  ),
                  _section(
                    title: 'Date of birth'.tr,
                    meta: '13+ only'.tr,
                    child: Obx(() => _birthdayField()),
                  ),
                  _section(
                    title: 'Login password'.tr,
                    meta: '8+ characters'.tr,
                    child: _passwordField(),
                  ),
                  _section(
                    title: 'Payment PIN'.tr,
                    meta: '6 digits'.tr,
                    child: Column(
                      children: [
                        SixDigitPinInput(
                          controller: controller.paymentPinController,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                size: 13,
                                color: _soft,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Keep this different from your login password. You’ll use it to confirm payments.'
                                    .tr,
                                style: const TextStyle(
                                  color: _soft,
                                  fontSize: 10,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFED5A24), Color(0xFFD49C21)],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x42000000),
                          offset: Offset(0, 10),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: controller.submit,
                        child: Center(
                          child: Text(
                            'Complete registration'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: FONT_MEDIUM,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Your social account stays connected. You can manage sign-in methods later in Settings.'
                          .tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _soft,
                        fontSize: 10,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: controller.backToLogin,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFFD8D7DA),
            ),
          ),
          Text(
            'Final step'.tr.toUpperCase(),
            style: const TextStyle(
              color: _soft,
              fontSize: 12,
              fontFamily: FONT_MEDIUM,
              letterSpacing: 0.96,
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _socialAccount() {
    final apple = controller.requiresEmail;
    final accountText = controller.providerEmail.trim().isEmpty
        ? (apple
              ? 'Email address not shared'.tr
              : 'Google account connected'.tr)
        : controller.providerEmail.trim();
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0x09FFFFFF),
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: apple ? const Color(0xFF26262A) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              apple ? ImageUtils.apple_icon : ImageUtils.google_icon,
              width: 21,
              height: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  apple
                      ? 'Signed in with Apple'.tr
                      : 'Signed in with Google'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.2,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  accountText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Verified'.tr,
            style: const TextStyle(
              color: _success,
              fontSize: 11,
              fontFamily: FONT_MEDIUM,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required String meta,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFECEBEE),
                    fontSize: 12,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                Text(meta, style: const TextStyle(color: _soft, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffix,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _field,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          cursorColor: _yellow,
          style: const TextStyle(color: Colors.white, fontSize: 15, height: 1),
          strutStyle: const StrutStyle(
            fontSize: 15,
            height: 1,
            forceStrutHeight: true,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF8D8C92),
              fontSize: 15,
              height: 1,
            ),
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: InputBorder.none,
            suffixIcon: suffix,
          ),
        ),
      ),
    );
  }

  Widget _phoneField() {
    const options = <String, String>{
      '+44': '🇬🇧 +44',
      '+65': '🇸🇬 +65',
      '+86': '🇨🇳 +86',
      '+1': '🇺🇸 +1',
    };
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _field,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Obx(
              () => PopupMenuButton<String>(
                initialValue: controller.dialCode.value,
                color: const Color(0xFF2B2B30),
                onSelected: (value) => controller.dialCode.value = value,
                itemBuilder: (_) => options.entries
                    .map(
                      (entry) => PopupMenuItem<String>(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          options[controller.dialCode.value]!,
                          style: const TextStyle(
                            color: Color(0xFFF4F3F5),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: _muted,
                      ),
                      const SizedBox(width: 7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, height: 26, color: _line),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: _yellow,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Enter phone number'.tr,
                hintStyle: const TextStyle(
                  color: Color(0xFF8D8C92),
                  fontSize: 15,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderOptions() {
    const options = <String, String>{
      '0': 'Male',
      '1': 'Female',
      '2': 'Non-binary',
    };
    return Obx(
      () => Row(
        children: options.entries.map((entry) {
          final selected = controller.gender.value == entry.key;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: entry.key == '2' ? 0 : 8),
              child: InkWell(
                onTap: () => controller.selectGender(entry.key),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  height: 42,
                  duration: const Duration(milliseconds: 160),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0x1AFFB20E)
                        : const Color(0x09FFFFFF),
                    border: Border.all(
                      color: selected ? const Color(0xB3FFB20E) : _line,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    entry.value.tr,
                    style: TextStyle(
                      color: selected ? _yellow : _muted,
                      fontSize: 13,
                      fontFamily: selected ? FONT_MEDIUM : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _birthdayField() {
    final latestBirthday = controller.latestAllowedBirthday;
    final birthday = controller.birthdayText;
    return Material(
      color: _field,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Get.dialog<DateTime?>(
          DateTimePickerDialog(
            title: 'Date of birth',
            format: 'dd-MM-yyyy',
            minDateTime: DateTime(1900, 1, 1),
            maxDateTime: latestBirthday,
            initDateTime: controller.birthday.value ?? latestBirthday,
          ),
          barrierColor: Colors.black54,
        ).then(controller.selectBirthday),
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 46,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    birthday.isEmpty
                        ? 'Select your date of birth'.tr
                        : birthday,
                    style: TextStyle(
                      color: birthday.isEmpty
                          ? const Color(0xFF8D8C92)
                          : Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 19,
                  color: _muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller.passwordController,
      builder: (context, value, _) {
        final score = _passwordScore(value.text);
        const colors = [
          Color(0xFFFF6B6B),
          Color(0xFFFF866A),
          _yellow,
          Color(0xFFD6C84D),
          _success,
        ];
        const labels = [
          'Use letters, numbers and a symbol',
          'Weak password',
          'Fair password',
          'Good password',
          'Strong password',
        ];
        return _PasswordInput(
          controller: controller.passwordController,
          score: score,
          strengthColor: colors[score],
          strengthLabel: labels[score].tr,
        );
      },
    );
  }

  int _passwordScore(String value) {
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[a-z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) score++;
    return score;
  }
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput({
    required this.controller,
    required this.score,
    required this.strengthColor,
    required this.strengthLabel,
  });

  final TextEditingController controller;
  final int score;
  final Color strengthColor;
  final String strengthLabel;

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: _field,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: obscure,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
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
              hintText: 'Create a secure password'.tr,
              hintStyle: const TextStyle(
                color: Color(0xFF8D8C92),
                fontSize: 15,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.only(left: 15),
              border: InputBorder.none,
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 46,
                height: 46,
              ),
              suffixIcon: IconButton(
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 19,
                  color: const Color(0xFFA9A8AD),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF343438),
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42 * widget.score / 4,
                  height: 3,
                  color: widget.strengthColor,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                widget.strengthLabel,
                style: const TextStyle(color: _soft, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
