import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/base_scaffold.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../utils/toast_utils.dart';
import 'invite_ctr.dart';

class InvitePage extends StatelessWidget {
  final ctr = Get.put(InviteCtr());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "${ctr.title}",
      body: Obx(() => ctr.model.value.url == null
          ? Container()
          : Column(
              children: [
                20.verticalSpace,
                CachedNetworkImage(
                  imageUrl: '${ctr.model.value.image}',
                  height: 160.h,
                  width: 1.sw,
                  fit: BoxFit.fill,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    left: 16.w,
                    top: 14.h,
                    bottom: 14.h,
                  ),
                  child: Text(
                    'Share your link',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: FONT_MEDIUM,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => {
                    Clipboard.setData(
                        ClipboardData(text: '${ctr.model.value.url}')),
                    showToast('Copied Successfully'.tr),
                  },
                  child: Container(
                    height: 30.h,
                    width: 1.sw - 32.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageUtils.invite_copy_bg),
                        fit: BoxFit.fill,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: 14.w,
                      right: 56.w,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${ctr.model.value.url}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 15.h,
                  ),
                  margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                  decoration: BoxDecoration(
                    color: Color(0xff262731),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: [
                      itemWidget(
                        icon: ImageUtils.invite_icon,
                        name: 'Invited'.tr,
                        num: '${ctr.model.value.nvited}',
                        color: Color(0xffA68FFF),
                      ),
                      itemWidget(
                        icon: ImageUtils.coin_icon,
                        name: 'Coin'.tr,
                        num: '${ctr.model.value.coin}',
                        color: Color(0xffFDD913),
                      ),
                      itemWidget(
                        icon: ImageUtils.sidekicker_icon,
                        name: 'Sidekicker'.tr,
                        num: '${ctr.model.value.sidekicker}',
                        color: Color(0xff93EF95),
                      ),
                      itemWidget(
                        icon: ImageUtils.order_icon,
                        name: 'Order'.tr,
                        num: '${ctr.model.value.orderNum}',
                        color: Color(0xffffffff),
                      ),
                      itemWidget(
                        icon: ImageUtils.diamond_icon,
                        name: 'Diamond'.tr,
                        num: '${ctr.model.value.diamond}',
                        color: Color(0xffFEC0E3),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14.r),
                  margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                  decoration: BoxDecoration(
                    color: Color(0xff262731),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  width: 1.sw,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rules'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: FONT_MEDIUM,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${ctr.model.value.rule}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontFamily: 'DIN',
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
    );
  }

  Widget itemWidget({
    required String icon,
    required String name,
    required String num,
    required Color color,
  }) =>
      Expanded(
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 38.w,
              height: 38.w,
              fit: BoxFit.cover,
            ),
            4.verticalSpace,
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: 'DIN',
              ),
            ),
            6.verticalSpace,
            Text(
              num,
              style: TextStyle(
                color: color,
                fontSize: 14.sp,
                fontFamily: 'DIN',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}
