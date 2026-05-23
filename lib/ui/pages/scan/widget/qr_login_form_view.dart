import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/string_ext.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../controller/user_controller.dart';
import '../../../../widget/views.dart';
import '../qr_login_page.dart';

class QrLoginFromWidget extends GetView<QrLoginPageController> {
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.fromLTRB(15.r, 8.r, 15.r, 8.r),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF92E9B7),
                Color(0xFF8CBEFD),
                Color(0xFFC09EFD),
                Color(0xFFEEB7A9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Obx(() => controller.qrLoginInfoModel == null
            ? buildLoad()
            : Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: ExtendedImage.network(
                          userController.userProfile.avatar,
                          width: 44.w,
                          height: 44.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      12.horizontalSpace,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userController.userProfile.nickName,
                            style: TextStyle(
                                color: AppColor.primary,
                                fontFamily: FONT_MEDIUM),
                          ),
                          5.verticalSpace,
                          Text(
                            userController.userProfile.email,
                            style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 12.sp,
                                fontFamily: FONT_LIGHT),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(ImageUtils.logo_mirror, width: 24.w),
                    ],
                  ),
                  10.verticalSpace,
                  Divider(
                    height: 1.h,
                    color: Colors.white,
                  ),
                  6.verticalSpace,
                  rowItem('Device', controller.qrLoginInfoModel?.device),
                  rowItem(
                    'Price',
                    controller.qrLoginInfoModel?.discountPrice != ''
                        ? '(${controller.qrLoginInfoModel?.price}/Hour)'
                        : '${controller.qrLoginInfoModel?.price}/Hour',
                    deleteLine: true,
                  ),
                  rowItem('Available for Gaming Free Time',
                      controller.qrLoginInfoModel?.gamingFree),
                  rowItem('Discount', controller.qrLoginInfoModel?.discount),
                  rowItem('Remaining Balance',
                      ' £${controller.qrLoginInfoModel?.balance}'),
                  rowItem('Remaining Gaming Free Time',
                      controller.qrLoginInfoModel?.freetime),
                  rowItem('Remaining Credit Duration',
                      controller.qrLoginInfoModel?.estimatedtime),
                  rowItem('Estimated Exhausted Time',
                      controller.qrLoginInfoModel?.estimatedDatetime.toDateStr),
                ],
              )),
      );

  rowItem(String label, var content, {bool deleteLine = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.r),
      child: Row(
        children: [
          Text(
            label.tr,
            style: TextStyle(
              color: Color(0xFF5E5D64),
              fontSize: 12.sp,
              fontFamily: FONT_MEDIUM,
            ),
          ),
          Spacer(),
          Visibility(
            visible:
                deleteLine && controller.qrLoginInfoModel?.discountPrice != '',
            child: Text(
              ' £ ${controller.qrLoginInfoModel?.discountPrice}/Hour',
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 12.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
          ),
          Text(
            '$content',
            style: TextStyle(
              decoration: deleteLine
                  ? controller.qrLoginInfoModel?.discountPrice != ''
                      ? TextDecoration.lineThrough
                      : TextDecoration.none
                  : TextDecoration.none,
              color: AppColor.primary,
              fontSize: 12.sp,
              fontFamily: FONT_MEDIUM,
            ),
          ),
        ],
      ),
    );
  }
}
