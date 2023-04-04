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
import 'package:wy/ui/frame/profile/model/profile_model.dart';
import 'package:wy/utils/index.dart';

import 'my_profile_page.dart';

class BadgesWidget extends GetView<ProfileController> {
  BadgesItem badge;

  BadgesWidget(this.badge);

  var itemSize;

  @override
  Widget build(BuildContext context) {
    itemSize = (Get.width - 30 * 2) / 6;
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      constraints: BoxConstraints(minHeight: 120.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Text(
              '${badge?.name}',
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 100.h,
            margin: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
            //   padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xff313033),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Swiper(
              outer: true,
              loop: false,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: badge.getPageData(index).map((e) => badgeItem(e)).toList(),
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
          )
        ],
      ),
    );
  }

  Widget badgeItem(BadgeItem item) {
    return Container(
      width: itemSize,
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.lighted)
            ImageUtil.networkImage(
              url: item.iconImage,
              width: itemSize - 10,
              height: itemSize - 10,
              fit: BoxFit.cover,
            ),
          if (item.lighted == false)
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.dstIn),
              child: ImageUtil.networkImage(
                url: item.iconImage,
                width: itemSize - 10,
                height: itemSize - 10,
              ),
            ),
          Text(
            '${item.iconName}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 6.sp, fontFamily: FONT_LIGHT),
          )
        ],
      ),
    );
  }
}
