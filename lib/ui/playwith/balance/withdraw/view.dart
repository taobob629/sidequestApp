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

import 'record/withdraw_record_page.dart';

class WithDrawMainPage extends StatelessWidget {
  final controller = Get.put(WithDrawMainPageController());
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "Wallet Records".tr,
        body: Stack(
          children: [
            Positioned(left: 0, right: 0, top: 0, height: 40, child: _buildTabs()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 40,
              child: TabBarView(controller: controller.tabController,
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
          "WithDraw".tr,
        ),
        Text(
          "Coin".tr,
        ),
        Text(
          "Diamonds".tr,
        )
      ];
    }
    return [
      Text(
        "Coin".tr,
      )
    ];
  }

  List<Widget> createPages() {
    var userType = userController.userInfoModel.value.isauth;
    if (userType == TYPE_VIP) {
      return [
        KeepAliveWrapper(child: WithDrawRecordPage(TYPE_CASH)),
        KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_COIN)),
        KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_DIAMONDS))
      ];
    }
    return [KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_COIN))];
  }
}

class WithDrawMainPageController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    var userType = Get.find<UserController>().userInfoModel.value.isauth;
    tabController = TabController(
        vsync: this, length: userType == TYPE_VIP ? 3 : 1, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
