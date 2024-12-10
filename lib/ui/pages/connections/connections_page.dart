import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/config/app_color.dart';
import 'package:sq_hub_app/ui/pages/addgame/add_game_account_page.dart';

import '../../../config/icon_font.dart';
import '../friend/add_friend_page.dart';
import 'connections_ctr.dart';

class ConnectionsPage extends StatelessWidget {
  final ctr = Get.put(ConnectionsCtr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connections'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: FONT_MEDIUM,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: ctr.tabBarController,
            tabs: ctr.tabsList,
            isScrollable: true,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            unselectedLabelColor: Colors.white,
            labelColor: hexColor('#FFB20E'),
            onTap: (index) => ctr.currentIndex.value = index,
            labelStyle: TextStyle(
              fontSize: 14.sp,
              fontFamily: FONT_LIGHT,
              fontWeight: FontWeight.bold,
            ),
            // 设置选中状态下文本的大小
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontFamily: FONT_LIGHT,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: Colors.transparent,
          ).marginSymmetric(horizontal: 16.w, vertical: 12.h),
          10.verticalSpace,
          Expanded(
            child: TabBarView(
              controller: ctr.tabBarController,
              children: [
                AddGameAccountPage(),
                AddFriendPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
