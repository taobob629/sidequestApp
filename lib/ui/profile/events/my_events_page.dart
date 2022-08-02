import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/profile/events/tab_event_page.dart';

class MyEventsPage extends StatelessWidget {

  final controller = Get.put(MyEventsPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Activities",
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 40,
            child: _buildTabs()
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 40,
            child: TabBarView(
              controller: controller.tabController,
              children: createPages()
            ),
          )
        ],
      )
    );
  }

  Widget _buildTabs(){
    return TabBar(
      controller: controller.tabController,
      isScrollable: false,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white38,
      indicatorColor: Colors.white38,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      indicatorPadding: EdgeInsets.only(bottom: 5),
      labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
      labelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
      unselectedLabelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
      tabs: createTabs(),
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
    pages.add(KeepAliveWrapper(child: TabEventPage(type: 1,)));
    pages.add(KeepAliveWrapper(child: TabEventPage(type: 2,)));
    return pages;
  }
}

class MyEventsPageController extends GetxController with SingleGetTickerProviderMixin{
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