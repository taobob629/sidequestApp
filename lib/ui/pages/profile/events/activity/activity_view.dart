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

import '../../../../../common/basePage.dart';
import '../../../../../common/base_controller.dart';
import '../../../../../common/refresh_list.dart';
import '../../../../../common/refreshlist_controller.dart';
import '../../../social/activity/list/widget/list_item.dart';
import 'activity_ctr.dart';

class ActivityView extends BasePage {
  ActivityCtr? controller;

  ActivityView();

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
    controller = Get.put(ActivityCtr(), tag: 'ActivityList');
    controller!.refreshController = RefreshController(initialRefresh: false);
    return controller!;
  }
}
