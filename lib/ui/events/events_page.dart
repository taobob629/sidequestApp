import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/events/tab_activity_page.dart';
import 'package:wy/ui/events/tab_match_page.dart';

class EventsPage extends StatelessWidget {

  final controller = Get.put(EventsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      TabBar(
                        controller: controller.tabController,
                        isScrollable: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white38,
                        indicatorColor: Colors.white38,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: HomeIndicator(),
                        indicatorWeight: 4,
                        indicatorPadding: EdgeInsets.only(bottom: 5),
                        labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                        labelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
                        unselectedLabelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
                        tabs: createTabs(),
                      ),
                      Spacer(),
                    ],
                  ),
                )
              ],
            )
          ),
        )
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: createPages()
      ),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text("Events",));
    tabs.add(Text("Tournaments",));

    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: TabActivityPage()));
    pages.add(KeepAliveWrapper(child: TabMatchPage()));
    return pages;
  }
}

class EventsPageController extends GetxController with GetSingleTickerProviderStateMixin{
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}