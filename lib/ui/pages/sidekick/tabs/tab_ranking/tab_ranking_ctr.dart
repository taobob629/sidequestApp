import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/sidekick/tabs/tab_ranking/playmate_ctr.dart';

import '../../../../../config/icon_font.dart';
import 'consumption_ctr.dart';
import 'friendship_ctr.dart';

class TabRankingCtr extends GetxController with GetTickerProviderStateMixin {
  static TabRankingCtr get find => Get.find();

  late TabController tabController;
  late TabController tabController2;

  late List<Widget> tabs;
  late List<Widget> tabs2;

  /// 排行类型 1月 2周 3日
  int selectTypeIndex = 1;

  @override
  void onInit() {
    super.onInit();

    tabs = [
      Container(
        height: 34.h,
        alignment: Alignment.center,
        child: Text(
          'Sidekicker'.tr,
          style: TextStyle(
            color: Colors.white,
            fontFamily: FONT_MEDIUM,
            fontSize: 12.sp,
          ),
        ),
      ),
      Container(
        height: 34.h,
        alignment: Alignment.center,
        child: Text(
          'Friendship'.tr,
          style: TextStyle(
            color: Colors.white,
            fontFamily: FONT_MEDIUM,
            fontSize: 12.sp,
          ),
        ),
      ),
      Container(
        height: 34.h,
        alignment: Alignment.center,
        child: Text(
          'Side Buddy'.tr,
          style: TextStyle(
            color: Colors.white,
            fontFamily: FONT_MEDIUM,
            fontSize: 12.sp,
          ),
        ),
      )
    ];
    tabs2 = [
      Text(
        'Month'.tr,
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      ),
      Text(
        'Week'.tr,
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      ),
      Text(
        'Day'.tr,
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      )
    ];
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (tabController.index == tabController.animation?.value) {
        onRefresh(tabController.index);
      }
    });

    tabController2 = TabController(length: tabs2.length, vsync: this);
    tabController2.addListener(() {
      if (tabController2.index == tabController2.animation?.value) {
        selectTypeIndex = tabController2.index + 1;

        onRefresh(tabController.index);
      }
    });
  }

  void onRefresh(int index) {
    switch (index) {
      case 0:
        PlaymateCtr.find.onRefresh();
        break;

      case 1:
        FriendShipCtr.find.onRefresh();
        break;

      case 2:
        ConsumptionCtr.find.onRefresh();
        break;
    }
  }
}
