/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/social/post/post_list_page.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../controller/user_controller.dart';
import '../messages/messages_page.dart';
import 'controller.dart';

class TabSocialPage extends StatelessWidget {
  final controller = Get.put(SocialTabController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Container(
              height: 34.h,
              margin: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 10.h,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) => Obx(() => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => controller.clickTopTab(i),
                      child: badges.Badge(
                        shape: badges.BadgeShape.circle,
                        badgeColor: Colors.red,
                        position: badges.BadgePosition(top: -4.h, end: 4.h),
                        animationType: badges.BadgeAnimationType.fade,
                        animationDuration: const Duration(microseconds: 500),
                        showBadge: i == 1 &&
                            UserController.find.unreadMsgCount.value > 0,
                        badgeContent: Text(
                          "${UserController.find.unreadMsgCount.value}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                        ignorePointer: true,
                        child: Container(
                          width: 96.w,
                          decoration: controller.selectTopTabIndex.value == i
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: hexColor('FFB20E'),
                                  ),
                                )
                              : BoxDecoration(
                                  color: hexColor('141414'),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                          alignment: Alignment.center,
                          child: Text(
                            controller.tabs[i],
                            style: TextStyle(
                              color: controller.selectTopTabIndex.value == i
                                  ? hexColor('FFB20E')
                                  : Colors.white,
                              fontFamily: FONT_MEDIUM,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    )),
                separatorBuilder: (c, i) => 15.horizontalSpace,
                itemCount: controller.tabs.length,
              ),
            ),
            if (controller.selectTopTabIndex.value == 0) PostListPage(),
            if (controller.selectTopTabIndex.value == 1) MessagesPage(),
          ],
        ));
  }
}
