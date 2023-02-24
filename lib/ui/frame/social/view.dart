/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/config/app_color.dart';
import 'package:wy/ui/common/home_indicator.dart';
import 'package:wy/ui/events/events_page.dart';
import 'package:wy/ui/frame/social/controller.dart';
import 'package:wy/widget/tab_widget.dart';

import 'activity/view.dart';

class SocialPage extends StatefulWidget {
  @override
  State<SocialPage> createState() => _State();
}

class _State extends State<SocialPage> with SingleTickerProviderStateMixin {
  var controller = Get.put(SocialTabController());

  @override
  void initState() {
    super.initState();
    controller.tabbarController = TabController(length: controller.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Scaffold(
          appBar: AppBar(),
          body: TabWidget(
            tabstyle: TAB_STYLE_2,
            indicator: HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
            alignment: Alignment.centerLeft,
            tabController: controller.tabbarController,
            tabList: controller.tabs,
            tabPage: [
              KeepAliveWrapper(child: EventsPage()),
              KeepAliveWrapper(child: Container()),
            ],
          ),
        ));
  }
}
