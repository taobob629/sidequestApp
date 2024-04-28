import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../model/coupon_model.dart';

class CouponDialog extends StatelessWidget {
  final CouponModel model;
  final CouponDialogController controller = Get.put(CouponDialogController());

  CouponDialog({required this.model});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1.sw - 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: hexColor('6C5838'),
            width: 1.w,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              hexColor('262731'),
              hexColor('46392B'),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            20.verticalSpace,
            Image.asset(
              ImageUtils.default_logo,
              scale: 3.5,
            ),
            20.verticalSpace,
            Stack(
              children: [
                Image.asset(
                  ImageUtils.coupon_dialog_code_bg,
                  width: 200.w,
                  height: 200.w,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 25.w,
                  top: 25.w,
                  right: 25.w,
                  bottom: 25.w,
                  child: PlatformAiBarcodeCreatorWidget(
                    creatorController: controller.controller,
                    initialValue: model.qrcode,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 15.h,
              ),
              child: Image.asset(ImageUtils.coupon_dialog_line),
            ),
            Row(
              children: [
                15.horizontalSpace,
                Image.asset(
                  ImageUtils.coupon_avali_left_icon,
                  scale: 2,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Available stores'.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ),
                Image.asset(
                  ImageUtils.coupon_dialog_right_icon,
                  scale: 2,
                ),
                15.horizontalSpace,
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 20.h,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (c, i) => Text(
                  model.stores[i],
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: "DIN",
                    color: hexColor('C4B9AF'),
                  ),
                ),
                separatorBuilder: (c, i) => Container(
                  height: 1.h,
                  color: hexColor('D9D9D9').withOpacity(0.2),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                ),
                itemCount: model.stores.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponDialogController extends GetxController {
  CreatorController controller = CreatorController();
}
