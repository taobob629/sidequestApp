import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/api/index_api.dart';
import 'package:sq_hub_app/common/keep_alive_wrapper.dart';
import 'package:sq_hub_app/config/icon_font.dart';
import 'package:sq_hub_app/ui/pages/home/tab_bundles_page.dart';
import 'package:sq_hub_app/ui/pages/home/tab_events_page.dart';
import 'package:sq_hub_app/ui/pages/home/tab_hubs_page.dart';

import '../../../config/app_color.dart';
import '../../../controller/user_controller.dart';
import '../../../model/index_tab_model.dart';
import 'tab_headlines_page.dart';
import 'tab_news_page.dart';

class IndexPage extends StatelessWidget {
  final controller = Get.put(IndexPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => !controller.isLoadFinish.value
        ? Container()
        : Column(
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
                        onTap: () => controller.clickTab(i),
                        child: Container(
                          width: 86.w,
                          decoration: controller.selectTabStr.value ==
                                  controller.tabs[i].name
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
                            controller.tabs[i].name,
                            style: TextStyle(
                              color: controller.selectTabStr.value ==
                                      controller.tabs[i].name
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
                  itemCount: controller.tabs.length,
                ),
              ),
              if (controller.selectTabStr.value.toLowerCase() ==
                  "Events".toLowerCase())
                Expanded(child: TabEventsPage()),
              if (controller.selectTabStr.value.toLowerCase() ==
                  "Bundles".toLowerCase())
                Expanded(child: TabBundlesPage()),
              if (controller.selectTabStr.value.toLowerCase() ==
                  "News".toLowerCase())
                Expanded(child: TabNewsPage()),
            ],
          ));
  }
}

class IndexPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;

  var isLoadFinish = false.obs;
  var selectTabStr = "Events".obs;
  List<IndexTabModel> tabs = [];

  @override
  void onInit() {
    super.onInit();

    Get.put(TabEventsPageController());
    Get.put(TabBundlesPageController());
    Get.put(TabNewsPageController());

    requestData();
  }

  void requestData() async {
    isLoadFinish.value = false;
    tabs.clear();
    tabs.addAll(await IndexApi.getIndexTabs());
    selectTabStr.value = tabs[0].name;

    tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: 0,
    );
    isLoadFinish.value = true;
  }

  void clickTab(int i) {
    selectTabStr.value = tabs[i].name;
    if (selectTabStr.value.toLowerCase() == "Events".toLowerCase()) {
      TabEventsPageController.find.onRefresh(init: true);
    } else if (selectTabStr.value.toLowerCase() == "Bundles".toLowerCase()) {
      TabBundlesPageController.find.requestStoreList();
    } else if (selectTabStr.value.toLowerCase() == "News".toLowerCase()) {
      TabNewsPageController.find.onRefresh(init: true);
    }
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
  }
}
