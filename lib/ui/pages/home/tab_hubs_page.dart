import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/image_utils.dart';
import 'package:sq_hub_app/ui/pages/home/tab_bundles_page.dart';

import '../../../config/app_color.dart';
import '../../../config/icon_font.dart';
import '../../../getx_ctr/tab_bubble_tea_ctr.dart';
import '../../../model/beans/games_left_tab_bean.dart';
import '../hubs/tab/tab_bubble_tea_page.dart';
import '../hubs/tab/tab_games_filter_page.dart';
import '../stores/tab_cybercafe_page.dart';
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
          if (controller.selectTopTabIndex.value == 0) Expanded(child: TabBubbleTeaPage()),
          if (controller.selectTopTabIndex.value == 1) Expanded(child: TabBundlesPage()),
          if (controller.selectTopTabIndex.value == 2) Expanded(child: TabGamesFilterPage()),
          // if (controller.selectTopTabIndex.value == 3) TabCybercafePage(),
        ],
      ));
}

class TabHubsPageController extends GetxController {
  static TabHubsPageController get find => Get.find();

  List<String> topTabs = [
    "Bubble tea".tr,
    "Bundles".tr,
    "Games".tr,
  ];

  var selectTopTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    Get.put(TabGamesFilterController());
    Get.put(TabBubbleTeaCtr());
    Get.put(TabBundlesPageController());
    // Get.put(CybercafeController());
  }

  @override
  void onReady() {
    super.onReady();

    clickTopTab(selectTopTabIndex.value);
  }

  void clickTopTab(int i) {
    // if (i == 1) {
    //   Get.to(() => NewsPage(id: 150));
    //   return;
    // }
    selectTopTabIndex.value = i;
    if (selectTopTabIndex.value == 0) {
      TabBubbleTeaCtr.find.requestData();
    } else if (selectTopTabIndex.value == 1) {
      TabBundlesPageController.find.requestStoreList();
    } else if (selectTopTabIndex.value == 2) {
      TabGamesFilterController.find.requestData();
    }
    // else if (selectTopTabIndex.value == 3) {
    //   CybercafeController.find.onRefresh();
    // }
  }
}
