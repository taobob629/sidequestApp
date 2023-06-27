/**
    author:mac
    创建日期:2023/2/22
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wy/common/base_tab_controller.dart';

import '../../../config/icon_font.dart';

class SideKickCtr extends BaseTabContoller {
  static SideKickCtr get find => Get.find();

  List<Widget> tabsList = [
    Text(
      'Sidekick',
    ),
    Text(
      'Leaderboard',
    ),
  ];

  @override
  initTabs() {}

  @override
  void onInit() {
    super.onInit();

    tabbarController = TabController(length: tabsList.length, vsync: this);
  }
}
