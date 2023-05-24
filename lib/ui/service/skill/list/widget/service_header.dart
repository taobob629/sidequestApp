import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/order/my_orders/my_orders_page.dart';
import 'package:wy/utils/index.dart';

import '../../../../gift/my_gift_page.dart';

/**
    author:mac
    创建日期:2023/5/20
    描述:
 */
class ServiceHeader extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              decoration: itemDeraction(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageUtil.assetImage('profile/ic_games', height: 32.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sidekick'.tr,
                        style: TextStyle(
                          fontFamily: FONT_LIGHT,
                          fontSize: 11.sp,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageUtil.assetImage('profile/ic_orders',
                        width: 32.w, height: 32.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Order'.tr,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: FONT_LIGHT,
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
                    )
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageUtil.assetImage('profile/ic_orders',
                        width: 32.w, height: 32.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Gift'.tr,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: FONT_LIGHT,
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
                    )
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
