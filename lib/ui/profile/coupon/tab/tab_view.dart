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
import 'package:wy/ui/common/page_title.dart';

import '../coupon_page.dart';
import 'controller.dart';

class CouponTabPage extends GetView<CouponTabController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageTitle(title: 'Store'.tr),
      ),
      body: CouponPage(
        tab: CouponPage.TYPE_STORE,
        showAppbar: false,
      ),
    );
  }
}
