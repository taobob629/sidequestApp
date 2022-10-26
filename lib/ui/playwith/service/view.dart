/**
    author:mac
    创建日期:2022/9/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/model/user_info_model.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/controller/user_controller.dart';
import 'package:wy/ui/playwith/balance/withdraw/record/coin_diamonds_record_page.dart';
import 'package:wy/ui/playwith/service/controller.dart';

class MoreGamesPage extends GetView<MoreGamesPageController> {
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    controller.initData();
    return Container();
    return BaseScaffold(
        title: "Wallet Records",
        body: Stack(
          children: [
            Positioned(
                left: 0, right: 0, top: 0, height: 40, child: _buildTabs()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 40,
              child: TabBarView(
                  controller: controller.tabController,
                  children: createPages()),
            )
          ],
        ));
  }

  Widget _buildTabs() {
    return TabBar(
      controller: controller.tabController,
      isScrollable: false,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white38,
      indicatorColor: Colors.white38,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      indicatorPadding: EdgeInsets.only(bottom: 5),
      labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
      labelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
      unselectedLabelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
      tabs: createTabs(),
    );
  }

  List<Widget> createTabs() {
    var userType = userController.userInfoModel.value.isauth;
    if (userType == TYPE_VIP) {
      return [
        Text(
          "WithDraw",
        ),
        Text(
          "Coin",
        ),
        Text(
          "Diamonds",
        )
      ];
    }
    return [
      Text(
        "Coin",
      )
    ];
  }

  List<Widget> createPages() {
    var userType = userController.userInfoModel.value.isauth;
    if (userType == TYPE_VIP) {
      return [
        KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_COIN)),
        KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_DIAMONDS))
      ];
    }
    return [KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_COIN))];
  }
}


