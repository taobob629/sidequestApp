/*
  view
  sidequest_hub_app
  desc:
  Created by chunma on .
  Copyright © sidequest_hub_app. All rights reserved.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/keep_alive_wrapper.dart';
import 'package:wy/ui/common/home_indicator.dart';
import '../coupon_page.dart';
import 'controller.dart';


class CouponTabPage extends GetView<CouponTabController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: TabBar(
            controller: controller.tabController,
            labelStyle: const TextStyle(fontSize: 20, fontFamily: "din"),
            indicatorPadding: EdgeInsets.only(bottom: 5),
            indicator: HomeIndicator(
                colors: [Color.fromRGBO(252, 60, 2, 1), Color.fromRGBO(132, 31, 195, 1)]),
            tabs: controller.tabs.map((String title) => Tab(text: title)).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          KeepAliveWrapper(child: CouponPage(tab:CouponPage.TYPE_STORE,showAppbar: false,)),
          KeepAliveWrapper(child: CouponPage(tab:CouponPage.TYPE_SIDE_KICK,showAppbar: false)),
        ],
      ),
    );
  }
}
