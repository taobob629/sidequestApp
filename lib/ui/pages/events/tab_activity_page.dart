import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api/events_api.dart';
import '../../../common/activity_item.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../model/activity_item_model.dart';

class TabActivityPage extends StatelessWidget {
  final controller = Get.put(TabActivityPageController());

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        onLoading: controller.loadMore,
        enablePullUp: true,
        child: CustomScrollView(
          slivers: [
            Obx(() {
              return SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                ActivityItemModel activity = controller.list[index];
                return ActivityItem(
                  model: activity,
                );
              }, childCount: controller.list.length));
            })
          ],
        ));
  }
}

class TabActivityPageController extends GetxRefreshController<ActivityItemModel> {
  @override
  void onInit() {
    super.onInit();
    this.pageSize = 10;
  }

  Future<List<ActivityItemModel>> loadData({int pageNum = 1}) async {
    List<ActivityItemModel> list = await EventsApi.activities(pageNum, pageSize);
    return list;
  }
}
