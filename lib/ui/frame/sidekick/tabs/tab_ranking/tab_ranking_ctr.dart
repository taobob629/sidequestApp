import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/base_tab_controller.dart';

class TabRankingCtr extends BaseTabContoller {

  var selectCatIndex = 0.obs;

  @override
  initTabs() {
    tabs = ['Month'.tr, 'Week'.tr, 'Day'.tr];
  }

  @override
  void onInit() {
    super.onInit();

    tabbarController = TabController(length: tabs.length, vsync: this);
  }
}