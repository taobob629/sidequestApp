import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/ui/frame/sidekick/tabs/tab_ranking/playmate_page.dart';
import 'package:wy/ui/frame/sidekick/widget/segment/custom_sliding_segmented_control.dart';

import '../../../../../config/app_color.dart';
import '../../../../../widget/tab_widget.dart';
import '../../../../common/home_indicator.dart';
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
        CustomSlidingSegmentedControl(
          initialValue: 0,
          fixedWidth: (Get.width - 30.w) / 3,
          children: {
            0: Text(
              'Playmate',
              style: TextStyle(
                color: Colors.white,
                fontFamily: FONT_MEDIUM,
                fontSize: 12.sp,
              ),
            ),
            1: Text(
              'Friendship',
              style: TextStyle(
                color: Colors.white,
                fontFamily: FONT_MEDIUM,
                fontSize: 12.sp,
              ),
            ),
            2: Text(
              'Consumption',
              style: TextStyle(
                color: Colors.white,
                fontFamily: FONT_MEDIUM,
                fontSize: 12.sp,
              ),
            ),
          },
          decoration: BoxDecoration(
            color: Color(0x33ffffff),
            borderRadius: BorderRadius.circular(30.r),
          ),
          thumbDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFC554FF), Color(0xFFFF8E2C)],
            ),
            borderRadius: BorderRadius.circular(30.r),
          ),
          onValueChanged: (int? value) => _ctr.tabbarController?.index = value ?? 0,
        ),
        12.verticalSpace,
        Expanded(
          child: TabWidget(
            tabstyle: TAB_STYLE_3,
            indicator:
                HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
            tabController: _ctr.tabbarController,
            tabList: _ctr.tabs,
            pagePhysics: NeverScrollableScrollPhysics(),
            tabPage: [
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
