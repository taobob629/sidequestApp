import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api/events_api.dart';
import '../../../common/getx_refresh_controller.dart';
import '../../../common/match_item.dart';
import '../../../model/match_item_model.dart';

class TabMatchPage extends StatelessWidget {
  final controller = Get.put(TabMatchPageController());

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
                MatchItemModel model = controller.list[index];
                return MatchItem(model: model);
              }, childCount: controller.list.length));
            })
          ],
        ));
  }
}

class TabMatchPageController extends GetxRefreshController<MatchItemModel> {
  @override
  void onInit() {
    super.onInit();
    this.pageSize = 10;
  }

  Future<List<MatchItemModel>> loadData({int pageNum = 1}) async {
    List<MatchItemModel> list = await EventsApi.matches(pageNum, pageSize);
    return list;
  }
}
