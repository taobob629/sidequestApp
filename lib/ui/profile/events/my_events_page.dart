import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/profile/events/tab_event_page.dart';
import 'package:wy/widget/anima_switch_widget.dart';

import '../../../widget/tab_widget.dart';
import '../../common/empty_view.dart';
import '../../events/events_page.dart';
import '../../frame/social/activity/list/view.dart';
import 'activity/activity_view.dart';

class MyEventsPage extends StatefulWidget {
  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {

  ///初始化函数
  Future initData() async {
    eventTab(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Activities".tr,
      body: ActivityView(),
      // body: Stack(
      //   children: [
      //     Positioned(
      //       left: 0,
      //       right: 0,
      //       top: 0,
      //       height: 40,
      //       child: _buildTabs()
      //     ),
      //     Positioned(
      //       left: 0,
      //       right: 0,
      //       bottom: 0,
      //       top: 40,
      //       child: TabBarView(
      //         controller: controller.tabController,
      //         children: createPages()
      //       ),
      //     )
      //   ],
      // )
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text(
      "Events".tr,
    ));
    tabs.add(Text(
      "Tournaments".tr,
    ));
    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(
        child: TabEventPage(
      type: 1,
    )));
    pages.add(KeepAliveWrapper(
        child: TabEventPage(
      type: 2,
    )));
    return pages;
  }
}

class MyEventsPageController extends GetxController with SingleGetTickerProviderMixin {
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
