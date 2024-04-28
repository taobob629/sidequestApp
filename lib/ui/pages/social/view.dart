/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/ui/pages/social/post/post_list_page.dart';

import '../../../../common/home_indicator.dart';
import '../../../../common/keep_alive_wrapper.dart';
import '../../../../config/app_color.dart';
import '../../../../widget/tab_widget.dart';
import 'activity/view.dart';
import 'controller.dart';

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
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: TabWidget(
            tabstyle: TAB_STYLE_2,
            indicator: HomeIndicator(colors: [AppColor.yellow, AppColor.yellow]),
            alignment: Alignment.centerLeft,
            tabController: controller.tabbarController,
            tabList: controller.tabs,
            pagePhysics: NeverScrollableScrollPhysics(),
            tabPage: [
              PostListPage(),
              KeepAliveWrapper(child: ActivityTabPage()),
             // KeepAliveWrapper(child: GroupList()),
            ],
          ),
        ));
  }
}
