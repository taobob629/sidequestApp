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

import 'controller.dart';
import 'list/view.dart';

class OrderTabPage extends StatefulWidget {
  @override
  State<OrderTabPage> createState() => _OrderTabPageState();
}

class _OrderTabPageState extends State<OrderTabPage> with SingleTickerProviderStateMixin {
  OrderTabController controller = Get.put(OrderTabController());

  @override
  void initState() {
    super.initState();
    flog('init');
    init();
  }

  init() async {
    controller.tabbarController = TabController(length: controller.initTabs().length, vsync: this)
      ..addListener(() {
        controller.curTab = controller.tabbarController?.index ?? 0;
        flog('curTab ${controller.curTab}');
      })
      ..animateTo(controller.curTab!);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.tabs.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
                titleSpacing: 0,
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: TabBar(
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
        .map((tab) => KeepAliveWrapper(child: OrderListListPage(tab['type'])))
       // .map((tab) =>OrderListListPage(tab['type']))
        .toList();
  }

  buildTabs() {
    return controller.tabs.map((m) {
      return Obx(() => Container(
            height: 30.h,
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23).r,
                gradient: controller.curTab == m['index']
                    ? LinearGradient(colors: [
                        Color(0xFF612AD7),
                        Color(0xFFBE39CC),
                        Color(0xFFE68887),
                      ])
                    : LinearGradient(colors: [AppColor.tabBackGround, AppColor.tabBackGround])),
            child: Tab(
              text: '${m['title']}',
            ),
          ));
    }).toList();
  }

  selectTabStyle() {}

  unSelectTabStyle() {}
}
