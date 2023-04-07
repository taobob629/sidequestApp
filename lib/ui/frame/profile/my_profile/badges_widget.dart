/**
    author:mac
    创建日期:2023/4/3
    描述:
 */
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/index.dart';
import 'package:wy/ui/frame/profile/model/profile_model.dart';
import 'package:wy/utils/index.dart';

import '../../../../image_utils.dart';
import '../../../playwith/balance/my_earnings_page.dart';
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
            padding: EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                Text(
                  '${badge.name}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTapDown: (details) {
                    print(details.globalPosition);
                    Get.dialog(TipsDialog(
                      offset: details.globalPosition,
                      tips: badge.tips,
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 6),
                    width: 12.w,
                    height: 12.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffb2b9c9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Image.asset(
                      ImageUtils.icon_help,
                      width: 10.w,
                      height: 10.w,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            margin: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Color(0xff262731),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 110.h, maxHeight: 110.h),
              child: Swiper(
                outer: false,
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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

class TipsDialog extends StatelessWidget {
  TipsDialog({Key? key, required this.offset, required this.tips})
      : super(key: key);
  final Offset offset;
  final String tips;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15,
          left: offset.dx - 10,
          child: ClipPath(
            clipper: Triangle(dir: -1),
            child: Container(
              width: 20.0,
              height: 10.0,
              color: Color(0xff282640),
              child: null,
            ),
          ),
        ),
        Positioned(
          top: offset.dy - MediaQuery.of(Get.context!).padding.top + 15 + 10,
          width: Get.width - offset.dx / 2,
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                color: Color(0xff282640),
                borderRadius: BorderRadius.circular(10.r)),
            child: Text(
              tips,
              style: TextStyle(
                color: Color(0xff8291B4),
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
