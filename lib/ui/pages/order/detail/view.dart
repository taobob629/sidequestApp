/**
    author:mac
    创建日期:2023/3/21
    描述:
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/common/basePage.dart';
import 'package:sq_hub_app/common/string_ext.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/order/detail/widgets/widgets.dart';
import 'package:sq_hub_app/utils/decimal_utils.dart';
import 'package:timelines/timelines.dart';

import '../../../../common/base_controller.dart';
import '../../../../common/styles.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../model/order_detail.dart';
import '../../../../model/order_detail_new_model.dart';

import '../../../../widget/image_util.dart';
import '../../../../widget/scaffold_widget.dart';

import 'order_detail_ctr.dart';

class OrderDetailPage extends StatelessWidget {
  final ctr = Get.put(OrderDetailCtr());

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        title: Text('Order details'.tr),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Obx(() => Column(
              children: [
                Container(
                  width: 1.sw,
                  decoration: ShapeDecoration(
                    color: Color(0xFF141517),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'PICKUP NUMBER'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.41,
                        ),
                      ).paddingOnly(bottom: 12.h),
                      Text(
                        '${ctr.model.value.pickNum}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFB20E),
                          fontSize: 28.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Visibility(
                        visible: ctr.model.value.reward > 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Points reward'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0x99ffffff),
                                fontSize: 14.sp,
                                fontFamily: FONT_MEDIUM,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    hexColor('#442A23'),
                                    hexColor('#141517')
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(4.w, 6.h, 30.w, 6.h),
                              child: Row(
                                children: [
                                  Image.asset(
                                    ImageUtils.coin_red,
                                    width: 19.w,
                                    height: 19.w,
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    '${ctr.model.value.reward}Points',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: hexColor('#FFB20E'),
                                      fontSize: 14.sp,
                                      fontFamily: FONT_MEDIUM,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).marginOnly(top: 28.h),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 1.sw,
                  decoration: ShapeDecoration(
                    color: Color(0xFF141517),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  padding: EdgeInsets.all(24.r),
                  margin: EdgeInsets.only(top: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ctr.model.value.storeName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.w600,
                        ),
                      ).paddingOnly(bottom: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white.withOpacity(0.6),
                            size: 12.sp,
                          ).paddingOnly(top: 4.h),
                          3.horizontalSpace,
                          Expanded(
                            child: Text(
                              '${ctr.model.value.address}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 10.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                                height: 1.8,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(right: 45.w),
                      Container(
                        height: 1.h,
                        decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (c, i) =>
                            itemWidget(ctr.model.value.items[i]),
                        separatorBuilder: (c, i) => 10.verticalSpace,
                        itemCount: ctr.model.value.items.length,
                      ),
                      Container(
                        height: 1.h,
                        decoration: BoxDecoration(color: Color(0xFF2F2F2F)),
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total price',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            '£${ctr.model.value.total}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 16.h, bottom: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Discount',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            '£${ctr.model.value.discount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ).paddingOnly(bottom: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'SubTotal',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            '£${ctr.model.value.total != null && ctr.model.value.discount != null ? ctr.model.value.total.toString().minus(ctr.model.value.discount.toString()) : '0.00'}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.sw,
                  decoration: ShapeDecoration(
                    color: Color(0xFF141517),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  margin: EdgeInsets.only(top: 12.h),
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${ctr.model.value.status}',
                            style: TextStyle(
                              color: Color(0xFFFFB20E),
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order number',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            '${ctr.model.value.orderSn}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order time',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                fontFamily: FONT_MEDIUM,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            '${ctr.model.value.orderTime}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 16.h),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16.w)),
      ),
    );
  }

  Widget itemWidget(OrderDetailItem model) => Row(
        children: [
          ImageUtil.networkImage(
            url: "${model.picUrl}",
            width: 65.w,
            height: 65.w,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                6.verticalSpace,
                Visibility(
                  visible: true,
                  child: Text(
                    '£${model.retailPrice}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              // Text(
              //   '£${model.retailPrice}',
              //   style: TextStyle(
              //     color: Color(0xFFFFB20E),
              //     fontSize: 16.sp,
              //     fontFamily: FONT_MEDIUM,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // 6.verticalSpace,
              Text(
                'X${model.num}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontFamily: FONT_MEDIUM,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      );
}
