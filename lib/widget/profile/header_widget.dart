/**
    author:mac
    创建日期:2023/5/20
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/frame/messages/fans/fans_list_page.dart';
import 'package:wy/ui/frame/messages/follow/follow_list_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:wy/ui/frame/profile/my_profile/visitor_page.dart';
import 'package:wy/ui/frame/profile/play_order/rating_comment_page.dart';

class ProfileHeaderWidget extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 76.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        margin: EdgeInsets.only(bottom: 15.w),
        decoration: BoxDecoration(
          color: Color(0xff262731),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Get.to(() => FollowListPage()),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      badges.Badge(
                        showBadge: false,
                        badgeContent: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "${controller.userProfile.followerToday}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        badgeColor: Color(0xffFF4848),
                        position: badges.BadgePosition(end: -10, top: -6),
                        alignment: Alignment.topRight,
                        child: Text(
                          controller.userProfile.followers < 10000
                              ? '${controller.userProfile.followers}'
                              : '9999+',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      7.verticalSpace,
                      Text(
                        "Followings".tr,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0xff808388),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Get.to(() => FansListPage())
                    ?.then((value) => UserController.find.updateInfo()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    badges.Badge(
                      showBadge: controller.userProfile.followerToday > 0,
                      badgeContent: Text(
                        "${controller.userProfile.followerToday}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                      badgeColor: Color(0xffFF4848),
                      position: badges.BadgePosition(end: -10, top: -6),
                      alignment: Alignment.topRight,
                      child: Text(
                        "${controller.userProfile.fans}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    7.verticalSpace,
                    Text(
                      "Followers".tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Color(0xff808388),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.userProfile.isAuth == 1)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => RatingCommentPage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        badges.Badge(
                          showBadge: false,
                          badgeContent: Text(
                            "${controller.userProfile.ranking}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                          badgeColor: Color(0xffFF4848),
                          position: badges.BadgePosition(end: -10, top: -6),
                          alignment: Alignment.topRight,
                          child: Text(
                            "${controller.userProfile.ranking}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        7.verticalSpace,
                        Text(
                          "Rating".tr,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Color(0xff808388),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await Get.to(() => VisitorPage());
                  controller.updateInfo();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      badges.Badge(
                        showBadge: controller.userProfile.visitorToday > 0,
                        badgeContent: Text(
                          '${controller.userProfile.visitorToday}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                        badgeColor: Color(0xffFF4848),
                        position: badges.BadgePosition(end: -10, top: -6),
                        alignment: Alignment.topRight,
                        child: Text(
                          controller.userProfile.visitor < 10000
                              ? '${controller.userProfile.visitor}'
                              : '9999+',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      ),
                      7.verticalSpace,
                      Text(
                        "Visitors".tr,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0xff808388),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
