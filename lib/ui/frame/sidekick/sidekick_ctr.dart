/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/base_tab_controller.dart';

class SideKickCtr extends BaseTabContoller {
  @override
  initTabs() {
    tabs = ['Sidekick'.tr, 'Ranking'.tr];
  }

  @override
  void onInit() {
    super.onInit();

    tabbarController = TabController(length: tabs.length, vsync: this);
  }
}
