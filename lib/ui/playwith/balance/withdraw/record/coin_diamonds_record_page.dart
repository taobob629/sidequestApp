import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/balance_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/common/string_ext.dart';
import 'package:wy/config/app_pages.dart';
import 'package:wy/model/coin_records_model.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

/*
    view
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 */
const String TYPE_COIN = '0'; //金币
const String TYPE_DIAMONDS = '1'; //钻石

class CoinAndDiamondsRecordPage extends StatelessWidget {
  final String type;

  CoinAndDiamondsRecordPage(this.type) {
    initController();
  }

  late CoinAndDiamondsRecordPageController controller;

  initController() async {
    controller = Get.put(CoinAndDiamondsRecordPageController(type), tag: type);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
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
                  : CustomScrollView(
                      slivers: [
                        Obx(() {
                          return SliverList(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            if (index.isOdd) {
                              return Divider(
                                color: Colors.white24,
                              );
                            }
                            CoinRecordsModel model = controller.list[index ~/ 2];
                            return InkWell(
                              onTap: () {
                                if (model.actionid! <= 0) {
                                  return;
                                }
                                Get.toNamed(AppPages.OrderDetail,
                                arguments: Map()
                                ..['id'] = model.actionid);
                              //  Get.to(() => OrderDetail(orderId: model.actionid!));
                              },
                              child: recordItem(model),
                            );
                          }, childCount: controller.list.length * 2 - 1));
                        })
                      ],
                    ))),
    );
  }

  recordItem(CoinRecordsModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Text(
                'With Draw',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),*/
              // SizedBox(
              //   height: 10,
              // ),
              Text(
                model.actionName ?? '-',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              /*  Text(
                'uid:${model.uid}',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),*/
              // SizedBox(
              //   height: 10,
              // ),
              Text(
                '${model.addtime?.toDateStr}',
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${model.total!.isNegative ? '' : '+'}${model.total}",
                    style: TextStyle(fontSize: 16, color: model.total?.isNegative == false ? Colors.green : Color(0xFFFFA900)),
                  ),
                  PWidget.boxw(3),
                  PWidget.image('assets/images/${type == TYPE_COIN ? 'ic_balance_money' : 'ic_balance_votes'}.webp', [16, 16, null, BoxFit.cover]),
                ],
              ),
              PWidget.boxh(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${'Remaining'.tr}: ${type == TYPE_COIN ? model.afterChangeCoin : model.afterChangeVotes}",
                    style: TextStyle(fontSize: 14, color: Colors.white54),
                  ),
                  PWidget.boxw(3),
                  PWidget.image('assets/images/${type == TYPE_COIN ? 'ic_balance_money' : 'ic_balance_votes'}.webp', [16, 16, null, BoxFit.cover]),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CoinAndDiamondsRecordPageController extends GetxRefreshController {
  var type;

  CoinAndDiamondsRecordPageController(this.type);

  @override
  void onInit() {
    initialRefresh = true;
    super.onInit();
  }

  @override
  Future<List<CoinRecordsModel>> loadData({int pageNum = 1}) async {
    var list = await BalanceApi.coinAndVotesRecords(pageNum, pageSize, type);
    return list;
  }
}
