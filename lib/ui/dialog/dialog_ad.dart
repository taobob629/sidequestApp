import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../api/index_api.dart';
import '../../controller/user_controller.dart';
import '../../model/promotion_item_model.dart';
import '../../utils/navigator_helper.dart';
import '../../utils/toast_utils.dart';

class PopAdDialog extends StatelessWidget {
  final PromotionItemModel model;
  var secondsRemaining = 10.obs;
  static Timer? mTimer;

  PopAdDialog({required this.model});

  @override
  Widget build(BuildContext context) {
    startCountdown();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () {
              UserController userController = Get.find<UserController>();
              if (userController.user.value.id != 0) {
                IndexApi.readAD(model.id, model.title);
              }
              Get.back();
              NavigatorHelper.gotoConfigTarget(model.content);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ImageUtil.networkImage(
                      url: model.image,
                      fit: BoxFit.cover,
                      border: 20.r,
                      width: 331.w,
                      height: 431.w,
                    ),
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        width: 46.w,
                        height: 24.h,
                        decoration: ShapeDecoration(
                          color: Color(0x6B161616),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r)),
                        ),
                        alignment: Alignment.center,
                        child: Obx(() => Text(
                              '${secondsRemaining.value}s',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                _buildCloseButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () {
        mTimer?.cancel();
        mTimer = null;
        Get.back();
      },
      child: Container(
        height: 30.w,
        width: 30.w,
        margin: EdgeInsets.only(top: 24.h),
        decoration: BoxDecoration(
          color: Color(0x80000000),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: hexColor('303030'), width: 1.w),
        ),
        child: Center(
          child: Icon(
            Icons.clear,
            size: 26.sp,
            color: hexColor('303030'),
          ),
        ),
      ),
    );
  }

  void startCountdown() {
    mTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
        mTimer = null;
        // 倒计时结束后的逻辑处理
        Get.back();
      }
    });
  }

  static Future<bool?> show(PromotionItemModel model,
      {bool cancelable = true}) async {
    return await Get.dialog(
      PopAdDialog(
        model: model,
      ),
      barrierDismissible: cancelable,
    );
  }
}
