/**
    author:mac
    创建日期:2022/9/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/playwith/balance/withdraw/record/coin_diamonds_record_page.dart';

import 'record/withdraw_record_page.dart';

class WithDrawMainPage extends StatelessWidget {
  final controller = Get.put(WithDrawMainPageController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: "WithDraw Records",
        body: Stack(
          children: [
            Positioned(left: 0, right: 0, top: 0, height: 40, child: _buildTabs()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 40,
              child: TabBarView(controller: controller.tabController, children: createPages()),
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
    List<Widget> tabs = [];
    tabs.add(Text(
      "WithDraw",
    ));
    tabs.add(Text(
      "Coin",
    ));
    tabs.add(Text(
      "Diamonds",
    ));
    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: WithDrawRecordPage(TYPE_CASH)));
    pages.add(KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_COIN)));
    pages.add(KeepAliveWrapper(child: CoinAndDiamondsRecordPage(TYPE_DIAMONDS)));
    return pages;
  }
}

class WithDrawMainPageController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
