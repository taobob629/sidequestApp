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
import 'package:wy/ui/service/skill/list/controller.dart';
import 'package:wy/ui/service/skill/list/view.dart';
import 'package:wy/widget/tab_widget.dart';

import 'controller.dart';


class ServiceAndOrdersPage extends StatefulWidget {
  @override
  State<ServiceAndOrdersPage> createState() => _State();
}

class _State extends State<ServiceAndOrdersPage> with SingleTickerProviderStateMixin {
  var controller = Get.put(ServiceAndOrdersTabController());

  @override
  void initState() {
    super.initState();
    Get.put(SkillListPageController());
    controller.tabbarController = TabController(length: controller.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sidekick'.tr),),
      body: TabWidget(
        tabstyle: TAB_STYLE_2,
        indicator: HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
        alignment: Alignment.centerLeft,
        tabController: controller.tabbarController,
        tabList: controller.tabs,
        tabPage: [
          KeepAliveWrapper(child: SkillListPage(tabWidget: true,)),
        ],
      ),
    );
  }
}
