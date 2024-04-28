/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/keep_alive_wrapper.dart';
import 'controller.dart';
import 'list/view.dart';

class ActivityTabPage extends StatefulWidget {
  @override
  State<ActivityTabPage> createState() => _ActivityTabPageState();
}

class _ActivityTabPageState extends State<ActivityTabPage>
    with SingleTickerProviderStateMixin {
  ActivityTabController controller = Get.put(ActivityTabController());

  @override
  void initState() {
    super.initState();
    // init();
  }

  init() async {
    controller.initTabs().then((tabs) {
      // 找到默认显示的tab
      controller.tabs = tabs;
      controller.tabbarController =
          TabController(length: tabs.length, vsync: this)
            ..addListener(() {
              controller.curTab = tabs[controller.tabbarController?.index ?? 0];
            })
            ..animateTo(controller.tabs.indexOf(controller.curTab!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeepAliveWrapper(child: ActivityListPage()),
    );
  }

  // List<Widget> tabPages() {
  //   return controller.tabs
  //       .map((tab) => KeepAliveWrapper(child: ActivityListPage('${tab.type}')))
  //       .toList();
  // }

  // buildTabs() {
  //   return controller.tabs.map((m) {
  //     return Obx(() => Container(
  //           height: 30.h,
  //           padding: EdgeInsets.only(left: 10, right: 10),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(23).r,
  //               gradient: controller.curTab == m
  //                   ? LinearGradient(colors: [
  //                       Color(0xFF612AD7),
  //                       Color(0xFFBE39CC),
  //                       Color(0xFFE68887),
  //                     ])
  //                   : LinearGradient(colors: [
  //                       AppColor.tabBackGround,
  //                       AppColor.tabBackGround
  //                     ])),
  //           child: Tab(
  //             text: '$m',
  //           ),
  //         ));
  //   }).toList();
  // }

  selectTabStyle() {}

  unSelectTabStyle() {}
}
