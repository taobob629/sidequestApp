import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';

import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../model/beans/games_left_tab_bean.dart';
import '../hubs/tab/tab_bubble_tea_page.dart';
import '../hubs/tab/tab_games_filter_page.dart';
import 'news_page.dart';

class TabHubsPage extends StatelessWidget {
  final controller = Get.put(TabHubsPageController());

  @override
  Widget build(BuildContext context) => Obx(() => Column(
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
                    child: Container(
                      width: 86.w,
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
                        controller.topTabs[i],
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
                  )),
              separatorBuilder: (c, i) => 15.horizontalSpace,
              itemCount: controller.topTabs.length,
            ),
          ),
          if (controller.selectTopTabIndex.value == 0) TabGamesFilterPage(),
          if (controller.selectTopTabIndex.value == 1) TabGamesFilterPage(),
          if (controller.selectTopTabIndex.value == 2) TabBubbleTeaPage(),
        ],
      ));
}

class TabHubsPageController extends GetxController {
  static TabHubsPageController get find => Get.find();

  List<String> topTabs = ["Games".tr, "HIW".tr, "Bubble tea".tr];

  var selectTopTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    Get.put(TabGamesFilterController());
    Get.put(TabBubbleTeaCtr());
  }

  void clickTopTab(int i) {
    selectTopTabIndex.value = i;
    if (selectTopTabIndex.value == 0) {
      TabGamesFilterController.find.requestData();
    } else if (selectTopTabIndex.value == 1) {
      Get.to(() => NewsPage(id: 150));
    } else if (selectTopTabIndex.value == 2) {
      TabBubbleTeaCtr.find.requestData();
    }
  }
}
