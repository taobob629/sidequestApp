/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/frame/social/activity/controller.dart';
import 'package:wy/ui/frame/social/activity/list/view.dart';
import 'package:wy/utils/index.dart';
import 'package:wy/widget/views.dart';

class ActivityTabPage extends StatefulWidget {
  @override
  State<ActivityTabPage> createState() => _ActivityTabPageState();
}

class _ActivityTabPageState extends State<ActivityTabPage> with SingleTickerProviderStateMixin {
  ActivityTabController controller = Get.put(ActivityTabController());

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    controller.initTabs().then((tabs) {
      flog('initTabs $tabs');
      controller.tabbarController = TabController(length: tabs.length, vsync: this)
        ..addListener(() {
          controller.curTab = tabs[controller.tabbarController?.index ?? 0];
        });
      controller.tabs = tabs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.tabs.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
                toolbarHeight: 20.h,
                bottom: TabBar(
                  controller: controller.tabbarController,
                  labelColor: Colors.white,
                  isScrollable: true,
                  indicator: BoxDecoration(),
                  labelStyle: selectTabStyle(),
                  unselectedLabelStyle: unSelectTabStyle(),
                  tabs: buildTabs(),
                )),
            body: TabBarView(
              controller: controller.tabbarController,
              children: tabPages(),
            ),
          )
        : buildLoad());
  }

  List<Widget> tabPages() {
    return controller.tabs
        .map((tab) => KeepAliveWrapper(child: ActivityListPage('${tab.type}')))
        .toList();
  }

  buildTabs() {
    return controller.tabs.map((m) {
      return Obx(() => Container(
            height: 30.h,
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23).r,
                gradient: controller.curTab == m
                    ? LinearGradient(colors: [
                        Color(0xFF612AD7),
                        Color(0xFFBE39CC),
                        Color(0xFFE68887),
                      ])
                    : LinearGradient(colors: [AppColor.tabBackGround, AppColor.tabBackGround])),
            child: Tab(
              text: '$m',
            ),
          ));
    }).toList();
  }

  selectTabStyle() {}

  unSelectTabStyle() {}
}
