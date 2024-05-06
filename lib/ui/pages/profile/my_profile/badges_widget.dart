/**
    author:mac
    创建日期:2023/4/3
    描述:
 */
import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../../../config/app_color.dart';
import '../../../../config/icon_font.dart';
import '../../../../image_utils.dart';
import '../../../../model/profile_model.dart';
import '../badge_detail_widget.dart';
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
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  left: 15.w,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 16.h,
                      margin: EdgeInsets.only(right: 4.w),
                      color: hexColor('FFB20E'),
                    ),
                    Text(
                      badge.name.toUpperCase().tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: FONT_MEDIUM,
                      ),
                    ),
                  ],
                ),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            margin: EdgeInsets.fromLTRB(15.w, 6.h, 15.w, 0),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => SmartDialog.show(
        builder: (builder) {
          TrophieModel model = TrophieModel(
            iconLightImage: item.iconImage,
            iconName: item.iconName,
            tips: item.tips,
          );

          return BadgeDetailWidget(model);
        },
        animationTime: Duration.zero,
        clickMaskDismiss: true,
      ),
      child: SizedBox(
        width: itemSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (item.lighted)
            Container(
              padding: EdgeInsets.all(5),
              child: ExtendedImage.network(
                item.iconImage,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.cover,
              ),
            ),
            // if (item.lighted == false)
            //   Container(
            //     padding: EdgeInsets.all(5),
            //     child: ColorFiltered(
            //       colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.dstIn),
            //       child: ImageUtil.networkImage(
            //         url: item.iconImage,
            //         fit: BoxFit.cover,
            //         width: iconSize,
            //         height: iconSize,
            //       ),
            //     ),
            //   ),
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
                height: 1.2,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Triangle extends CustomClipper<Path> {
  double dir;

  Triangle({required this.dir});

  @override
  Path getClip(Size size) {
    var path = Path();

    double w = size.width;
    double h = size.height;
    if (dir < 0) {
      path.moveTo(w / 2, 0);
      path.quadraticBezierTo(w / 2, 0, 0, h);
      path.quadraticBezierTo(0, h, w, h);
    } else {
      path.quadraticBezierTo(0, h / 2, w * 2 / 3, h);
      path.quadraticBezierTo(w / 3, h / 3, w, 0);
      path.lineTo(0, 0);
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
