import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';

import '../../api/pay_api.dart';
import '../../utils/toast_utils.dart';
import '../login/forget_page.dart';

class DialogPayPsd extends StatelessWidget {
  String type;
  double diamonds;

  DialogPayPsd({required this.type, required this.diamonds});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40.w,
      height: 40.w,
      textStyle: TextStyle(
        fontSize: 30.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF707070)),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color(0xffA36EFF)),
      borderRadius: BorderRadius.circular(4.r),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color(0xff31B1A1E),
      ),
    );

    return Stack(
      children: [
        Container(
          width: Get.width - 60.w,
          decoration: BoxDecoration(
              color: Color(0xff262731),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(width: 2.w, color: Color(0xffA36EFF))),
          padding: EdgeInsets.fromLTRB(15.r, 40.r, 15.r, 15.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Input your payment pin'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              15.verticalSpace,
              Text(
                type != 'exchange' ? 'Withdraw' : 'Exchange To Coin'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
              15.verticalSpace,
              type != 'exchange'
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '£ '.tr,
                          style: TextStyle(
                            color: Color(0xffFFD20E),
                            fontSize: 18.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                        Text(
                          '${(diamonds / 6 * 0.97).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color(0xffFFD20E),
                            fontSize: 18.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/ic_balance_votes.webp',
                        ),
                        6.horizontalSpace,
                        Text(
                          diamonds.toStringAsFixed(0),
                          style: TextStyle(
                            color: Color(0xffFFD20E),
                            fontSize: 18.sp,
                            fontFamily: FONT_MEDIUM,
                          ),
                        ),
                      ],
                    ),
              Container(
                width: Get.width - 90.w,
                height: 1.h,
                color: Color(0xFF2D2E3A),
                margin: EdgeInsets.symmetric(vertical: 15.h),
              ),
              Visibility(
                visible: type != 'exchange',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Service Charge'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    Text(
                      '£ ${(diamonds / 6 * 0.03).toStringAsFixed(2)}'.tr,
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: 15.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ],
                ),
              ),
              if (type != 'exchange') 10.verticalSpace,
              Visibility(
                visible: type != 'exchange',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rate'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                    Text(
                      '3%'.tr,
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: 15.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
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
                padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                child: GestureDetector(
                  onTap: () => Get.to(() => ForgetPage(
                        type: 2,
                        flag: 'payPsd',
                      )),
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      "Forgotten?".tr,
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: 14.sp,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, -30.h),
            child: Image.asset(
              ImageUtils.pay_psd_zuanshi_icon,
              width: 64.w,
              height: 70.h,
            ),
          ),
        ),
      ],
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
