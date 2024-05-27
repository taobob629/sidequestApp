import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/widget/image_util.dart';

import '../../../config/icon_font.dart';
import '../../../getx_ctr/bundles_detail_ctr.dart';
import 'bundle_confirm_order_page.dart';

class BundlesDetailPage extends StatelessWidget {
  final ctr = Get.put(BundlesDetailCtr());

  @override
  Widget build(BuildContext context) => Container(
        width: 1.sw,
        height: 1.sh,
        padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
        child: Obx(() => Stack(
              children: [
                Container(
                  width: 1.sw,
                  height: 274.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF0A0A0A), Color(0xFF2B221C)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: ImageUtil.networkImage(
                          url: "${ctr.model.value.image}",
                          height: 274.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.back(),
                        child: Container(
                          width: 34.w,
                          height: 34.w,
                          margin: EdgeInsets.only(left: 16.w),
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 260.h,
                  bottom: 60.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 1.sw,
                    decoration: ShapeDecoration(
                      color: hexColor('0A0A0A'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ctr.model.value.name ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingOnly(left: 16.w, top: 20.h),
                          Visibility(
                            visible: ctr.model.value.brief != null,
                            child: Text(
                              ctr.model.value.brief ?? '',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: 'DIN',
                                fontWeight: FontWeight.w400,
                              ),
                            ).paddingOnly(
                              left: 16.w,
                              right: 110.w,
                              top: 16.h,
                              bottom: 12.h,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                ImageUtils.product_content_icon,
                                height: 20.h,
                              ),
                              10.horizontalSpace,
                              Text(
                                'Product Content',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 16.w, top: 20.h, right: 16.w),
                          Text(
                            'All Day pass X4',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14.sp,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w400,
                            ),
                          ).paddingOnly(left: 44.w, top: 20.h),
                          Row(
                            children: [
                              Image.asset(
                                ImageUtils.shop_icon,
                                height: 20.h,
                              ),
                              10.horizontalSpace,
                              Text(
                                'Supported Stores',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: FONT_MEDIUM,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 16.w, top: 20.h, right: 16.w),
                          ...ctr.model.value.stores
                              .map(
                                (e) => Text(
                                  e,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14.sp,
                                    fontFamily: 'DIN',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ).paddingOnly(left: 44.w, top: 20.h),
                              )
                              .toList(),
                          Visibility(
                            visible: ctr.model.value.introduce != null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      ImageUtils.introduce_icon,
                                      height: 20.h,
                                    ),
                                    10.horizontalSpace,
                                    Text(
                                      'Instructions',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: FONT_MEDIUM,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(
                                    left: 16.w, top: 20.h, right: 16.w),
                                Text(
                                  '${ctr.model.value.introduce}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14.sp,
                                    fontFamily: 'DIN',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ).paddingOnly(left: 44.w, top: 20.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 250.h,
                  right: 16.w,
                  child: Container(
                    width: 90.w,
                    height: 90.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          ImageUtils.bundles_detail_price_bg,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '£${double.parse(ctr.model.value.price)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontFamily: FONT_MEDIUM,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        4.verticalSpace,
                        Visibility(
                          visible: ctr.model.value.price !=
                              ctr.model.value.originalPrice,
                          child: Text(
                            '£${double.parse(ctr.model.value.originalPrice)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'DIN',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 1.sw,
                    height: 60.h,
                    decoration: ShapeDecoration(
                      color: hexColor('141517'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '£ ${ctr.model.value.price}',
                            style: TextStyle(
                              color: const Color(0xFFFFB20E),
                              fontSize: 24.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingOnly(left: 16.w),
                        ),
                        InkWell(
                          onTap: () => ctr.addTea(),
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            margin: EdgeInsets.only(right: 16.w),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFB20E),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      );
}
