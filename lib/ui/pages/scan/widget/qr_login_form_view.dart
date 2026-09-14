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
            border: Border.all(width: 1, color: const Color(0xCCFFFFFF)),
            borderRadius: BorderRadius.all(Radius.circular(15.r)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x264C64C8),
                offset: Offset(0, 10),
                blurRadius: 30,
              ),
            ],
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
                    '${controller.qrLoginInfoModel?.price}/Hour',
                    trailing:
                        _hasDiscount ? _buildDiscountedPrice() : null,
                  ),
                  rowItem('Available for Gaming Free Time',
                      controller.qrLoginInfoModel?.gamingFree),
                  rowItem(
                    'Discount',
                    controller.qrLoginInfoModel?.discount,
                    trailing: _hasDiscount ? _buildDiscountBadge() : null,
                  ),
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

  bool get _hasDiscount =>
      controller.qrLoginInfoModel?.discountPrice?.trim().isNotEmpty ?? false;

  Widget _buildDiscountedPrice() {
    final model = controller.qrLoginInfoModel;
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 7.w,
      runSpacing: 4.h,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xE6191A21),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '£${model?.discountPrice}/Hour',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontFamily: FONT_MEDIUM,
            ),
          ),
        ),
        Text(
          '£${model?.price}/Hour',
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationThickness: 1.5,
            color: const Color(0xFF5E5D64),
            fontSize: 11.sp,
            fontFamily: FONT_MEDIUM,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    final discount = controller.qrLoginInfoModel?.discount ?? '';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF04F64), Color(0xFFFF8A55)],
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer_rounded,
            size: 12.sp,
            color: Colors.white,
          ),
          4.horizontalSpace,
          Text(
            discount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontFamily: FONT_MEDIUM,
            ),
          ),
        ],
      ),
    );
  }

  rowItem(String label, var content, {Widget? trailing}) {
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
          12.horizontalSpace,
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing ??
                  Text(
                    '$content',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
