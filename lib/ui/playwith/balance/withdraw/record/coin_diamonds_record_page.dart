import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/api/balance_api.dart';
import 'package:wy/common/getx_refresh_controller.dart';
import 'package:wy/model/coin_records_model.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/im/order_detail.dart';
import 'package:wy/utils/utils.dart';
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
          onRefresh: controller.refresh,
          onLoading: controller.loadMore,
          enablePullUp: true,
          child: controller.initializing.value
              ? Container()
              : controller.list.length == 0
                  ? Stack(
                      children: [
                        Positioned(left: 0, right: 0, top: 0, bottom: 0, child: EmptyView())
                      ],
                    )
                  : CustomScrollView(
                      slivers: [
                        Obx(() {
                          return SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((BuildContext context, int index) {
                            if (index.isOdd) {
                              return Divider(
                                color: Colors.white24,
                              );
                            }
                            CoinRecordsModel model = controller.list[index ~/ 2];
                            return InkWell(
                              onTap: (){
                                Get.to(() => OrderDetail(orderId: model.actionid!));
                              },
                              child: recordItem(model),);
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
              SizedBox(
                height: 10,
              ),
              Text(
                '${model.datatime}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
          Spacer(),
          Text(
            "${model.total}",
            style: TextStyle(fontSize: 16, color: Color(0xFFFFA900)),
          ),
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
