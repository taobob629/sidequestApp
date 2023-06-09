import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/ui/frame/sidekick/tabs/tab_ranking/playmate_page.dart';
import 'package:wy/ui/frame/sidekick/widget/container_tab_indicator.dart';

import '../../../../../config/app_color.dart';
import 'consumption_page.dart';
import 'friendship_page.dart';
import 'tab_ranking_ctr.dart';

class TabRankingPage extends StatelessWidget {
  final _ctr = Get.put(TabRankingCtr());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        15.verticalSpace,
        Container(
          height: 34.h,
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: Color(0x33ffffff),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: TabBar(
            controller: _ctr.tabController,
            tabs: _ctr.tabs,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            indicator: ContainerTabIndicator(
              radius: BorderRadius.all(Radius.circular(18.r)),
              colors: [Color(0xFFC554FF), Color(0xFFFF8E2C)],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15.h),
          width: 250.w,
          child: Theme(
            data: Theme.of(context).copyWith(
              tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
                    labelColor: AppColor.yellow, // 设置想要的选中标签文本颜色
                    unselectedLabelColor: Colors.white,
                  ),
            ),
            child: TabBar(
              controller: _ctr.tabController2,
              tabs: _ctr.tabs2,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              indicator: ContainerTabIndicator(
                  height: 4.h,
                  width: 12.w,
                  radius: BorderRadius.circular(2.r),
                  colors: [AppColor.yellow, AppColor.yellow],
                  padding: EdgeInsets.only(top: 10.h)),
            ),
          ),
        ),
        12.verticalSpace,
        Expanded(
          child: TabBarView(
            controller: _ctr.tabController,
            children: [
              PlayMatePage(),
              FriendShipPage(),
              ConsumptionPage(),
            ],
          ),
        ),
      ],
    );
  }
}
