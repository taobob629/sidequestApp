import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/notification_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/config/app_config.dart';
import 'package:wy/model/notification_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/common/empty_view.dart';

import 'notification_item.dart';

class NotificationPage extends StatelessWidget {
  final controller = Get.put(NotificationPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "Notifications".tr,
        body: Obx(() => SmartRefresher(
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              onLoading: controller.loadMore,
              enablePullUp: true,
              child: controller.initializing.value
                  ? Container()
                  : controller.list.length == 0
                      ? Stack(
                          children: [Positioned(left: 0, right: 0, top: 0, bottom: 0, child: EmptyView())],
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return NotificationItem(
                              model: controller.list[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 15,
                            );
                          },
                          itemCount: controller.list.length),
            )));
  }
}

class NotificationPageController extends GetxRefreshController<NotificationModel> {
  @override
  void onInit() {
    this.initialRefresh = true;
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await AppConfig.flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<NotificationModel>> loadData({int pageNum = 1}) async {
    List<NotificationModel> list = await NotificationApi.list(pageNum, pageSize);

    return list;
  }
}
