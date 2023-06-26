/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wy/common/base_tab_controller.dart';

class SideKickCtr extends BaseTabContoller {

  static SideKickCtr get find => Get.find();

  @override
  initTabs() {
    tabs = ['Sidekick'.tr, 'Leaderboard'.tr];
  }

  @override
  void onInit() {
    super.onInit();

    tabbarController = TabController(length: tabs.length, vsync: this);
  }
}
