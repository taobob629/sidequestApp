import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/common/colorful_button.dart';
import 'package:wy/ui/common/dialog_date_time_picker.dart';
import 'package:wy/ui/login/auth_input_view.dart';
import 'package:wy/ui/login/birthday_selector.dart';
import 'package:wy/utils/datetime_utils.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/widget/gradient_button.dart';

import '../../../widget/phone_input/src/utils/phone_number.dart';
import '../../../widget/phone_input/src/utils/selector_config.dart';
import '../../../widget/phone_input/src/widgets/input_widget.dart';
import 'controller.dart';

class RegisterPage extends GetView<RegisterPageController> {
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, keyboardVisible) {
      return Scaffold(
        body: KeyboardDismissOnTap(
          child: Container(
            height: Get.height,
            padding: REdgeInsets.all(16).w,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      40.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.close,
                                size: 17.w,
                                color: AppColor.whiteGray,
                              ))
                        ],
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20).w),
                          child: ImageUtil.assetImage('default_logo', height: 40.w),
                        ),
                      ),
                      26.verticalSpace,
                      Text.rich(TextSpan(children: [
                        TextSpan(text: '${controller.type == 1 ? "Sign Up".tr : "Update Profile".tr}\n', style: TextStyle(color: Colors.white, fontSize: 22.sp, fontFamily: FONT_MEDIUM)),
                        TextSpan(text: 'We would like to know who this account would be for.', style: TextStyle(color: AppColor.whiteGray, fontFamily: FONT_LIGHT))
                      ])),
                      // Text(
                      //   "Profile Information",
                      //   style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 28),
                      // ),
                      16.verticalSpace,
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.step.value == 1 ? createStep1() : createStep2(),
                        );
                      }),
                    ],
                  ),
                ),
                buildBottom()
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildBottom() {
    return Visibility(
        visible: false,
        child: Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                    child: GradientButton(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)).w, border: Border.all(color: Colors.grey, width: 1)),
                        tapCallback: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apps,
                              color: AppColor.whiteGray,
                            ),
                            Text('Iphone', style: TextStyle(color: Colors.white, fontSize: 16.sp))
                          ],
                        ))),
                16.horizontalSpace,
                Expanded(
                    child: GradientButton(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)).w, border: Border.all(color: Colors.grey, width: 1)),
                        tapCallback: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apps,
                              color: AppColor.whiteGray,
                            ),
                            Text('Google', style: TextStyle(color: Colors.white, fontSize: 16.sp))
                          ],
                        ))),
              ],
            )));
  }

  List<Widget> createStep1() {
    List<Widget> list = [];
    list.add(AuthInputView(
      tips: "Account Email",
      editingController: controller.emailEditingController,
      focusNode: controller.emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.go,
      onSubmitted: (value) => controller.gotoStep2(),
    ));
    list.add(SizedBox(
      height: 20,
    ));
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
    list.add(Obx(() => Offstage(
          offstage: DatetimeUtils.getAge(controller.birthday.value) >= 16 || DatetimeUtils.getAge(controller.birthday.value) == 0,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              AuthInputView(
                tips: "Guardian Email".tr,
                editingController: controller.guardianEditingController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) => controller.gotoStep2(),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Players under the age of 16 must provide an emergency contact in order to use our services and sign up.".tr,
                  style: TextStyle(fontSize: 12, color: AppColor.whiteGray),
                ),
              ),
            ],
          ),
        )));
    list.add(SizedBox(
      height: 100,
    ));
    list.add(
      ColorfulButton(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "SEND VERIFICATION CODE".tr,
            style: TextStyle(color: Colors.white, fontFamily: "DIN", fontSize: 18),
          ),
        ),
        height: 50,
        onTap: () => controller.gotoStep2(),
      ),
    );
    return list;
  }

  List<Widget> createStep2() {
    List<Widget> list = [];
    list.add(AuthInputView(
      tips: "Verification code from your email".tr,
      editingController: controller.codeEditingController,
      focusNode: controller.codeFocusNode,
      keyboardType: TextInputType.number,
    ));
    list.add(SizedBox(
      height: 20,
    ));
    // list.add(Row(
    //   children: [
    //     Expanded(
    //       flex: 1,
    //       child: AuthInputView(
    //         tips: "First Name".tr,
    //         editingController: controller.firstEditingController,
    //         keyboardType: TextInputType.name,
    //       ),
    //     ),
    //     SizedBox(
    //       width: 10,
    //     ),
    //     Expanded(
    //       flex: 1,
    //       child: AuthInputView(
    //         tips: "Last Name".tr,
    //         editingController: controller.lastEditingController,
    //         keyboardType: TextInputType.name,
    //       ),
    //     )
    //   ],
    // ));
    // list.add(SizedBox(
    //   height: 20,
    // ));
    list.add(AuthInputView(
      tips: "Nick Name".tr,
      editingController: controller.nickEditingController,
      keyboardType: TextInputType.name,
    ));
    // list.add(SizedBox(
    //   height: 10,
    // ));
    // list.add(Row(
    //   children: [
    //     Radio<int>(value: 0, groupValue: controller.sex.value, onChanged: (value) => controller.changeSex(value)),
    //     Text(
    //       "Male".tr,
    //       style: TextStyle(color: Colors.white, fontSize: 14.sp),
    //     ),
    //     Radio<int>(value: 1, groupValue: controller.sex.value, onChanged: (value) => controller.changeSex(value)),
    //     Text(
    //       "Female".tr,
    //       style: TextStyle(color: Colors.white, fontSize: 14.sp),
    //     ),
    //     Radio<int>(value: 2, groupValue: controller.sex.value, onChanged: (value) => controller.changeSex(value)),
    //     Text(
    //       "Non-binary".tr,
    //       style: TextStyle(color: Colors.white, fontSize: 14.sp),
    //     ),
    //     // Radio<int>(value: 2, groupValue: controller.sex.value, onChanged: (value)=>controller.changeSex(value)),
    //     // Text("Others",style: TextStyle(color: Colors.white,fontSize: 14),),
    //   ],
    // ));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(Container(
      height: 50,
      decoration: BoxDecoration(color: AppColor.itemBg2, borderRadius: BorderRadius.circular(16).r),
      // color: Colors.yellow,
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          var phoneParts = number.phoneNumber!.split(number.dialCode!);
          controller.phone = "${number.dialCode!} ${phoneParts.last}";
        },
        onInputValidated: (bool value) {
          // print(value);
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.DROPDOWN,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(color: AppColor.colorB9C9),
        textStyle: TextStyle(color: AppColor.colorB9C9),
        inputDecoration: InputDecoration(
          hintText: "Phone number",
          hintStyle: TextStyle(color: AppColor.colorB9C9),
          labelStyle: TextStyle(color: AppColor.colorB9C9),
          helperStyle: TextStyle(color: AppColor.colorB9C9),
        ),
        initialValue: PhoneNumber(isoCode: "GB"),
        textFieldController: controller.phoneEditingController,
        formatInput: false,
        cursorColor: Colors.white,
        hintText: "Phone number",
        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: OutlineInputBorder(),
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
          // t.phone.value = number.toString();
          // print(t.phone.value);
        },
      ),
    ));
    // list.add(AuthInputView(
    //   tips: "Phone Number".tr,
    //   editingController: controller.phoneEditingController,
    //   keyboardType: TextInputType.phone,
    // ));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(AuthInputView(tips: "Login Password".tr, editingController: controller.passwordEditingController, keyboardType: TextInputType.visiblePassword));
    list.add(SizedBox(
      height: 20,
    ));
    list.add(
      AuthInputView(
          editingController: controller.pinEditingController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) //设置只允许输入数字
          ],
          tips: "Payment Pin".tr),
    );
    if (controller.type == 1) {
      list.add(SizedBox(
        height: 20,
      ));
      list.add(AuthInputView(isRequired: false, tips: "Invite Code (Optional)".tr, editingController: controller.inviteEditingController, keyboardType: TextInputType.text));
    }
    list.add(SizedBox(
      height: 40,
    ));
    list.add(
      ColorfulButton(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            controller.type == 1 ? "SIGN UP".tr : "UPDATE".tr,
            style: TextStyle(color: Colors.white, fontFamily: FONT_MEDIUM, fontSize: 18),
          ),
        ),
        height: 48,
        onTap: () => controller.signUp(),
      ),
    );
    return list;
  }
}
