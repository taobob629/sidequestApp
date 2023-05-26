import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wy/model/withdraw_record_model.dart';
import 'package:wy/ui/common/empty_view.dart';
import 'package:wy/ui/playwith/balance/withdraw/record/controller.dart';
import 'package:wy/utils/utils.dart';
import 'package:wy/widget/scaffold_widget.dart';

import '../../widget/tips_dialog.dart';

/*
    view
    sidequest_hub_app
    desc:
    Created by chunma on .
    Copyright © sidequest_hub_app. All rights reserved.
 */
const TYPE_CASH = '0';
const TYPE_VOTES = '1';

class WithDrawRecordPage extends StatelessWidget {
  var type;

  WithDrawRecordPage(this.type) {
    initController();
  }

  initController() async {
    controller = Get.put(WithDrawRecordPageController(type), tag: type);
  }

  late WithDrawRecordPageController controller;

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
                            if (index.isOdd) {
                              return Divider(
                                color: Colors.white24,
                              );
                            }
                            WithdrawRecordModel model =
                                controller.list[index ~/ 2];
                            return recordItem(model);
                          }, childCount: controller.list.length * 2 - 1));
                        })
                      ],
                    ))),
    );
  }

  recordItem(WithdrawRecordModel model) {
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
                // getPayCardStr(model.card) ?? '',
                model.card ?? '',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '${model.statusText()}',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Visibility(
                    visible: model.status == 2,
                    child: GestureDetector(
                      onTapDown: (details) {
                        print(details.globalPosition);
                        Get.dialog(TipsDialog(
                          offset: details.globalPosition,
                          tips: '${model.note}',
                        ));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 6),
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFC3C02),
                                  Color(0xFF841FC3)
                                ])),
                        child: Text(
                          "?".tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "DIN",
                              fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                model.createTime ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              if (model.status == 0)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => controller.cancelWithDraw(model.id),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFFC3C02), Color(0xFF841FC3)])),
                    child: Text(
                      "Cancel".tr,
                      style: TextStyle(
                          color: Colors.white, fontFamily: "DIN", fontSize: 16),
                    ),
                  ),
                ),
              if (model.status == 0) 10.verticalSpace,
              Text(
                "£${model.money}",
                style: TextStyle(fontSize: 16, color: Color(0xFFFFA900)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
