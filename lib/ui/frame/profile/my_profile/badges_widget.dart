/**
    author:mac
    创建日期:2023/4/3
    描述:
 */
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/frame/profile/model/profile_model.dart';
import 'package:wy/utils/index.dart';

import 'my_profile_page.dart';

class BadgesWidget extends GetView<ProfileController> {
  BadgesItem badge;

  BadgesWidget(this.badge);

  var itemSize;
  var cardItemSize;

  @override
  Widget build(BuildContext context) {
    itemSize = (Get.width - 30 * 2 - 5 * 2) / 6;
    cardItemSize = 120.h;
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Text(
              '${badge?.name}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
            decoration: itemDecoration(color: AppColor.itemBg2),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 110.h, maxHeight: 110.h),
              child: Swiper(
                outer: false,
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: badge
                          .getPageData(index)
                          .map((e) => badgeItem(e))
                          .toList(),
                    ),
                  );
                },
                itemCount: badge.getPageSize(),
                pagination: SwiperPagination(
                    builder: RectSwiperPaginationBuilder(
                        color: AppColor.greyAF,
                        activeColor: AppColor.yellow,
                        size: Size(10, 10),
                        activeSize: Size(18, 10))),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget badgeItem(BadgeItem item) {
    var iconSize = itemSize - 15;
    return Container(
      width: itemSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.lighted)
            Container(
              padding: EdgeInsets.all(5),
              child: ImageUtil.networkImage(
                url: item.iconImage,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.cover,
              ),
            ),
          if (item.lighted == false)
            Container(
              padding: EdgeInsets.all(5),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(0.5), BlendMode.dstIn),
                child: ImageUtil.networkImage(
                  url: item.iconImage,
                  fit: BoxFit.cover,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),
          5.verticalSpace,
          Text(
            '${item.iconName}',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                overflow: TextOverflow.ellipsis,
                fontFamily: FONT_LIGHT),
          )
        ],
      ),
    );
  }
}
