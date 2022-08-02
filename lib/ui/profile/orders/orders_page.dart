import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/base_scaffold.dart';
import 'package:wy/ui/profile/orders/tab_order_page.dart';

class OrdersPage extends StatelessWidget {

  final int initialIndex;
  late final OrdersPageController controller;

  OrdersPage({this.initialIndex = 0}){
    controller = Get.put(OrdersPageController(initialIndex: initialIndex));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Orders",
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 40,
            child: _buildTabs()
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 40,
            child: TabBarView(
              controller: controller.tabController,
              children: createPages()
            ),
          )
        ],
      )
    );
  }

  Widget _buildTabs(){
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
      labelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
      unselectedLabelStyle: const TextStyle(fontSize: 20,fontFamily: "din"),
      tabs: createTabs(),
    );
  }

  List<Widget> createTabs() {
    List<Widget> tabs = [];
    tabs.add(Text("Pending",));
    tabs.add(Text("Paid",));
    tabs.add(Text("Delivered",));
    return tabs;
  }

  List<Widget> createPages() {
    List<Widget> pages = [];
    pages.add(KeepAliveWrapper(child: TabOrderPage(status: 0,)));
    pages.add(KeepAliveWrapper(child: TabOrderPage(status: 1,)));
    pages.add(KeepAliveWrapper(child: TabOrderPage(status: 2,)));
    return pages;
  }
}

class OrdersPageController extends GetxController with SingleGetTickerProviderMixin{
  late TabController tabController;

  int initialIndex = 0;
  OrdersPageController({required this.initialIndex});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: 3, initialIndex: initialIndex);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}