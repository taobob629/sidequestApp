import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../common/colorful_button.dart';
import '../../../../common/dialog_date_time_picker.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../auth_input_view.dart';
import '../birthday_selector.dart';
import 'other_register_ctr.dart';

class OtherRegisterPage extends GetView<OtherRegisterCtr> {
  @override
  OtherRegisterCtr get controller => Get.put(OtherRegisterCtr());

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, keyboardVisible) {
      return Scaffold(
        body: KeyboardDismissOnTap(
          child: Container(
            height: Get.height,
            padding: REdgeInsets.all(16).w,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  40.verticalSpace,
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20).w),
                      child: Image.asset(ImageUtils.default_logo, height: 40.w),
                    ),
                  ),
                  26.verticalSpace,
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: '${"Sign Up".tr}\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontFamily: FONT_MEDIUM,
                        )),
                    TextSpan(
                        text:
                            'We would like to know who this account would be for.',
                        style: TextStyle(
                          color: AppColor.whiteGray,
                          fontFamily: FONT_LIGHT,
                        ))
                  ])),
                  16.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: createStep2(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> createStep2() {
    List<Widget> list = [];
    list.add(AuthInputView(
      tips: "Please input your nickName".tr,
      editingController: controller.nickNameEditingController,
      keyboardType: TextInputType.text,
    ));
    list.add(10.verticalSpace);
    list.add(Visibility(
      visible: controller.otherEmail == null,
      child: AuthInputView(
        tips: "Please input your email".tr,
        editingController: controller.emailEditingController,
        keyboardType: TextInputType.text,
      ),
    ));
    list.add(10.verticalSpace);
    list.add(AuthInputView(
      tips: "store pc login password".tr,
      editingController: controller.loginPsdController,
      keyboardType: TextInputType.visiblePassword,
    ));
    list.add(10.verticalSpace);
    list.add(AuthInputView(
      tips: "payment pin".tr,
      editingController: controller.paymentPinController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
      ],
    ));
    list.add(10.verticalSpace);
    // list.add(AuthInputView(
    //   tips: "Nick Name".tr,
    //   editingController: controller.nickEditingController,
    //   keyboardType: TextInputType.name,
    // ));
    // list.add(10.verticalSpace);
    // list.add(Container(
    //   height: 50,
    //   decoration: BoxDecoration(
    //     color: AppColor.itemBg2,
    //     borderRadius: BorderRadius.circular(16).r,
    //   ),
    //   // color: Colors.yellow,
    //   child: InternationalPhoneNumberInput(
    //     onInputChanged: (PhoneNumber number) {
    //       var phoneParts = number.phoneNumber!.split(number.dialCode!);
    //       controller.phone = "${number.dialCode!} ${phoneParts.last}";
    //     },
    //     onInputValidated: (bool value) {
    //       // print(value);
    //     },
    //     selectorConfig: SelectorConfig(
    //       selectorType: PhoneInputSelectorType.DROPDOWN,
    //     ),
    //     ignoreBlank: false,
    //     autoValidateMode: AutovalidateMode.disabled,
    //     selectorTextStyle: TextStyle(color: AppColor.colorB9C9),
    //     textStyle: TextStyle(color: AppColor.colorB9C9),
    //     inputDecoration: InputDecoration(
    //       hintText: "Phone number",
    //       hintStyle: TextStyle(color: AppColor.colorB9C9),
    //       labelStyle: TextStyle(color: AppColor.colorB9C9),
    //       helperStyle: TextStyle(color: AppColor.colorB9C9),
    //     ),
    //     initialValue: PhoneNumber(isoCode: "GB"),
    //     textFieldController: controller.phoneEditingController,
    //     formatInput: false,
    //     cursorColor: Colors.white,
    //     hintText: "Phone number",
    //     keyboardType:
    //         TextInputType.numberWithOptions(signed: true, decimal: true),
    //     inputBorder: OutlineInputBorder(),
    //     onSaved: (PhoneNumber number) {
    //       print('On Saved: $number');
    //       // t.phone.value = number.toString();
    //       // print(t.phone.value);
    //     },
    //   ),
    // ));
    // list.add(10.verticalSpace);
    // list.add(AuthInputView(
    //   tips: "Login Password".tr,
    //   editingController: controller.passwordEditingController,
    //   keyboardType: TextInputType.visiblePassword,
    // ));
    // list.add(10.verticalSpace);
    list.add(Obx(() => BirthdaySelector(
          value: controller.birthday.value,
          onTap: () => Get.dialog<DateTime?>(
                  DateTimePickerDialog(
                    maxDateTime: DateTime.now(),
                    initDateTime: controller.birthday.value,
                  ),
                  barrierColor: Colors.black26)
              .then((value) {
            controller.setBirthday(value);
          }),
        )));
    list.add(10.verticalSpace);
    list.add(GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => controller.selectGender(),
      child: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(16)).w,
        ),
        child: Row(
          children: [
            Expanded(
              child: Obx(() => Text(
                    controller.selectSex.value.name == ''
                        ? 'Gender'
                        : '${controller.selectSex.value.label}',
                    style: TextStyle(
                      color: controller.selectSex.value.name == ''
                          ? AppColor.whiteGray
                          : Colors.white,
                      fontSize: 14,
                    ),
                  )),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            )
          ],
        ),
      ),
    ));
    list.add(10.verticalSpace);
    // list.add(AuthInputView(
    //   editingController: controller.pinEditingController,
    //   keyboardType: TextInputType.number,
    //   inputFormatters: [
    //     LengthLimitingTextInputFormatter(6),
    //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
    //   ],
    //   tips: "Payment Pin".tr,
    // ));
    // list.add(10.verticalSpace);
    // list.add(AuthInputView(
    //   isRequired: false,
    //   tips: "Invite Code (Optional)".tr,
    //   editingController: controller.inviteEditingController,
    //   keyboardType: TextInputType.text,
    // ));
    // list.add(10.verticalSpace);
    list.add(ColorfulButton(
      height: 48,
      onTap: () => controller.signUp(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          "SIGN UP".tr,
          style: TextStyle(
            color: Colors.white,
            fontFamily: FONT_MEDIUM,
            fontSize: 18.sp,
          ),
        ),
      ),
    ));
    list.add(Row(
      children: [
        Checkbox(
          shape: CircleBorder(),
          activeColor: AppColor.accent,
          value: true,
          onChanged: (v) => null,
        ),
        Text(
          "I confirm that I am 18 years old or older".tr,
          style: TextStyle(
            color: Colors.white,
            fontFamily: FONT_MEDIUM,
            fontSize: 14.sp,
          ),
        )
      ],
    ));
    return list;
  }
}
