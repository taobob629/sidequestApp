import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:wy/config/icon_font.dart';

import '../../api/pay_api.dart';
import '../../utils/toast_utils.dart';
import '../login/forget_page.dart';

class DialogPayPsd extends StatelessWidget {

  double diamonds;

  DialogPayPsd({required this.diamonds});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40.w,
      height: 40.w,
      textStyle: TextStyle(
        fontSize: 30.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(4.r),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Container(
      width: Get.width - 60.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(15.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Input your payment pin'.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontFamily: FONT_MEDIUM,
            ),
          ),
          15.verticalSpace,
          Text(
            'Withdraw'.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontFamily: FONT_LIGHT,
            ),
          ),
          15.verticalSpace,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '£ '.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              Text(
                '${(diamonds / 6 * 0.97).toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
            ],
          ),
          Container(
            width: Get.width - 90.w,
            height: 1.h,
            color: Color(0xFFEEEEEE),
            margin: EdgeInsets.symmetric(vertical: 15.h),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service charge'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                '£ ${(diamonds / 6 * 0.03).toStringAsFixed(2)}'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                '3%'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Pinput(
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            obscureText: true,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) => check(pin),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            child: GestureDetector(
              onTap: () => Get.to(() => ForgetPage(
                    type: 2,
                  )),
              child: Container(
                color: Colors.transparent,
                child: Text(
                  "Forgotten?".tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void check(String password) async {
    showLoading();
    bool check = await PayApi.checkPassword(password);
    dismissLoading();
    if (check) {
      SmartDialog.dismiss(tag: 'DialogPayPsd', result: check);
    } else {
      showToast("Wrong payment pin".tr);
    }
  }
}
