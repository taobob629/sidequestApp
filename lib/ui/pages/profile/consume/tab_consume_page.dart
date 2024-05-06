import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sq_hub_app/ui/pages/profile/consume/record_item.dart';

import '../../../../api/balance_api.dart';
import '../../../../common/empty_view.dart';
import '../../../../common/getx_refresh_controller.dart';
import '../../../../model/balance_record_model.dart';
import '../../../../utils/utils.dart';

class TabConsumePage extends StatelessWidget {
  final int type;

  late final TabConsumePageController controller;

  TabConsumePage({required this.type}) {
    controller = Get.put(TabConsumePageController(type: type), tag: "$type");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        onLoading: controller.loadMore,
        enablePullUp: true,
        child: controller.initializing.value
            ? Container()
            : controller.list.isEmpty
                ? Stack(
                    children: [
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: EmptyView())
                    ],
                  )
                : CustomScrollView(
                    slivers: [
                      Obx(() {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              ConsumeRecordModel model = controller.list[index];
                              return RecordItem(
                                type: type,
                                model: model,
                              );
                            },
                            childCount: controller.list.length,
                          ),
                        );
                      })
                    ],
                  ),
      ),
    );
  }
}

class TabConsumePageController extends GetxRefreshController {
  late int type;

  TabConsumePageController({required this.type});

  @override
  void onInit() {
    if (type == 1) {
      this.initialRefresh = true;
    }
    super.onInit();
  }

  @override
  Future<List<ConsumeRecordModel>> loadData({int pageNum = 1}) async {
    if (type == 1) {
      List<ConsumeRecordModel> list =
          await BalanceApi.chargeRecords(pageNum, pageSize);

      return list;
    } else if (type == 2) {
      List<ConsumeRecordModel> list =
          await BalanceApi.machineRecords(pageNum, pageSize);
      return list;
    } else {
      List<ConsumeRecordModel> list =
          await BalanceApi.consumeRecords(pageNum, pageSize);
      flog(type, 'ConsumeRecordModel');
      return list;
    }
  }
}
