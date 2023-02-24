/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/common/base_controller.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/ui/frame/sidekick/controller.dart';
import 'package:wy/ui/frame/sidekick/widget/horizontal_list.dart';
import 'package:wy/utils/image_util.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/refresh_list.dart';

import 'controller.dart';
import 'widget/list_item.dart';

class ActivityListPage extends StatelessWidget {
  var type;
  late ActivityListController controller;

  ActivityListPage(this.type);

  @override
  Widget build(BuildContext context) {
    controller = Get.put(ActivityListController(type), tag: 'ActivityList_$type');
    controller.refreshController = RefreshController(initialRefresh: false);
    return Scaffold(
      body: Obx(() => biuldSmartRefresh(controller.refreshController,
          controller.pageState == PageState.sucess ? body(context) : controller.buildEmpty(),
          onRefresh: () {
            controller.onRefresh();
          },
          onLoad: () => controller.onLoadMore())),
    );
  }

  body(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var model = controller.mDatas[index];
        return ActivityListItemWidget(model);
      },
      itemCount: controller.mDatas.length,
    );
  }
}
