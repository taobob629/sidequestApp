import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/image_utils.dart';
import 'package:wy/utils/image_util.dart';

import '../../../model/balance_record_model.dart';

class RecordItem extends StatelessWidget {
  final int type;
  final ConsumeRecordModel model;

  RecordItem({
    required this.type,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (type) {
      case 1:
        widget = _topUpWidget();
        break;
      case 2:
        widget = _gamingWidget();
        break;
      case 3:
        widget = _productWidget();
        break;

      default:
        widget = _topUpWidget();
        break;
    }
    return widget;
  }

  Widget _productWidget() => Container(
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        margin: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: model.refund == 0
                        ? Color(0xff4BE72C)
                        : Color(0xff9EB4C3),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                10.horizontalSpace,
                Text(
                  model.refund == 0 ? 'Completed'.tr : 'Refund'.tr,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 13.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                Spacer(),
                Text(
                  model.amount,
                  style: TextStyle(
                    color: model.refund == 0
                        ? Color(0xffFFCB0E)
                        : Color(0xff4BE72C),
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: ImageUtil.networkImage(
                      url: model.goodsUrl,
                      width: 68.w,
                      height: 68.w,
                      fit: BoxFit.cover),
                ),
                15.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'X${model.num}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        model.addtime.toDateStr,
                        style: TextStyle(
                          color: Color(0xffB2B9C9),
                          fontSize: 12.sp,
                          fontFamily: FONT_MEDIUM,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 1.h,
              color: Color(0xff2D2E3A),
              margin: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount'.tr,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                Text(
                  '£ ${model.discount}',
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
            // 10.verticalSpace,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Coupon Code'.tr,
            //       style: TextStyle(
            //         color: Color(0xffB2B9C9),
            //         fontSize: 12.sp,
            //         fontFamily: FONT_MEDIUM,
            //       ),
            //     ),
            //     Text(
            //       model.couponCode,
            //       style: TextStyle(
            //         color: Color(0xffB2B9C9),
            //         fontSize: 12.sp,
            //         fontFamily: FONT_MEDIUM,
            //       ),
            //     ),
            //   ],
            // ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order No.'.tr,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                Text(
                  model.orderNo,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _gamingWidget() => Container(
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        margin: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  ImageUtils.icon_location,
                  width: 15.w,
                  height: 15.w,
                ),
                10.horizontalSpace,
                Text(
                  model.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                )
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Image.asset(
                  ImageUtils.icon_computer,
                  width: 15.w,
                  height: 15.w,
                ),
                10.horizontalSpace,
                Text(
                  model.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                )
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Image.asset(
                  ImageUtils.icon_time,
                  width: 15.w,
                  height: 15.w,
                ),
                10.horizontalSpace,
                Text(
                  '${model.duration}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                )
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: Color(0xff4BE72C),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                10.horizontalSpace,
                Text(
                  'Start Time: '.tr,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                Text(
                  model.timeStart.toDateStr,
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: Color(0xffE7522C),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                10.horizontalSpace,
                Text(
                  'End  Time:'.tr,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                6.horizontalSpace,
                Text(
                  model.timeEnd.toDateStr,
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
            Container(
              height: 1.h,
              color: Color(0xff2D2E3A),
              margin: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Free Time: '.tr,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                6.horizontalSpace,
                Container(
                  width: 60.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    model.free,
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Discount: '.tr,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                6.horizontalSpace,
                Container(
                  width: 60.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '￡ ${model.discount}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 12.sp,
                      fontFamily: FONT_MEDIUM,
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                model.amount,
                style: TextStyle(
                  color: Color(0xffFFCB0E),
                  fontSize: 16.sp,
                  fontFamily: FONT_MEDIUM,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _topUpWidget() => Container(
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        margin: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  model.refund == 0
                      ? ImageUtils.icon_top_up
                      : ImageUtils.icon_refound,
                  width: 30.w,
                  height: 30.w,
                ),
                10.horizontalSpace,
                Text(
                  model.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                )
              ],
            ),
            Container(
              height: 1.h,
              color: Color(0xff2D2E3A),
              margin: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
            ),
            Text(
              model.amount,
              style: TextStyle(
                color: Color(0xffFFCB0E),
                fontSize: 16.sp,
                fontFamily: FONT_MEDIUM,
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                Text(
                  'Balance:£${double.parse(model.nowBalance) / 100}',
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
                Spacer(),
                Text(
                  model.time,
                  style: TextStyle(
                    color: Color(0xffB2B9C9),
                    fontSize: 12.sp,
                    fontFamily: FONT_MEDIUM,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
