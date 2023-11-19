import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/index/tab_cybercafe_page.dart';
import 'package:wy/ui/index/tab_games_page.dart';
import 'package:wy/ui/index/tab_headlines_page.dart';
import 'package:wy/ui/index/tab_news_page.dart';
import 'package:wy/widget/tab_widget.dart';

class IndexPage extends StatelessWidget {
  final controller = Get.put(IndexPageController());

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverToBoxAdapter(
          child: TabBar(
            controller: controller.tabController,
            isScrollable: true,
            indicatorColor: Colors.white38,
            indicatorSize: TabBarIndicatorSize.label,
            indicator:
                HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
            labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            indicatorWeight: 4,
            indicatorPadding: EdgeInsets.only(bottom: 5),
            labelStyle: selectTabStyle(TAB_STYLE_2),
            unselectedLabelStyle: unSelectTabStyle(TAB_STYLE_2),
            tabs: controller.createTabs(),
          ),
        )
      ],
      body: TabBarView(
        controller: controller.tabController,
        children: controller.createPages(),
      ),
    );
  }
}

class IndexPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Recommend".tr,
    ));
    tabs.add(Text(
      "News".tr,
    ));
    tabs.add(Text(
      "Games".tr,
    ));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: TabHeadlinesPage()));
    pages.add(KeepAliveWrapper(child: TabNewsPage()));
    pages.add(KeepAliveWrapper(child: TabGamesPage()));
    return pages;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      vsync: this,
      length: createTabs().length,
      initialIndex: 0,
    );
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        switch(tabController.index) {
          case 1:
            TabNewsPageController.find.onRefresh(init: true);
            break;
          case 2:
            TabGamePageController.find.loadData();
            break;
          case 3:
            CybercafeController.find.onRefresh(init: true);
            break;
        }
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  @override
  void onReady() async {
    super.onReady();
  }
}
