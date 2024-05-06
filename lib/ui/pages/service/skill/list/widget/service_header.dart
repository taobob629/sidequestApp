import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../../../../config/icon_font.dart';
import '../../../../../../controller/user_controller.dart';
import '../../../../gift/my_gift_page.dart';
import '../../../../order/my_orders/my_orders_page.dart';

/**
    author:mac
    创建日期:2023/5/20
    描述:
 */
class ServiceHeader extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 109.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              decoration: itemDeraction(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageUtils.ic_games,
                    height: 30.w,
                    width: 30.w,
                  ),
                  6.verticalSpace,
                  Text(
                    'My Services'.tr,
                    style: TextStyle(
                      fontFamily: FONT_LIGHT,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff808388),
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    '${controller.userProfile.service}',
                    style: TextStyle(
                        fontFamily: FONT_MEDIUM,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  )
                ],
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              decoration: itemDeraction(),
              child: InkWell(
                onTap: () => Get.to(
                  () => MyOrdersPage(),
                )?.then((value) => controller.updateInfo()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageUtils.ic_orders,
                      height: 30.w,
                      width: 30.w,
                    ),
                    6.verticalSpace,
                    Text(
                      'SideKick Order'.tr,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: FONT_LIGHT,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff808388),
                      ),
                    ),
                    6.verticalSpace,
                    Obx(() => Text(
                          '${controller.userProfile.orders}',
                          style: TextStyle(
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ))
                  ],
                ),
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              decoration: itemDeraction(),
              child: InkWell(
                onTap: () => Get.to(
                  () => MyGiftPage(),
                )?.then((value) => controller.updateInfo()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageUtils.ic_gift,
                      height: 30.w,
                      width: 30.w,
                    ),
                    6.verticalSpace,
                    Text(
                      'Gift Order'.tr,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: FONT_LIGHT,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff808388),
                      ),
                    ),
                    6.verticalSpace,
                    Obx(() => Text(
                          '${controller.userProfile.giftOrderNum}',
                          style: TextStyle(
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 15.h),
    );
  }

  BoxDecoration itemDeraction() {
    return BoxDecoration(
      color: Color(0xff262731),
      borderRadius: BorderRadius.circular(15.r),
    );
  }
}
