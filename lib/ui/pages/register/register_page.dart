import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/dialog_date_time_picker.dart';
import '../../../config/icon_font.dart';
import '../../../image_utils.dart';
import '../../../utils/datetime_utils.dart';
import '../../../widget/phone_input/src/utils/phone_number.dart';
import '../../../widget/phone_input/src/utils/selector_config.dart';
import '../../../widget/phone_input/src/widgets/input_widget.dart';
import '../../../widget/six_digit_pin_input.dart';
import 'controller.dart';

const _background = Color(0xFF0A0A0A);
const _field = Color(0xFF252529);
const _muted = Color(0xFFA7A5AA);
const _soft = Color(0xFF77767C);
const _yellow = Color(0xFFFFB20E);

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterPageController controller = Get.put(RegisterPageController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentStep = controller.step.value;
      return PopScope(
        canPop: currentStep == 1,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && currentStep == 2) controller.step.value = 1;
        },
        child: Scaffold(
          backgroundColor: _background,
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -1.2),
                radius: 0.82,
                colors: [Color(0x20FFB20E), _background],
                stops: [0, 0.72],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _topBar(currentStep),
                    const SizedBox(height: 7),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset(
                          ImageUtils.default_logo,
                          width: 36,
                          height: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentStep == 1
                          ? 'Create your account'.tr
                          : 'Complete your profile'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _yellow,
                        fontSize: 25,
                        height: 1.1,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentStep == 1
                          ? 'Verify your email and tell us your date of birth.'
                                .tr
                          : 'Add the final details needed to secure your account.'
                                .tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _progress(currentStep),
                    const SizedBox(height: 4),
                    if (currentStep == 1) _stepOne() else _stepTwo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _topBar(int currentStep) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (currentStep == 2) {
                controller.step.value = 1;
              } else {
                Get.back();
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFFD8D7DA),
            ),
          ),
          Text(
            '${'Step'.tr} $currentStep ${'of'.tr} 2'.toUpperCase(),
            style: const TextStyle(
              color: _soft,
              fontSize: 12,
              fontFamily: FONT_MEDIUM,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _progress(int currentStep) {
    return Row(
      children: List.generate(
        2,
        (index) => Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(right: index == 0 ? 6 : 0),
            decoration: BoxDecoration(
              color: index < currentStep ? _yellow : const Color(0xFF353539),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _section(
          title: 'Account Email'.tr,
          meta: 'Required'.tr,
          child: _RegisterTextField(
            controller: controller.emailEditingController,
            focusNode: controller.emailFocusNode,
            hint: 'Enter your email address'.tr,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
        ),
        _section(
          title: 'Verification code'.tr,
          meta: 'Check your email'.tr,
          child: _RegisterTextField(
            controller: controller.codeEditingController,
            focusNode: controller.codeFocusNode,
            hint: 'Enter verification code'.tr,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            suffix: _sendCodeButton(),
          ),
        ),
        _section(
          title: 'Date of birth'.tr,
          meta: 'Required'.tr,
          child: Obx(
            () => _SelectionField(
              value: _birthdayText(),
              placeholder: 'Select your date of birth'.tr,
              onTap: () => Get.dialog<DateTime?>(
                DateTimePickerDialog(
                  maxDateTime: DateTime.now(),
                  initDateTime: controller.birthday.value,
                ),
                barrierColor: Colors.black54,
              ).then(controller.setBirthday),
            ),
          ),
        ),
        Obx(() {
          final age = DatetimeUtils.getAge(controller.birthday.value);
          if (age == 0 || age >= 16) return const SizedBox.shrink();
          return _section(
            title: 'Guardian Email'.tr,
            meta: 'Required under 16'.tr,
            child: Column(
              children: [
                _RegisterTextField(
                  controller: controller.guardianEditingController,
                  hint: 'Enter guardian email'.tr,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 6),
                Text(
                  'Players under the age of 16 must provide an emergency contact in order to use our services and sign up.'
                      .tr,
                  style: const TextStyle(
                    color: _soft,
                    fontSize: 10,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 18),
        _actionButton('Continue'.tr, controller.gotoStep2),
      ],
    );
  }

  Widget _stepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _section(
          title: 'Nick Name'.tr,
          meta: 'Required'.tr,
          child: _RegisterTextField(
            controller: controller.nickEditingController,
            hint: 'Enter your Nick Name'.tr,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
        ),
        _section(
          title: 'Gender'.tr,
          meta: 'Required'.tr,
          child: _genderOptions(),
        ),
        _section(
          title: 'Phone number'.tr,
          meta: 'Required'.tr,
          child: _phoneField(),
        ),
        _section(
          title: 'Login password'.tr,
          meta: '6+ characters'.tr,
          child: _RegisterTextField(
            controller: controller.passwordEditingController,
            hint: 'Create a secure password'.tr,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
          ),
        ),
        _section(
          title: 'Payment PIN'.tr,
          meta: '6 digits'.tr,
          child: Column(
            children: [
              SixDigitPinInput(controller: controller.pinEditingController),
              const SizedBox(height: 7),
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
        const SizedBox(height: 18),
        _actionButton(
          controller.type == 1 ? 'Create account'.tr : 'Update profile'.tr,
          controller.signUp,
        ),
      ],
    );
  }

  Widget _section({
    required String title,
    required String meta,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ),
                Text(meta, style: const TextStyle(color: _muted, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _sendCodeButton() {
    return Obx(() {
      final waiting = controller.codeCountDown.value < 60;
      final sent = controller.uid.value.isNotEmpty;
      final label = waiting
          ? '${controller.codeCountDown.value}s'
          : sent
          ? 'Resend'.tr
          : 'Send'.tr;
      return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: SizedBox(
          height: 36,
          child: TextButton(
            onPressed: waiting ? null : controller.sendEmail,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              disabledForegroundColor: const Color(0xFFF2F1F3),
              foregroundColor: _yellow,
              backgroundColor: waiting
                  ? const Color(0xFF45454B)
                  : const Color(0x16FFB20E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontFamily: FONT_MEDIUM),
            ),
          ),
        ),
      );
    });
  }

  Widget _genderOptions() {
    const values = [(0, 'Male'), (1, 'Female'), (2, 'Non-binary')];
    return Obx(
      () => Row(
        children: values.map((item) {
          final selected = controller.sex.value == item.$1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: item.$1 == 2 ? 0 : 7),
              child: Material(
                color: selected ? const Color(0x1FFFb20E) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => controller.changeSex(item.$1),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected ? _yellow : const Color(0x38FFFFFF),
                        width: selected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      item.$2.tr,
                      style: TextStyle(
                        color: selected ? _yellow : const Color(0xFFD6D4D8),
                        fontSize: 12,
                        fontFamily: selected ? FONT_MEDIUM : null,
                      ),
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

  Widget _phoneField() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: _field,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          final value = number.phoneNumber ?? '';
          final dialCode = number.dialCode ?? '';
          final nationalNumber = value.startsWith(dialCode)
              ? value.substring(dialCode.length)
              : value;
          controller.phone = '$dialCode ${nationalNumber.trim()}'.trim();
        },
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DROPDOWN,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1,
        ),
        inputDecoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: 'Enter phone number'.tr,
          hintStyle: const TextStyle(color: _muted, fontSize: 14, height: 1),
        ),
        initialValue: PhoneNumber(isoCode: 'GB'),
        textFieldController: controller.phoneEditingController,
        formatInput: false,
        cursorColor: _yellow,
        keyboardType: TextInputType.phone,
        inputBorder: InputBorder.none,
        onSaved: (_) {},
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onTap) {
    return Container(
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
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _birthdayText() {
    final date = controller.birthday.value;
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return '';
    }
    return formatDate(date, [dd, '/', mm, '/', yyyy]);
  }
}

class _RegisterTextField extends StatefulWidget {
  const _RegisterTextField({
    required this.controller,
    required this.hint,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffix;

  @override
  State<_RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<_RegisterTextField> {
  late bool obscureText = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _field,
        borderRadius: BorderRadius.circular(16),
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
                obscureText: obscureText,
                textAlignVertical: TextAlignVertical.center,
                maxLines: 1,
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
                    color: _muted,
                    fontSize: 14,
                    height: 1,
                  ),
                  contentPadding: const EdgeInsets.only(left: 15, right: 8),
                ),
              ),
            ),
          ),
          if (widget.obscureText)
            IconButton(
              onPressed: () => setState(() => obscureText = !obscureText),
              constraints: const BoxConstraints.tightFor(width: 46, height: 46),
              padding: EdgeInsets.zero,
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _muted,
                size: 20,
              ),
            )
          else if (widget.suffix != null)
            widget.suffix!,
        ],
      ),
    );
  }
}

class _SelectionField extends StatelessWidget {
  const _SelectionField({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _field,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 46,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? placeholder : value,
                    style: TextStyle(
                      color: value.isEmpty ? _muted : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: _muted,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
