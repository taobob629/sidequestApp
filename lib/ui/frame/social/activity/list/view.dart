/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/common/list/index.dart';
import 'package:wy/common/page/basePage.dart';
import 'package:wy/widget/refresh_list.dart';

import 'controller.dart';
import 'widget/list_item.dart';

class ActivityListPage extends BasePage {
  ActivityListController? controller;

  ActivityListPage();

  body(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var model = pageController().mDatas[index];
        return ActivityListItemWidget(model);
      },
      itemCount: pageController().mDatas.length,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return biuldSmartRefresh(
        pageController().refreshController,
        pageController().pageState == PageState.sucess
            ? body(context)
            : pageController().buildEmpty(),
        onRefresh: () {
          pageController().onRefresh();
        },
        onLoad: () => pageController().onLoadMore());
  }

  @override
  RefreshListController pageController() {
    if (controller != null) return controller!;
    controller =
        Get.put(ActivityListController(), tag: 'ActivityList');
    controller!.refreshController = RefreshController(initialRefresh: false);
    return controller!;
  }
}
