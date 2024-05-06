import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/profile/consume/tab_consume_page.dart';

import '../../../../common/base_scaffold.dart';
import '../../../../common/home_indicator.dart';
import '../../../../common/keep_alive_wrapper.dart';
import '../../../../config/app_color.dart';

class MyConsumePage extends StatelessWidget {
  final controller = Get.put(MyEventsPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "My Bill".tr,
        body: Stack(
          children: [
            Positioned(
                left: 0, right: 0, top: 0, height: 40, child: _buildTabs()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 40,
              child: TabBarView(
                  controller: controller.tabController,
                  children: createPages()),
            )
          ],
        ));
  }

  Widget _buildTabs() {
    return TabBar(
      controller: controller.tabController,
      isScrollable: false,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white38,
      indicatorColor: Colors.white38,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2,
      indicator: HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
      indicatorPadding: EdgeInsets.only(bottom: 5),
      labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
      labelStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "din",
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 20,
        fontFamily: "din",
      ),
      tabs: createTabs(),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Top Up".tr,
    ));
    tabs.add(Text(
      "Gaming".tr,
    ));
    tabs.add(Text(
      "Product".tr,
    ));
    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(
        child: TabConsumePage(
      type: 1,
    )));
    pages.add(KeepAliveWrapper(
        child: TabConsumePage(
      type: 2,
    )));
    pages.add(KeepAliveWrapper(
        child: TabConsumePage(
      type: 3,
    )));
    return pages;
  }
}

class MyEventsPageController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
