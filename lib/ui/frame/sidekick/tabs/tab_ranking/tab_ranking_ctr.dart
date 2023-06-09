import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/base_tab_controller.dart';
import '../../../../../config/icon_font.dart';

class TabRankingCtr extends GetxController with GetTickerProviderStateMixin {
  var selectCatIndex = 0.obs;

  late TabController tabController;
  late TabController tabController2;

  late List<Widget> tabs;
  late List<Widget> tabs2;

  @override
  void onInit() {
    super.onInit();

    tabs = [
      Container(
        height: 34.h,
        alignment: Alignment.center,
        child: Text(
          'Playmate',
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
          'Friendship',
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
          'Consumption',
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
        'Month',
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      ),
      Text(
        'Week',
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      ),
      Text(
        'Day',
        style: TextStyle(
          fontFamily: FONT_MEDIUM,
          fontSize: 14.sp,
        ),
      )
    ];
    tabController = TabController(length: tabs.length, vsync: this);
    tabController2 = TabController(length: tabs2.length, vsync: this);
  }
}
