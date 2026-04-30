import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../widget/image_util.dart';

class DialogSupportStores extends StatelessWidget {
  List<String> stores;
  List<String> platforms;
  String? image;
  String? name;

  DialogSupportStores(this.stores, this.platforms, {this.image, this.name});

  @override
  Widget build(BuildContext context) {
    final String? localImage = image;
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
            localImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: ImageUtil.networkImage(
                      url: localImage,
                      width: 100.h,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    ImageUtils.default_logo,
                    scale: 3.5,
                  ),
            10.verticalSpace,
            name != null
                ? Text(
                    name!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      color: Colors.white,
                    ),
                  )
                : Container(),
            20.verticalSpace,
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 15.h,
              ),
              child: Image.asset(ImageUtils.coupon_dialog_line),
            ),
            Row(
              children: [
                // 15.horizontalSpace,
                // Image.asset(
                //   ImageUtils.coupon_avali_left_icon,
                //   scale: 2,
                // ),
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
                  stores[i],
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
                itemCount: stores.length,
              ),
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
                // 15.horizontalSpace,
                // Image.asset(
                //   ImageUtils.coupon_avali_left_icon,
                //   scale: 2,
                // ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Support platform'.tr,
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
                  platforms[i],
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
                itemCount: platforms.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
